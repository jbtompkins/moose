import numpy as np
from math import sqrt
import matplotlib.pyplot as plt

### Class Definitions

def u_func(x,t):
  return (-200.*x + 200.)*t + 400.

### Data Extraction
# Setup storage arrays
xfem_01_data = np.zeros((18,4,2))
xfem_04_data = np.zeros((18,10,2))
ts = np.arange(0.3,2.01,0.1)

# Extract Data
for i in range(0,len(ts)):
  xfem_01_temp = np.genfromtxt(
    '../u_solutions/nx1/1D_xy_ls1mat_lsf_xfem_nx01-0.'+str(i+3)+'.csv',
    delimiter=',',skip_header=1)
  xfem_04_temp = np.genfromtxt(
    '../u_solutions/nx4/1D_xy_ls1mat_lsf_xfem_nx04-0.'+str(i+3)+'.csv',
    delimiter=',',skip_header=1)

  # Sort extracted data by x value
  xfem_01_temp = xfem_01_temp[xfem_01_temp[:,1].argsort()]
  xfem_04_temp = xfem_04_temp[xfem_04_temp[:,1].argsort()]

  # Remove additional points at x=0.5
  xfem_01_temp = xfem_01_temp[xfem_01_temp[:,2]!=0.5,:]
  xfem_04_temp = xfem_04_temp[xfem_04_temp[:,2]!=0.5,:]

  # Store solution values and positions
  for j in range(0,len(xfem_01_temp)):
    xfem_01_data[i,j,0] = xfem_01_temp[j,0]
    xfem_01_data[i,j,1] = xfem_01_temp[j,1]
  for j in range(0,len(xfem_04_temp)):
    xfem_04_data[i,j,0] = xfem_04_temp[j,0]
    xfem_04_data[i,j,1] = xfem_04_temp[j,1]

### Generate Solution Values
# Setup storage arrays
solv_01_data = np.zeros(np.shape(xfem_01_data[:,:,1]))
solv_04_data = np.zeros(np.shape(xfem_04_data[:,:,1]))

for i in range(0,np.shape(solv_01_data)[0]):
  for j in range(0,np.shape(solv_01_data)[1]):
    solv_01_data[i,j] = u_func(xfem_01_data[i,j,1],ts[i])
  for j in range(0,np.shape(solv_04_data)[1]):
    solv_04_data[i,j] = u_func(xfem_04_data[i,j,1],ts[i])

### Calculate L2 Error Norms
# Setup storage arrays
xfem_01_error = np.zeros(18)
xfem_04_error = np.zeros(18)

for i in range(0,np.shape(solv_01_data)[0]):
  solv_store = 0.
  for j in range(0,np.shape(solv_01_data)[1]):
    xfem_01_error[i] += (xfem_01_data[i,j,0] - solv_01_data[i,j])**2
    solv_store += solv_01_data[i,j]**2
  xfem_01_error[i] = sqrt(xfem_01_error[i])/sqrt(solv_store)

  solv_store = 0.
  for j in range(0,np.shape(solv_04_data)[1]):
    xfem_04_error[i] += (xfem_04_data[i,j,0] - solv_04_data[i,j])**2
    solv_store += solv_04_data[i,j]**2
  xfem_04_error[i] = sqrt(xfem_04_error[i])/sqrt(solv_store)

### Plot L2 Error Norms vs time
savdir = '../../doc/figures/'

# Plot L2 Error Norm for nx=1
plt.figure()
x_01_err, = plt.plot(ts,xfem_01_error,label='XFEM T Solution L2 Error Norm (nx=1)')
plt.legend(handles=[x_01_err],loc='best')
plt.xlabel('Time')
plt.ylabel('L2 Error Norm')
plt.ticklabel_format(axis='y',style='sci',scilimits=(1,2))
plt.savefig(savdir+'1D_xy_ls1mat_nx1_L2_Errs.png')

# Plot L2 Error Norm for nx=4
plt.figure()
x_04_err, = plt.plot(ts,xfem_04_error,label='XFEM T Solution L2 Error Norm (nx=4)')
plt.legend(handles=[x_04_err],loc='lower right')
plt.xlabel('Time')
plt.ylabel('L2 Error Norm')
plt.ticklabel_format(axis='y',style='sci',scilimits=(1,2))
plt.savefig(savdir+'1D_xy_ls1mat_nx4_L2_Errs.png')
