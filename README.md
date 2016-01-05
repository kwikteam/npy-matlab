# npy-matlab

Experimental code to read/write NumPy .NPY files in MATLAB

[See the notebook for python tests](npy.ipynb)

See test_readNPY.m for matlab reading/writing tests. 

See exampleMemmap.m for example of how to memory map a npy file in matlab, which is not trivial when the file uses C-ordering (i.e. row-major order) rather than fortran-ordering (i.e. column-major ordering). Matlab's memory mapping only supports fortran, but Python's default is C so npy files created with Python defaults are not straightforward to read in Matlab. 
