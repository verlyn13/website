@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

echo Starting checkout process...

REM Render the Quarto project
echo Rendering Quarto project...
quarto render
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to render Quarto project. Exiting...
  goto :error
)

REM Add and commit to main
echo Committing changes to the main branch...
git checkout main
git add .
git commit -m "Local changes"
git push origin main
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to push changes to main. Exiting...
  goto :error
)

REM Switch to gh-pages branch
echo Switching to gh-pages branch...
git checkout gh-pages
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to switch to gh-pages branch. Exiting...
  goto :error
)

REM Clear gh-pages branch
echo Clearing old content from gh-pages...
git rm -rf *
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to clear old content. Exiting...
  goto :error
)

REM Copy new content from _site to gh-pages
echo Copying new content from _site to gh-pages...
xcopy /E /I /Y "_site" "."
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to copy new content. Exiting...
  goto :error
)

REM Stage changes in gh-pages
echo Staging changes in gh-pages...
git add -A
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to stage changes in gh-pages. Exiting...
  goto :error
)

REM Commit changes to gh-pages
echo Committing changes to gh-pages...
git commit -m "Update website"
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to commit changes to gh-pages. Exiting...
  goto :error
)

REM Push changes to gh-pages
echo Pushing changes to gh-pages...
git push origin gh-pages
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to push changes to gh-pages. Exiting...
  goto :error
)

echo Checkout process completed.
goto :end

:error
echo An error occurred, please check the messages above.
pause

:end
ENDLOCAL