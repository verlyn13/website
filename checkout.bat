@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

echo Starting checkout process...
echo.

REM Commit and push to main
echo Committing all changes to the main branch...
git checkout main
git add .
git commit -m "Local changes"
git push origin main
IF !ERRORLEVEL! NEQ 0 (
    echo Failed to push changes to main. Exiting...
    goto :error
)

REM Render the Quarto project
echo Rendering Quarto project...
quarto render
IF !ERRORLEVEL! NEQ 0 (
    echo Failed to render Quarto project. Exiting...
    goto :error
)

REM Updating gh-pages branch
echo Switching to gh-pages branch...
git checkout gh-pages
IF !ERRORLEVEL! NEQ 0 (
    echo Failed to switch to gh-pages branch. Exiting...
    goto :error
)

echo Clearing old content from gh-pages...
git rm -rf .
IF !ERRORLEVEL! NEQ 0 (
    echo Failed to clear old content. Exiting...
    goto :error
)

echo Copying new content from _site to gh-pages...
xcopy /E /I /Y "..\_site\*" "."
IF !ERRORLEVEL! NEQ 0 (
    echo Failed to copy new content. Exiting...
    goto :error
)

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
