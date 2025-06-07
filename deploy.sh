#!/usr/bin/env bash
set -euo pipefail

show_help() {
  echo "Usage: $0 --app <heroku-app-name> --paths <folder1> [folder2 ...] [--branch <branch>]"
  echo ""
  echo "Example:"
  echo "  $0 --app my-heroku-app --paths bot shared --branch main"
}

# --- Parse arguments ---
HEROKU_APP=""
DEPLOY_BRANCH="main"
DEPLOY_PATHS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --app)
      HEROKU_APP="$2"
      shift 2
      ;;
    --paths)
      shift
      while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
        DEPLOY_PATHS+=("$1")
        shift
      done
      ;;
    --branch)
      DEPLOY_BRANCH="$2"
      shift 2
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown parameter: $1"
      show_help
      exit 1
      ;;
  esac
done

# --- Validate ---
if [[ -z "$HEROKU_APP" || ${#DEPLOY_PATHS[@]} -eq 0 ]]; then
  echo "❌ Missing required arguments."
  show_help
  exit 1
fi

# --- Setup ---
ROOT_DIR="$(pwd)"
TMP_DIR="${ROOT_DIR}/tmp-deploy-${HEROKU_APP}"
FILTER_ARGS=()

for path in "${DEPLOY_PATHS[@]}"; do
  FILTER_ARGS+=(--path "$path")
done

echo "📦 Deploying to Heroku app: $HEROKU_APP"
echo "📂 Including paths: ${DEPLOY_PATHS[*]}"
echo "🌿 Branch: $DEPLOY_BRANCH"
echo ""

# --- Clean & clone ---
rm -rf "$TMP_DIR"
git clone --no-local . "$TMP_DIR"
pushd "$TMP_DIR" >/dev/null

# --- Filter paths ---
git filter-repo "${FILTER_ARGS[@]}"

# --- Copy Heroku deployment files from first path ---
SOURCE_DIR="${DEPLOY_PATHS[0]}"
cp "${SOURCE_DIR}/requirements.txt" requirements.txt || true
cp "${SOURCE_DIR}/Procfile" Procfile || true
cp "${SOURCE_DIR}/setup.py" setup.py || true

# --- Commit files if added ---
git add requirements.txt Procfile setup.py 2>/dev/null || true
git commit -m "chore: add root deployment files for Heroku" || true

# --- Add Heroku remote & deploy ---
git remote add heroku "https://git.heroku.com/${HEROKU_APP}.git"
git push heroku "HEAD:${DEPLOY_BRANCH}" --force
heroku ps:scale web=1 -a "$HEROKU_APP"

# --- Cleanup ---
popd >/dev/null
rm -rf "$TMP_DIR"
cd "$ROOT_DIR"

echo "✅ Deployment complete for Heroku app: ${HEROKU_APP}"
