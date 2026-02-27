@echo off

:: Set Anaconda path
set CONDA_PATH=C:\ProgramData\anaconda3

:: Try activating the Conda environment
echo Activating the Conda environment 'EDU'...

:: Use the known Anaconda path
call "%CONDA_PATH%\condabin\conda.bat" activate EDU


:: Install the required packages
echo Installing PyTorch, Torchvision, CUDA 11.8, and Ultralytics...
conda install -c pytorch -c nvidia -c conda-forge pytorch torchvision pytorch-cuda=11.8 ultralytics -y && pip install opencv-contrib-python && pip install tqdm


echo Environment setup complete. You can now run your code in the 'EDU' environment.
pause

