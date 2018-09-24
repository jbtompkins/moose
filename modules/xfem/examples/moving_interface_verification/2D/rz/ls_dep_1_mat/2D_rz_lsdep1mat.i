# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# XFEM Moving Interface Verification Problem #1.1.1.0.01
# Dimensionality:                                         2D
# Coordinate System:                                      rz
# Material Numbers/Types: level set dep 1 material, 1 region
# Element Order:                                         1st
# Companion Problems:                            #1.1.1.0.00
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

[GlobalParams]
  order = FIRST
  family = LAGRANGE
[]

[Problem]
  coord_type = RZ
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 1
  ny = 1
  xmin = 1.0
  xmax = 2.0
  ymin = 1.0
  ymax = 2.0
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
    value = '10*(-100*x-100*y+400) + t*(-2.5*y/(2.04*x) + 155/x - t/(2.04*x) 
            - 7.5/2.04)'
  [../]
  [./neumann_func]
    type = ParsedFunction
    value = '((0.01/2.04)*(-2.5*x-2.5*y-t)+1.55)*100*t'
  [../]
  [./dirichlet_right_func]
    type = ParsedFunction
    value = '(-100*y+200)*t+400'
  [../]
  [./dirichlet_top_func]
    type = ParsedFunction
    value = '(-100*x+200)*t+400'
  [../]
  [./k_func]
    type = ParsedFunction
    value = '(0.01/2.04)*(-2.5*x-2.5*y-t)+1.55'
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
  [./left_du]
    type = FunctionNeumannBC
    variable = u
    boundary = 'left'
    function = neumann_func
  [../]
  [./right_u]
    type = FunctionDirichletBC
    variable = u
    boundary = 'right'
    function = dirichlet_right_func
  [../]
  [./bottom_du]
    type = FunctionNeumannBC
    variable = u
    boundary = 'bottom'
    function = neumann_func
  [../]
  [./top_u]
    type = FunctionDirichletBC
    variable = u
    boundary = 'top'
    function = dirichlet_top_func
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
  execute_on = 'initial timestep_end'
  exodus = true
  [./console]
    type = Console
    output_linear = true
  [../]
[]
