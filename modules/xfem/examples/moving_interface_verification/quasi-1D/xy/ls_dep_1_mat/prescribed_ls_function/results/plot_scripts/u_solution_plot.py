import numpy as np
import matplotlib.pyplot as plt

### Data Extraction
# Setup storage arrays
moos_04_data = np.zeros((4,5))
xfem_01_data = np.zeros((4,4))
xfem_04_data = np.zeros((4,7))
tstep_num = ['5','10','15','20']
xfem_interf_locs = [0.94,0.84,0.74,0.64]

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

  # Remove additional points at y=0.5
  moos_04_temp = moos_04_temp[moos_04_temp[:,4]!=0.5,:]
  xfem_01_temp = xfem_01_temp[xfem_01_temp[:,3]!=0.5,:]
  xfem_04_temp = xfem_04_temp[xfem_04_temp[:,3]!=0.5,:]

  # Remove duplicate point entries except at interface location
  stor_idx = 0
  stor_pos = None
  for j in range(0,len(moos_04_temp)):
    if stor_pos != moos_04_temp[j,3]:
      moos_04_data[i,stor_idx] = moos_04_temp[j,0]
      stor_idx += 1
    elif stor_pos == moos_04_temp[j,3] and \
         moos_04_temp[j,3] == xfem_interf_locs[i]:
      moos_04_data[i,stor_idx] = moos_04_temp[j,0]
      stor_idx += 1
    stor_pos = moos_04_temp[j,3]
  stor_idx = 0
  stor_pos = None
  for j in range(0,len(xfem_01_temp)):
    if stor_pos != xfem_01_temp[j,2]:
      xfem_01_data[i,stor_idx] = xfem_01_temp[j,1]
      stor_idx += 1
    elif stor_pos == xfem_01_temp[j,2] and \
         xfem_01_temp[j,2] == xfem_interf_locs[i]:
      xfem_01_data[i,stor_idx] = xfem_01_temp[j,1]
      stor_idx += 1
    stor_pos = xfem_01_temp[j,2]
  stor_idx = 0
  stor_pos = None
  for j in range(0,len(xfem_04_temp)):
    if stor_pos != xfem_04_temp[j,2]:
      xfem_04_data[i,stor_idx] = xfem_04_temp[j,1]
      stor_idx += 1
    elif stor_pos == xfem_04_temp[j,2] and \
         xfem_04_temp[j,2] == xfem_interf_locs[i]:
      xfem_04_data[i,stor_idx] = xfem_04_temp[j,1]
      stor_idx += 1
    stor_pos = xfem_04_temp[j,2]

# Position Arrays
moos_pos = [0.0,0.25,0.5,0.75,1.0]
xfem_01_pos = np.array([[0.0,0.94,0.94,1.0],
                        [0.0,0.84,0.84,1.0],
                        [0.0,0.74,0.74,1.0],
                        [0.0,0.64,0.64,1.0]])
xfem_04_pos = np.array([[0.0,0.25,0.5,0.75,0.94,0.94,1.0],
                        [0.0,0.25,0.5,0.75,0.84,0.84,1.0],
                        [0.0,0.25,0.5,0.74,0.74,0.75,1.0],
                        [0.0,0.25,0.5,0.64,0.64,0.75,1.0]])

### Make plots for solution vs position
savdir = '../../doc/figures/'

# t = 0.5
plt.figure()
xfem_01_5, = plt.plot(xfem_01_pos[0,:],xfem_01_data[0,:],'-bo',label=
        'XFEM w/ nx=1 at t=0.5')
xfem_04_5, = plt.plot(xfem_04_pos[0,:],xfem_04_data[0,:],'-go',label=
        'XFEM w/ nx=4 at t=0.5')
moos_04_5, = plt.plot(moos_pos,moos_04_data[0,:],'--ro',label=
        'Manufactured/MOOSE T at t=0.5')
plt.legend(handles=[moos_04_5,xfem_01_5,xfem_04_5],loc='best')
plt.xlabel('Position')
plt.ylabel('Temperature')
plt.axis([0.,1.,390.,520.])
plt.savefig(savdir+'1D_xy_homog1mat_u_vs_x_05.png')

# t = 1.0
plt.figure()
xfem_01_10, = plt.plot(xfem_01_pos[1,:],xfem_01_data[1,:],'-bo',label=
        'XFEM w/ nx=1 at t=1.0')
xfem_04_10, = plt.plot(xfem_04_pos[1,:],xfem_04_data[1,:],'-go',label=
        'XFEM w/ nx=4 at t=1.0')
moos_04_10, = plt.plot(moos_pos,moos_04_data[1,:],'--ro',label=
        'Manufactured/MOOSE T at t=1.0')
plt.legend(handles=[moos_04_10,xfem_01_10,xfem_04_10],loc='best')
plt.xlabel('Position')
plt.ylabel('Temperature')
plt.axis([0.,1.,390.,630.])
plt.savefig(savdir+'1D_xy_homog1mat_u_vs_x_10.png')

# t = 1.5
plt.figure()
xfem_01_15, = plt.plot(xfem_01_pos[2,:],xfem_01_data[2,:],'-bo',label=
        'XFEM w/ nx=1 at t=1.5')
xfem_04_15, = plt.plot(xfem_04_pos[2,:],xfem_04_data[2,:],'-go',label=
        'XFEM w/ nx=4 at t=1.5')
moos_04_15, = plt.plot(moos_pos,moos_04_data[2,:],'--ro',label=
        'Manufactured/MOOSE T at t=1.5')
plt.legend(handles=[moos_04_15,xfem_01_15,xfem_04_15],loc='best')
plt.xlabel('Position')
plt.ylabel('Temperature')
plt.axis([0.,1.,390.,770.])
plt.savefig(savdir+'1D_xy_homog1mat_u_vs_x_15.png')

# t = 2.0
plt.figure()
xfem_01_20, = plt.plot(xfem_01_pos[3,:],xfem_01_data[3,:],'-bo',label=
        'XFEM w/ nx=1 at t=2.0')
xfem_04_20, = plt.plot(xfem_04_pos[3,:],xfem_04_data[3,:],'-go',label=
        'XFEM w/ nx=4 at t=2.0')
moos_04_20, = plt.plot(moos_pos,moos_04_data[3,:],'--ro',label=
        'Manufactured/MOOSE T at t=2.0')
plt.legend(handles=[moos_04_20,xfem_01_20,xfem_04_20],loc='best')
plt.xlabel('Position')
plt.ylabel('Temperature')
plt.axis([0.,1.,390.,920.])
plt.savefig(savdir+'1D_xy_homog1mat_u_vs_x_20.png')
