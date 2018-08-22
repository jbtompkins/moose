# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# XFEM Moving Interface Verification Problem #1.0.1.0.00
# Dimensionality:                                         2D
# Coordinate System:                                      xy
# Material Numbers/Types: level set dep 1 material, 2 region
# Element Order:                                         1st
# Companion Problems:                            #1.0.1.0.01
# Interface Characteristics: u independent, prescribed level set function
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
  ymax = 1.0
  elem_type = QUAD4
[]

[XFEM]
  qrule = moment_fitting
  output_cut_plane = true
[]

[UserObjects]
  [./level_set_cut_uo]
    type = LevelSetCutUserObject
    level_set_var = ls
    heal_always = true
  [../]
[]

[Variables]
  [./u]
  [../]
[]

[AuxVariables]
  [./ls]
    order = FIRST
    family = LAGRANGE
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

[AuxKernels]
  [./ls_function]
    type = FunctionAux
    variable = ls
    function = ls_func
  [../]
[]

[Constraints]
  [./xfem_constraints]
    type = XFEMSingleVariableConstraint
    variable = u
    jump = 0
    jumpflux = 0
    geometric_cut_userobject = 'level_set_cut_uo'
  [../]
[]

[Functions]
  [./src_func]
    type = ParsedFunction
    value = '10*(-100*x-100*y+200)-(5*t/1.04)'
  [../]
  [./neumann_func]
    type = ParsedFunction
    value = '((0.01/1.04)*(-2.5*x-2.5*y-t)+1.55)*100*t'
  [../]
  [./dirichlet_right_func]
    type = ParsedFunction
    value = '(-100*y+100)*t+400'
  [../]
  [./dirichlet_top_func]
    type = ParsedFunction
    value = '(-100*x+100)*t+400'
  [../]
  [./k_func]
    type = ParsedFunction
    value = '(0.01/1.04)*(-2.5*x-2.5*y-t)+1.55'
  [../]
  [./ls_func]
    type = ParsedFunction
    value = '-0.5*(x+y) + 1.04 -0.2*t'
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
  max_xfem_update = 1
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
