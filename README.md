# heroku-monorepo-deploy-script
This script automates deployment of a filtered subset of a monorepo (e.g., a bot and shared logic) to a specific Heroku app. It performs a temporary clone, filters the necessary folders, injects deployment-specific files, and force-pushes to Heroku.
