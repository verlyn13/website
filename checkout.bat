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

REM Store the rendered content in a temporary directory outside the repo
echo Copying rendered content to a temporary directory...
xcopy /E /I /Y "_site" "..\temp_site"
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to copy rendered content. Exiting...
  goto :error
)

REM Add and commit to main
echo Committing changes to the main branch...
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
git clean -fdx
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to clear old content. Exiting...
  goto :error
)

REM Copy new content from the temporary directory to gh-pages
echo Copying new content to gh-pages...
xcopy /E /I /Y "..\temp_site\*" "."
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to copy new content. Exiting...
  goto :error
)

REM Stage and commit changes in gh-pages
echo Committing new content to gh-pages...
git add --all
git commit -m "Update website"
git push origin gh-pages
IF !ERRORLEVEL! NEQ 0 (
  echo Failed to push to gh-pages. Exiting...
  goto :error
)

echo Checkout process completed.
goto :end

:error
echo An error occurred, please check the messages above.
pause

:end
ENDLOCAL
