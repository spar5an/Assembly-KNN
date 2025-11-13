PIC18 Assembly KNN Code for 3rd year microprocessor lab.
Main is feature complete, but there will be a speed optimised branch that will not output via uart as this is where most of the runtime is taken up.
Written by John Colling

Run master.ipynb and wait for ready before running microprocessor code.
If you are changing K you will need to manually make changes to the main, data_loader and master files.

Can only take multiples of 64 training data-points. To change the amount of training data stored you will need to change banks_filled in data_loader and in master.

Data provided is simulated super symmetry data from https://www.kaggle.com/datasets/janus137/supersymmetry-dataset.
If you want to investigate the best models using supersymmetrydata.ipynb for this then you need to download the full data set and put it into python code folder.
Although 5000 points are provided in the data.pickle file.

