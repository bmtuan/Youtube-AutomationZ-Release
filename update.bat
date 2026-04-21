@ECHO OFF
SETLOCAL EnableDelayedExpansion

ECHO ===========================
ECHO EXECUTE UPDATE PROGRAM...
ECHO ===========================

PUSHD "%~dp0"

REM Remove stale git lock if exists
IF EXIST ".git\index.lock" (
    ECHO Found stale Git lock. Removing...
    DEL /F /Q ".git\index.lock"
)

REM Configure remote
git remote set-url origin https://gitlab.com/bmtuan/youtube-automation-z-application.git
git config credential.helper store

REM Stash local changes (including untracked files)
git stash push --include-untracked -m "Auto-stash before update" 2>NUL

REM Switch to main and pull
git checkout "main"
IF ERRORLEVEL 1 (
    ECHO [ERROR] Failed to checkout main branch.
    GOTO :FAIL
)

git pull --no-rebase
IF ERRORLEVEL 1 (
    ECHO [ERROR] Failed to pull from remote. Attempting to reset...
    git merge --abort 2>NUL
    git reset --hard origin/main
    IF ERRORLEVEL 1 (
        ECHO [ERROR] Reset failed. Please resolve manually.
        GOTO :FAIL
    )
    ECHO Reset to origin/main successful.
)

REM Activate the virtual environment
SET "VENV_PATH=%~dp0venv"
IF EXIST "%VENV_PATH%\Scripts\activate.bat" (
    ECHO Activating virtual environment...
    CALL "%VENV_PATH%\Scripts\activate.bat"
) ELSE (
    ECHO [ERROR] Virtual environment not found at "%VENV_PATH%"
    GOTO :FAIL
)

REM Install the requirements
pip install -U -r requirements.txt
IF ERRORLEVEL 1 (
    ECHO [WARNING] Some packages may have failed to install.
)

ECHO ===========================
ECHO UPDATE COMPLETED!
ECHO ===========================
GOTO :END

:FAIL
ECHO ===========================
ECHO UPDATE FAILED!
ECHO ===========================

:END
POPD
ENDLOCAL
timeout /t 5 /nobreak >NUL
