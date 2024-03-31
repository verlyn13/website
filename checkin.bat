@echo off
echo Starting check-in process...
echo.

echo Checking out main branch...
git checkout main

echo Fetching latest updates from GitHub...
git fetch origin main

echo Resetting local changes and matching the state of GitHub...
git reset --hard origin/main

echo Cleaning any files not tracked by Git...
git clean -fdx

echo Check-in process completed.

pause
