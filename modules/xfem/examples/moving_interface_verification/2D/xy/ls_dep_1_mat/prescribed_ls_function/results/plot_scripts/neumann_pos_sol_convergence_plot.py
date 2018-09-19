import numpy as np
import matplotlib.pyplot as plt

### Data Extraction
conv_data = np.genfromtxt('../Neumann_pos_sols/2D_xy_ls1m_neumann_pos_sols.csv',delimiter=',')
conv_data[:,2] = abs(conv_data[:,2]-800.)
conv_data[:,0] *= conv_data[:,1]

### Plot data
savdir = '../../doc/figures/'
plt.figure()
conv_plt, = plt.loglog(conv_data[:,0],conv_data[:,2],label='convergence plot')
plt.xlabel('Number of elements')
plt.ylabel('Difference between XFEM and real sol. at x=0,y=0')
plt.savefig(savdir+'2D_xy_ls1mat_neumann_comp.png')
