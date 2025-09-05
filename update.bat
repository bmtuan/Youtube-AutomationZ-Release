@ECHO OFF
ECHO ===========================
ECHO EXECUTE UPDATE PROGRAM...
ECHO ===========================

REM Update the repository

git config credential.helper store
git gc
git stash save "Stash"
git checkout "main"
git pull --no-rebase https://gitlab.com/bmtuan/youtube-automation-z-application.git

REM Activate the virtual environment
SET VENV_PATH=%~dp0venv
IF EXIST "%VENV_PATH%" (
    ECHO Activating virtual environment...
    CALL "%VENV_PATH%\Scripts\activate.bat"
) ELSE (
    ECHO Virtual environment not found. Please ensure it exists at "%VENV_PATH%"
    EXIT /B 1
)

REM Install the requirements
pip install -U -r requirements.txt

ECHO ===========================
ECHO END UPDATE!
ECHO ===========================

timeout /t 3
