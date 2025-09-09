@ECHO OFF
ECHO ===========================
ECHO EXECUTE FORCE PULL UPDATE
ECHO ===========================

REM Navigate to script directory
CD /D "%~dp0"

REM Set up Git to store credentials
git config credential.helper store

REM Clean up and stash any changes
git gc
git reset --hard
git clean -fd
git stash save "Backup before force pull"

REM Force switch to main branch and reset to origin
git checkout main
git fetch origin
git reset --hard origin/main

REM Pull latest changes
git pull --no-rebase

REM Activate the virtual environment
SET VENV_PATH=%~dp0venv
IF EXIST "%VENV_PATH%" (
    ECHO Activating virtual environment...
    CALL "%VENV_PATH%\Scripts\activate.bat"
) ELSE (
    ECHO Virtual environment not found. Please ensure it exists at "%VENV_PATH%"
    EXIT /B 1
)

REM Install requirements
pip install -U -r requirements.txt

ECHO ===========================
ECHO UPDATE COMPLETED!
ECHO ===========================

timeout /t 3
