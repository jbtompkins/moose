# Need to exit MOOSE environment (module purge) in order to use numpy version 
# that is up to date

import numpy as np
from math import sqrt
import matplotlib.pyplot as plt

### Class Definitions

def u_func(x,y,t):
  return (-100.*x - 100.*y + 400.)*t + 400.

def phi_func(x,y,t):
  return -0.5*(x+y) + 2.04 - 0.2*t

### Data Extraction
# Setup storage arrays
xfem_data = np.zeros((21,37,4))
len_list_04 = []
ts = np.arange(0.0,2.01,0.1)

# Extract Data
for i in range(0,len(ts)):
  xfem_temp = np.genfromtxt(
    '../solutions/ls-xfem-2D_rz_ls1mat-0.'+str(i)+'.csv',
    delimiter=',',skip_header=1)

  # Remove duplicate u solution entries
  xfem_temp = np.unique(xfem_temp, axis=0)

  # Add len of nx4ny4 run at timestep to len list
  len_list_04.append(len(xfem_temp))

  # Store solution values and positions
  for j in range(0,len(xfem_temp)):
    xfem_data[i,j,0] = xfem_temp[j,0] # Store phi solutions
    xfem_data[i,j,1] = xfem_temp[j,1] # Store u solutions
    xfem_data[i,j,2] = xfem_temp[j,2] # Store x positions
    xfem_data[i,j,3] = xfem_temp[j,3] # Store y positions

### Generate Solution Values
# Setup storage arrays
solv_data = np.zeros(np.shape(xfem_data[:,:,:2]))

for i in range(0,np.shape(solv_data)[0]):
  for j in range(0,len_list_04[i]):
    solv_data[i,j,0] = phi_func(xfem_data[i,j,2],xfem_data[i,j,3],ts[i])
    solv_data[i,j,1] = u_func(xfem_data[i,j,2],xfem_data[i,j,3],ts[i])

### Calculate L2 Error Norms
# Setup storage arrays
phi_error = np.zeros(21)
u_error = np.zeros(21)

for i in range(0,np.shape(solv_data)[0]):
  solv_store = 0.
  for j in range(0,len_list_04[i]):
    phi_error[i] += (xfem_data[i,j,0] - solv_data[i,j,0])**2
    solv_store += solv_data[i,j,0]**2
  phi_error[i] = sqrt(phi_error[i])/sqrt(solv_store)

  solv_store = 0.
  for j in range(0,len_list_04[i]):
    u_error[i] += (xfem_data[i,j,1] - solv_data[i,j,1])**2
    solv_store += solv_data[i,j,1]**2
  u_error[i] = sqrt(u_error[i])/sqrt(solv_store)

### Plot L2 Error Norms vs time
savdir = '../../doc/figures/'

# Plot L2 Error Norm for nx=1
plt.figure()
phi_err, = plt.plot(ts,phi_error,label='Coupled XFEM/LSM phi Solution L2 Error Norm')
plt.legend(handles=[phi_err],loc='upper left')
plt.xlabel('Time')
plt.ylabel('phi L2 Error Norm')
plt.ticklabel_format(axis='y',style='sci',scilimits=(1,2))
plt.savefig(savdir+'ls-xfem-2D_rz_ls1mat_phi_L2_Errs.png')

# Plot L2 Error Norm for nx=4
plt.figure()
u_err, = plt.plot(ts,u_error,label='Coupled XFEM/LSM T Solution L2 Error Norm')
plt.legend(handles=[u_err],loc='best')
plt.xlabel('Time')
plt.ylabel('T L2 Error Norm')
plt.ticklabel_format(axis='y',style='sci',scilimits=(1,2))
plt.savefig(savdir+'ls-xfem-2D_rz_ls1mat_u_L2_Errs.png')
