# gabor-neurons
Simulating a simple cell with a vertical receptive field and half-wave squaring nonlinear ouput.

m2d.m houses the simple cell, generates its receptive field (RF), and inputs Gaussian white noise
images to the cell and see its output. The function used for the simple cell was Gabor.

m2dii.m is for a complex cell, combining two simple cells.


The figures below compare the actual RF of the simple cell with the spike train average-derived
RF (based on Gaussian white noise images).

The first figure is the cell's RF seen directly (clearly Gabor). The second is the cell's RF reverse-computed using output to Gaussian white noise (we can see the Gaborness).

![alt text](https://github.com/aryamanmajumdar/gabor-neurons/blob/master/Gabor-model-2d.png)


![alt text2](https://github.com/aryamanmajumdar/gabor-neurons/blob/master/STA-derived-Gabor.png)



