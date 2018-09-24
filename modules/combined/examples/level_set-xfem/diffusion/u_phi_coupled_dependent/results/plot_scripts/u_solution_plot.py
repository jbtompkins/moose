import numpy as np
import matplotlib.pyplot as plt
import matplotlib.tri as tri

### Data Extraction
# Setup storage arrays
xfem_data = np.zeros((4,41,3))
tstep_num = ['10','10','15','20']
len_list_x04 = []

# Extract Data
for i in range(0,4):
  # Extract XFEM solution data
  xfem_temp = np.genfromtxt(
    '../solutions/ls-xfem-2D_rz_ls1mat_uvel-0.'+tstep_num[i]+
    '.csv',delimiter=',',skip_header=1)

  # Remove duplicate u solution entries
  xfem_temp = np.unique(xfem_temp, axis=0)

  # Add len of nx4ny4 run at timestep to len list
  len_list_x04.append(len(xfem_temp))

  # Store data for timestep
  for j in range(0,len(xfem_temp)):
    xfem_data[i,j,:] = xfem_temp[j,1:4]

### Make plots for solution vs position
savedir = '../../doc/figures/'

print(xfem_data[0,:len_list_x04[0],0])

# t = 0.5
fig, ax = plt.subplots()
#ax.tricontour(xfem_data[0,:len_list_x04[0],1], xfem_data[0,:len_list_x04[0],2],
#  xfem_data[0,:len_list_x04[0],0], 14, linewidths=0.5, colors='k')
cntr = ax.tricontourf(xfem_data[0,:len_list_x04[0],1],
  xfem_data[0,:len_list_x04[0],2],xfem_data[0,:len_list_x04[0],0], 14,
  cmap = 'viridis')
fig.colorbar(cntr,ax=ax,label='u')
ax.set_xlabel('x')
ax.set_ylabel('y')
plt.show()

exit()


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
