# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# Coupled XFEM/Level Set Modules Problem #0.1
# Dimensionality:                                                2D
# Coordinate System:                                             rz
# Material Numbers/Types:  level set dependent 1 material, 2 region
# Element Order:                                                1st
# Level Set Interaction:     u material properties dependent on phi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

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
  nx = 4
  ny = 4
  xmin = 1.0
  xmax = 2.0
  ymin = 1.0
  ymax = 2.0
  elem_type = QUAD4
[]

[XFEM]
  qrule = moment_fitting
  output_cut_plane = true
[]

[UserObjects]
  [./level_set_cut_uo]
    type = LevelSetCutUserObject
    level_set_var = phi
    heal_always = true
  [../]
[]

[Variables]
  [./u]
  [../]
  [./phi]
  [../]
[]

[AuxVariables]
  [./vel_x]
    initial_condition = -0.2
  [../]
  [./vel_y]
    initial_condition = -0.2
  [../]
[]

[Kernels]
  [./heat_cond]
    type = MatDiffusion
    variable = u
    D_name = 'diffusion_coefficient'
  [../]
  [./vol_heat_src]
    type = BodyForce
    variable = u
    function = src_func
  [../]
  [./mat_time_deriv]
    type = HeatConductionTimeDerivative
    variable = u
  [../]

  [./phi_advection]
    type = LevelSetAdvection
    variable = phi
    velocity_x = vel_x
    velocity_y = vel_y
  [../]
  [./phi_time]
    type = TimeDerivative
    variable = phi
  [../]
[]

[Constraints]
  [./xfem_u_constraint]
    type = XFEMSingleVariableConstraint
    variable = u
    geometric_cut_userobject = 'level_set_cut_uo'
    use_penalty = true
    alpha = 1e5
  [../]
  [./xfem_phi_constraint]
    type = XFEMSingleVariableConstraint
    variable = phi
    geometric_cut_userobject = 'level_set_cut_uo'
    use_penalty = true
    alpha = 1e5
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
  [./phi_exact_func]
    type = ParsedFunction
    value = '-0.5*(x+y) + 2.04 -0.2*t'
  [../]
[]

[Materials]
  [./mat_time_deriv_prop]
    type = GenericConstantMaterial
    prop_names = 'specific_heat density'
    prop_values = '1 10'
  [../]
  [./therm_cond_prop]
    type = ParsedMaterial
    f_name = diffusion_coefficient
    args = 'phi'
    function = '(0.05/2.04)*phi + 1.5'
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

  [./phi_ic]
    type = FunctionIC
    function = phi_exact_func
    variable = phi
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
  execute_on = 'initial timestep_end'
  exodus = true
  [./console]
    type = Console
    output_linear = true
  [../]
[]
