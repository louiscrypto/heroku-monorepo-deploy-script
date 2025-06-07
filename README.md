# 🧠 Heroku Deploy Script

A powerful Bash script to deploy **selected folders from a monorepo** to a **Heroku app**, using git filter-repo to isolate only what's needed. It is designed to be **generic and reusable** for any app or directory structure.

## ✅ Features

- 📁 Deploy specific folders only (e.g., bot, shared, api, etc.)
- 🔀 Works with any Git branch (defaults to main)
- ⚙️ Automatically injects Procfile, setup.py, requirements.txt into root
- 🧹 Temporary clone + cleanup workflow
- ⚡ Force-pushes to Heroku and scales web=1 dyno
- 🧪 Safe and idempotent; avoids pushing unnecessary history/files

## 🚀 Usage

Make sure the script is executable:

```bash
chmod +x deploy-to-heroku.sh
```

Then run:

```bash
./deploy-to-heroku.sh --app <heroku-app-name> --paths <folder1> [folder2 ...] [--branch <branch-name>]
```

### 🔍 Example

```bash
./deploy-to-heroku.sh --app tgm-new-bot --paths bot shared --branch main
```

### ⚙️ Parameters

- `--app` - **(Required)** The name of your Heroku app
- `--paths` - **(Required)** Space-separated list of folders to deploy
- `--branch` - *(Optional)* Git branch to push to on Heroku (default: `main`)
- `--help` - Show help menu

## 🧱 Folder Structure Expected

You must have `requirements.txt`, `Procfile`, and `setup.py` inside the **first folder** passed in `--paths`. These will be copied to the root of the temporary project for Heroku:

```
.
├── bot/
│   ├── requirements.txt
│   ├── Procfile
│   ├── setup.py
│   └── ...
├── shared/
│   └── ...
└── deploy-to-heroku.sh
```

## 📦 Example Output

```
📦 Deploying to Heroku app: tgm-new-bot
📂 Including paths: bot shared
🌿 Branch: main

Cloning into 'tmp-deploy-tgm-new-bot'...
Rewrite bot/
Rewrite shared/
[main 1a2b3c4] chore: add root deployment files for Heroku
Pushing to https://git.heroku.com/tgm-new-bot.git
Scaling dynos... done

✅ Deployment complete for Heroku app: tgm-new-bot
```

## 🧰 Requirements

- `git-filter-repo` *(Install via Homebrew: `brew install git-filter-repo` or pipx: `pipx install git-filter-repo`)*
- Heroku CLI
- Unix environment with Git and Bash

## 🙋 FAQ

**🔄 What happens to other folders/files?**
They are **excluded** from the push via `git filter-repo`. Only what you specify in `--paths` will be included in the deployment.

**🔐 What about Heroku authentication?**
Make sure you're authenticated via `heroku login` and that the CLI can access the app.

## 📝 License

MIT License. Use at your own risk and customize as needed.

## 👤 Author

Crafted by @louiscrypto for streamlined Heroku monorepo deployments.
