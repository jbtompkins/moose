# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# XFEM Moving Interface Verification Problem #0.0.2.0.00
# Dimensionality:                                         1D
# Coordinate System:                                      xy
# Material Numbers/Types:discrete homog 2 material, 2 region
# Element Order:                                         1st
# Companion Problems:                            #0.0.0.2.01
# Interface Characteristics: u independent, prescribed level set function
# Description
#   Description continued
# IMPORTANT NOTE:
#   When running this input file, add the --allow-test-objects tag!!!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

[GlobalParams]
  order = FIRST
  family = LAGRANGE
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 1
  xmin = 0.0
  xmax = 1.0
  ymin = 0.0
  ymax = 0.5
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
[]

[AuxVariables]
  [./phi]
    order = FIRST
    family = LAGRANGE
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
    type = TestMatTimeDerivative
    variable = u
    mat_prop_value = rhoCp
  [../]
[]

[AuxKernels]
  [./ls_function]
    type = FunctionAux
    variable = phi
    function = ls_func
  [../]
[]

[Constraints]
  [./xfem_constraint]
    type = XFEMSingleVariableConstraint
    variable = u
    geometric_cut_userobject = 'level_set_cut_uo'
    use_penalty = true
    alpha = 1e5
  [../]
[]

[Functions]
  [./src_func]
    type = ParsedFunction
    value = 'phi:=(0.75-x-0.001); if (phi>=0, 10*(8-x),
      7*((1/(0.25 + x + 0.001*t))*(8 - 2*x + (x-7)*(0.75 - x - 0.001*t))) )'
  [../]
  [./right_du_func]
    type = ParsedFunction
    value = '(2.0/(0.25 + x + 0.001*t))*(-5 - 2*t +(5+t)*(0.75 - x - 0.001*t))'
  [../]
  [./left_exact_u_func]
    type = ParsedFunction
    # TODO change to if function based on which side of interface things are on
    # can then use Moose to calculate L2 error norm
    value = '605 - 5*x + t*(8-x)'
  [../]

  [./ls_func]
    type = ParsedFunction
    value = '0.75 - x - 0.001*t'
  [../]
[]

[Materials]
  [./mat_time_deriv_prop]
    type = GenericConstantMaterial
    prop_names = 'A_rhoCp B_rhoCp'
    prop_values = '10 7'
  [../]
  [./therm_cond_prop]
    type = GenericConstantMaterial
    prop_names = 'A_diffusion_coefficient B_diffusion_coefficient'
    prop_values = '20.0 2.0'
  [../]

  [./combined_rhoCp]
    type = LevelSetBiMaterialReal
    levelset_positive_base = 'A'
    levelset_negative_base = 'B'
    level_set_var = phi
    prop_name = rhoCp
  [../]
  [./combined_diffusion_coefficient]
    type = LevelSetBiMaterialReal
    levelset_positive_base = 'A'
    levelset_negative_base = 'B'
    level_set_var = phi
    prop_name = diffusion_coefficient
  [../]
[]

[BCs]
  [./left_u]
    type = FunctionDirichletBC
    variable = u
    boundary = 'left'
    function = left_exact_u_func
  [../]
  [./right_du]
    type = FunctionNeumannBC
    variable = u
    boundary = 'right'
    function = right_du_func
  [../]
[]

[ICs]
  [./u_ic]
    type = ConstantIC
    value = 600
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
  dt = 10
  end_time = 180.0
  max_xfem_update = 2
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
