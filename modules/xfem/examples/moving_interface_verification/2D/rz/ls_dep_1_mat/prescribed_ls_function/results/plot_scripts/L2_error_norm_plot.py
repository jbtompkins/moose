# Need to exit MOOSE environment (module purge) in order to use numpy version 
# that is up to date

import numpy as np
from math import sqrt
import matplotlib.pyplot as plt

### Class Definitions

def u_func(x,y,t):
  return (-100.*x - 100.*y + 200.)*t + 400.

### Data Extraction
# Setup storage arrays
xfem_01_data = np.zeros((18,6,3))
xfem_04_data = np.zeros((18,35,3))
len_list_04 = []
ts = np.arange(0.3,2.01,0.1)

# Extract Data
for i in range(0,len(ts)):
  xfem_01_temp = np.genfromtxt(
    '../u_solutions/nx1ny1/2D_rz_ls1mat_lsf_xfem_nx1ny1-0.'+str(i+3)+'.csv',
    delimiter=',',skip_header=1)
  xfem_04_temp = np.genfromtxt(
    '../u_solutions/nx4ny4/2D_rz_ls1mat_lsf_xfem_nx4ny4-0.'+str(i+3)+'.csv',
    delimiter=',',skip_header=1)

  # Remove duplicate u solution entries
  xfem_01_temp = np.unique(xfem_01_temp, axis=0)
  xfem_04_temp = np.unique(xfem_04_temp, axis=0)

  # Add len of nx4ny4 run at timestep to len list
  len_list_04.append(len(xfem_04_temp))

  # Store solution values and positions
  for j in range(0,len(xfem_01_temp)):
    xfem_01_data[i,j,0] = xfem_01_temp[j,0]
    xfem_01_data[i,j,1] = xfem_01_temp[j,1]
    xfem_01_data[i,j,2] = xfem_01_temp[j,2]
  for j in range(0,len(xfem_04_temp)):
    xfem_04_data[i,j,0] = xfem_04_temp[j,0]
    xfem_04_data[i,j,1] = xfem_04_temp[j,1]
    xfem_04_data[i,j,2] = xfem_04_temp[j,2]

### Generate Solution Values
# Setup storage arrays
solv_01_data = np.zeros(np.shape(xfem_01_data[:,:,0]))
solv_04_data = np.zeros(np.shape(xfem_04_data[:,:,0]))

for i in range(0,np.shape(solv_01_data)[0]):
  for j in range(0,np.shape(solv_01_data)[1]):
    solv_01_data[i,j] = u_func(xfem_01_data[i,j,1],xfem_01_data[i,j,2],ts[i])
  for j in range(0,len_list_04[i]):
    solv_04_data[i,j] = u_func(xfem_04_data[i,j,1],xfem_04_data[i,j,2],ts[i])

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
  for j in range(0,len_list_04[i]):
    xfem_04_error[i] += (xfem_04_data[i,j,0] - solv_04_data[i,j])**2
    solv_store += solv_04_data[i,j]**2
  xfem_04_error[i] = sqrt(xfem_04_error[i])/sqrt(solv_store)

### Plot L2 Error Norms vs time
savdir = '../../doc/figures/'

# Plot L2 Error Norm for nx=1
plt.figure()
x_01_err, = plt.plot(ts,xfem_01_error,label='XFEM T Solution L2 Error Norm (nx=1,ny=1)')
plt.legend(handles=[x_01_err],loc='best')
plt.xlabel('Time')
plt.ylabel('L2 Error Norm')
plt.ticklabel_format(axis='y',style='sci',scilimits=(1,2))
plt.savefig(savdir+'2D_rz_ls1mat_nx1ny1_L2_Errs.png')

# Plot L2 Error Norm for nx=4
plt.figure()
x_04_err, = plt.plot(ts,xfem_04_error,label='XFEM T Solution L2 Error Norm (nx=4,ny=4)')
plt.legend(handles=[x_04_err],loc='best')
plt.xlabel('Time')
plt.ylabel('L2 Error Norm')
plt.ticklabel_format(axis='y',style='sci',scilimits=(1,2))
plt.savefig(savdir+'2D_rz_ls1mat_nx4ny4_L2_Errs.png')

