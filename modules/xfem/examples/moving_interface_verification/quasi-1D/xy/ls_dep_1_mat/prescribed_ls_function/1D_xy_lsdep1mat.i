# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# XFEM Moving Interface Verification Problem #0.0.1.0.01
# Dimensionality:                                         1D
# Coordinate System:                                      xy
# Material Numbers/Types: level set dep 1 material, 2 region
# Element Order:                                         1st
# Companion Problems:                            #0.0.1.0.00
# A simple, single element transient heat transfer problem with a linear 
#   solution. The heat transfer coefficient 'k' is dependent on the level set
#   function used in the XFEM companion problem to define the interface
#   position. The problem is designed using MMS to be able to be exactly
#   evaluated on linear elements. 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

[GlobalParams]
  order = FIRST
  family = LAGRANGE
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 1
  ny = 1
  xmin = 0.0
  xmax = 1.0
  ymin = 0.0
  ymax = 0.5
  elem_type = QUAD4
[]

[Variables]
  [./u]
  [../]
[]

[Kernels]
  [./heat_cond]
    type = HeatConduction
    variable = u
  [../]
  [./vol_heat_src]
    type = BodyForce
    variable = u
    function = src_func
  [../]
  [./mat_time_deriv]
    type = MatTimeDerivative
    variable = u
    mat_prop_value = rhoCp
  [../]
[]

[Functions]
  [./src_func]
    type = ParsedFunction
    value = 'rhoCp*(-200*x+200)-(0.05*200*t/1.04)'
    vars = 'rhoCp'
    vals = 10
  [../]
  [./neumann_func]
    type = ParsedFunction
    value = '((0.05/1.04)*(1-(x-0.04)-0.2*t) + 1.5)*200*t'
  [../]
  [./k_func]
    type = ParsedFunction
    value = '(0.05/1.04)*(1-(x-0.04)-0.2*t) + 1.5'
  [../]
[]

[Materials]
  [./mat_time_deriv_prop]
    type = GenericConstantMaterial
    prop_names = 'rhoCp'
    prop_values = 10
  [../]
  [./therm_cond_prop]
    type = GenericFunctionMaterial
    prop_names = 'diffusion_coefficient'
    prop_values = 'k_func'
  [../]
[]

[BCs]
  [./left_u]
    type = FunctionNeumannBC
    variable = u
    boundary = 'left'
    function = neumann_func
  [../]
  [./right_u]
    type = DirichletBC
    variable = u
    boundary = 'right'
    value = 400
  [../]
[]

[ICs]
  [./u_ic]
    type = ConstantIC
    value = 400
    variable = u
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  # petsc_options_iname = '-pc_type -pc_hypre_type'
  # petsc_options_value = 'hypre boomeramg'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  line_search = 'none'

  l_tol = 1.0e-6
  nl_max_its = 15
  nl_rel_tol = 1.0e-10
  nl_abs_tol = 1.0e-9

  start_time = 0.0
  dt = 0.1
  end_time = 2.0
  # max_xfem_update = 1
[]

[Outputs]
  interval = 1
  execute_on = timestep_end
  exodus = true
  [./console]
    type = Console
    output_linear = true
  [../]
[]
