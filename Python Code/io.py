import serial
import numpy as np
import pickle

def scale_and_cast(data):
    for i in range(0,data.shape[1]):
        sf = 255/(max(data[:,i]) - min(data[:,i]))
        data[:,i] = (data[:,i] - min(data[:,i])) * sf

    return np.rint(data)

port = serial.Serial("/dev/ttyUSB0", 9600)#ive written this for linux but it might not work so switch for com when on windows

with open('test_data.pickle', 'rb') as handle:
    data = pickle.load(handle)


X = data["values"]
y = data["labels"]

for val, lab in zip(X,y):
    #wait for signal
    signal = None
    while signal == None:
        signal = port.readline()
    
    #send data
    port.write(bytearray(val))

