import numpy as np
import matplotlib.pyplot as plt

### Class Definitions
def T_1_func(x,t):
  return (605. - 5.*x) + t*(8. - x)

def interf_func(t):
  return 0.75 - 0.001*t

def T_2_func(x,i,t):
  return (1/(1-i))*((-5. + 5.*i + i*t - 2.*t)*x + (605. - 605.*i + 8.*t - 7.*t*i))

### Data Generation
# Setup Storage Arrays
ts = np.arange(0,180.0001,10.)
xs = np.arange(0,1.0001,0.01)
interf_locs = np.zeros(len(ts))
interf_locs[0] = interf_func(0)
temp_data = np.zeros((len(ts),len(xs)))
temp_data[0,:] = 600

# Generate data
for t_idx in range(1,len(ts)):
  interf_locs[t_idx] = interf_func(ts[t_idx])
  for x_idx in range(0,np.shape(temp_data)[1]):
    if xs[x_idx] <= interf_locs[t_idx]:
      temp_data[t_idx,x_idx] = T_1_func(xs[x_idx],ts[t_idx])
    elif xs[x_idx] > interf_locs[t_idx]:
      temp_data[t_idx,x_idx] = T_2_func(xs[x_idx],interf_locs[t_idx],ts[t_idx])

### Plot Solutions
for t in range(1,len(ts)):
  plt.figure()
  temp_sol, = plt.plot(xs,temp_data[t,:],label='T Solution at t='+str(ts[t]))
  plt.xlabel('x')
  plt.ylabel('T [K]')
  plt.savefig('1D_discont_2_mat_mms_'+str(ts[t])+'_out.png')

### Export Data
np.savetxt('1D_discont_2_mat_mms_temp_out.csv',temp_data,fmt='%.6e',delimiter=',')
np.savetxt('1D_discont_2_mat_mms_interf_out.csv',interf_locs,fmt='%.6e',delimiter=',')
