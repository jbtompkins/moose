import numpy as np
from mpl_toolkits import mplot3d
import matplotlib.pyplot as plt

### Data Extraction
# Setup storage arrays
moos_04_data = np.zeros((4,25,3))
xfem_01_data = np.zeros((4,6,3))
xfem_04_data = np.zeros((4,35,3))
tstep_num = ['5','10','15','20']
len_list_x04 = []

# Extract Data
for i in range(0,4):
  # Extract MOOSE/Analytical solution data
  moos_04_temp = np.genfromtxt('../u_solutions/nx4ny4/2D_rz_ls1mat_nx4ny4-0.'
    +tstep_num[i]+'.csv',delimiter=',',skip_header=1)
  # Extract XFEM nx=1 solution data
  xfem_01_temp = np.genfromtxt(
    '../u_solutions/nx1ny1/2D_rz_ls1mat_lsf_xfem_nx1ny1-0.'+tstep_num[i]+
    '.csv',delimiter=',',skip_header=1)
  xfem_04_temp = np.genfromtxt(
    '../u_solutions/nx4ny4/2D_rz_ls1mat_lsf_xfem_nx4ny4-0.'+tstep_num[i]+
    '.csv',delimiter=',',skip_header=1)

  # Remove duplicate u solution entries
  xfem_01_temp = np.unique(xfem_01_temp, axis=0)
  xfem_04_temp = np.unique(xfem_04_temp, axis=0)

  # Sort extracted data by x value
  moos_04_temp = moos_04_temp[moos_04_temp[:,1].argsort()]
  xfem_01_temp = xfem_01_temp[xfem_01_temp[:,1].argsort()]
  xfem_04_temp = xfem_04_temp[xfem_04_temp[:,1].argsort()]

  # Add len of nx4ny4 run at timestep to len list
  len_list_x04.append(len(xfem_04_temp))

  # Store data for timestep
  moos_04_data[i,:,:] = moos_04_temp[:,:3]
  xfem_01_data[i,:,:] = xfem_01_temp[:,:3]
  for j in range(0,len(xfem_04_temp)):
    xfem_04_data[i,j,:] = xfem_04_temp[j,:3]

### Make plots for solution vs position
savedir = '../../doc/figures/'

# t = 0.5
fig = plt.figure()
ax = fig.gca(projection='3d')
#ax.plot_trisurf(moos_04_data[0,:,1],moos_04_data[0,:,2],moos_04_data[0,:,0], 
#  cmap='cool', edgecolor='none')
ax.plot_trisurf(xfem_04_data[0,:len_list_x04[0],1],
  xfem_04_data[0,:len_list_x04[0],2],xfem_04_data[0,:len_list_x04[0],0],
  cmap='cool', edgecolor='none')
ax.plot_trisurf(xfem_01_data[0,:,1],xfem_01_data[0,:,2],xfem_01_data[0,:,0],
  cmap='jet', edgecolor='none')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('u')
ax.set_zlim(398,510)
plt.savefig(savedir+'2D_rz_ls1mat_u_vs_x_05.png')

# t = 1.0
fig = plt.figure()
ax = fig.gca(projection='3d')
#ax.plot_trisurf(moos_04_data[1,:,1],moos_04_data[1,:,2],moos_04_data[1,:,0], 
#  cmap='cool', edgecolor='none')
ax.plot_trisurf(xfem_04_data[1,:len_list_x04[1],1],
  xfem_04_data[1,:len_list_x04[1],2],xfem_04_data[1,:len_list_x04[1],0],
  cmap='cool', edgecolor='none')
ax.plot_trisurf(xfem_01_data[1,:,1],xfem_01_data[1,:,2],xfem_01_data[1,:,0],
  cmap='jet', edgecolor='none')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('u')
ax.set_zlim3d(398,660)
plt.savefig(savedir+'2D_rz_ls1mat_u_vs_x_10.png')

# t = 1.5
fig = plt.figure()
ax = fig.gca(projection='3d')
#ax.plot_trisurf(moos_04_data[2,:,1],moos_04_data[2,:,2],moos_04_data[2,:,0], 
#  cmap='cool', edgecolor='none')
ax.plot_trisurf(xfem_04_data[2,:len_list_x04[2],1],
  xfem_04_data[2,:len_list_x04[2],2],xfem_04_data[2,:len_list_x04[2],0],
  cmap='cool', edgecolor='none')
ax.plot_trisurf(xfem_01_data[2,:,1],xfem_01_data[2,:,2],xfem_01_data[2,:,0],
  cmap='jet', edgecolor='none')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('u')
ax.set_xlim3d(1,2.1)
ax.set_ylim3d(1,2.1)
ax.set_zlim3d(398,800)
plt.savefig(savedir+'2D_rz_ls1mat_u_vs_x_15.png')

# t = 2.0
fig = plt.figure()
ax = fig.gca(projection='3d')
#ax.plot_trisurf(moos_04_data[3,:,1],moos_04_data[3,:,2],moos_04_data[3,:,0], 
#  cmap='cool', edgecolor='none')
ax.plot_trisurf(xfem_04_data[3,:len_list_x04[3],1],
  xfem_04_data[3,:len_list_x04[3],2],xfem_04_data[3,:len_list_x04[3],0],
  cmap='cool', edgecolor='none')
ax.plot_trisurf(xfem_01_data[3,:,1],xfem_01_data[3,:,2],xfem_01_data[3,:,0],
  cmap='jet', edgecolor='none')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('u')
ax.set_xlim3d(1,2.1)
ax.set_ylim3d(1,2.1)
ax.set_zlim3d(398,920)
plt.savefig(savedir+'2D_rz_ls1mat_u_vs_x_20.png')
