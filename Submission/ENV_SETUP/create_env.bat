@echo off

:: Set Anaconda path
set CONDA_PATH=C:\ProgramData\anaconda3

:: Check if conda exists at the specified path
IF NOT EXIST "%CONDA_PATH%\Scripts\conda.exe" (
    echo "Conda is not found at %CONDA_PATH%. Please update the path."
    exit /b 1
)

:: Initialize conda for this session
call "%CONDA_PATH%\condabin\conda.bat" activate base

:: Create the environment
echo Creating the Conda environment 'EDU' with Python 3.10...
call conda create --name EDU python=3.10 -y



