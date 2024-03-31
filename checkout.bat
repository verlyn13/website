@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

echo Starting checkout process...
echo.

REM Render the Quarto project
echo Rendering Quarto project...
quarto render
IF !ERRORLEVEL! NEQ 0 (
    echo Failed to render Quarto project. Exiting...
    goto :error
)

REM Commit to main
echo Committing changes to the main branch...
git add .
git commit -m "Commit rendered site"
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

REM Clear gh-pages and copy new content
echo Clearing old content from gh-pages...
git rm -rf .
echo Copying new content from _site to gh-pages...
xcopy /E /I /Y "_site\*" "."
echo Committing new content to gh-pages...
git add .
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

:end
ENDLOCAL
pause
