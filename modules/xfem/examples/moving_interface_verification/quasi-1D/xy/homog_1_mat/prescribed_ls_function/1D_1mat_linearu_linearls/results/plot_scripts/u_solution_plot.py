import numpy as np
import matplotlib.pyplot as plt

### Data Extraction
# Setup storage arrays
moos_04_data = np.zeros((4,5))
xfem_01_data = np.zeros((4,4))
xfem_04_data = np.zeros((4,7))
ts = np.array([0.5,1.0,1.5,2.0])
tstep_num = ['5','10','15','20']
xfem_interf_locs = [[0.0,0.94],[0.0,0.84],[0.0,0.74],[0.0,0.64]]

# Extract Data
for i in range(0,4):
  # Extract MOOSE/Analytical solution data
  moos_04_temp = np.genfromtxt('../u_solutions/nx04/1D_xy_homog1mat_nx04-0.'
   +tstep_num[i]+'.csv',delimiter=',',skip_header=1)
  # Extract XFEM nx=1 solution data
  xfem_01_temp = np.genfromtxt(
    '../u_solutions/nx01/1D_xy_homog1mat_lsf_xfem_nx01-0.'+tstep_num[i]+'.csv',
    delimiter=',',skip_header=1)
  # Extract XFEM nx=4 solution data
  xfem_04_temp = np.genfromtxt(
    '../u_solutions/nx04/1D_xy_homog1mat_lsf_xfem_nx04-0.'+tstep_num[i]+'.csv',
    delimiter=',',skip_header=1)

  # Sort extracted data by x value
  moos_04_temp = moos_04_temp[moos_04_temp[:,3].argsort()]
  xfem_01_temp = xfem_01_temp[xfem_01_temp[:,2].argsort()]
  xfem_04_temp = xfem_04_temp[xfem_04_temp[:,2].argsort()]  

  # Cut down imported data just to what we need
  moos_04_temp[moos_04_temp[:,4]
  stor_idx = 0
  for j in range(0,len(moos_04_temp)):
    if moos_04_temp[j,-2] == 0.0:
      moos_04_data[i,stor_idx] = moos_04_temp[j,0]
      stor_idx += 1
  stor_idx = 0
  stor_pos = []
  captured_points
  for j in range(0,len(xfem_01_temp)):
    if xfem_01_temp[j,-2] == 0.0 && not stor_pos:
      xfem_01_data[i,stor_idx] = xfem_01_temp[j,1]
      stor_idx += 1
      stor_pos.append([xfem_01_temp[j,2]
    elif   
  stor_idx = 0
  stor_pos = []
  for j in range(0,len(xfem_04_temp)):
    if xfem_04_temp[j,-2] == 0.0:
      xfem_04_data[i,stor_idx] = xfem_04_temp[j,1]
      stor_idx += 1

print(moos_04_data)
print('\n')
print(xfem_01_data)
print('\n')
print(xfem_04_data)

### 
