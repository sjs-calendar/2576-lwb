#!/bin/bash
set -e

# Cron doesn't give us a full environment, so set important vars
export HOME="/home/mike"
export PATH="/usr/bin:/bin:/usr/local/bin:$HOME/.local/bin"

REPO_DIR="$HOME/2576-lwb"
SCRAPE_COMMAND="$HOME/vacasa/venv/bin/python $HOME/vacasa/scrape_vacasa.py true false true"

cd "$REPO_DIR"

# Pull latest changes using correct SSH alias
git pull origin main

# Run the scraper to generate a new .ics file
$SCRAPE_COMMAND

# Copy the generated file into the repo root
cp output/calendar.ics calendar.ics

# Check if calendar.ics changed, then commit and push if so
if ! git diff --quiet calendar.ics; then
  echo "$(date) - Change detected, committing..."
  git add calendar.ics
  git commit -m "Auto-update calendar.ics"
  git push origin main
else
  echo "$(date) - No changes to calendar.ics"
fi
echo "https://sjs-calendar.github.io/2576-lwb/calendar.ics"
