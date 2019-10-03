# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# While developing level set driven bimaterial interface capability, it was
# noticed that when initiating a simulation with the material interface within
# an element that has an edge split among parallel processors that material
# properties in a bimaterial simulation may not be assigned as the processor
# does not have material properties on the other side of the interface to assign.
# This test is developed to replicate this bug, and to ensure it does not
# persist once fixed.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

[GlobalParams]
  order = FIRST
  family = LAGRANGE
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 8
  ny = 4
  xmin = 0.0
  xmax = 5.75
  ymin = 0.0
  ymax = 12.0
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

[Constraints]
  [./xfem_u_constraint]
    type = XFEMSingleVariableConstraint
    variable = u
    geometric_cut_userobject = 'level_set_cut_uo'
    use_penalty = true
    alpha = 1e5
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
  [./u_diff]
    type = MatDiffusion
    variable = u
    diffusivity = 'D'
  [../]
  [./u_time]
    type = TimeDerivative
    variable = u
  [../]
[]

[AuxKernels]
  [./ls_function]
    type = FunctionAux
    variable = phi
    function = ls_func
  [../]
[]

[Functions]
#  [./left_u_func]
#    type = PiecewiseBilinear
#    axis = 1
#    x = '0.0  3.0  6.0  9.0  12.0'
#    y = '0.0  1.0'
#    z = '620.0  619.8  619.5  619.05  618.35
#         620.0  619.8  619.5  619.05  618.35'
#  [../]
  [./left_u_func]
    type = PiecewiseLinear
    x = '0.0  3.0  6.0  9.0  12.0'
    y = '620.0  619.8  619.5  619.05  618.35'
  [../]
  [./ls_func]
    type = ParsedFunction
    value = '3.5 - x - 0.01*t'
  [../]
[]

[Materials]
  [./D_prop]
    type = GenericConstantMaterial
    prop_names =  'A_D   B_D'
    prop_values = '20.0  2.0'
  [../]

  [./combined_D]
    type = LevelSetBiMaterialReal
    levelset_positive_base = 'A'
    levelset_negative_base = 'B'
    level_set_var = phi
    prop_name = D
  [../]
[]

[BCs]
  [./left_u]
    type = FunctionDirichletBC
    variable = u
    function = left_u_func
    boundary = 'left'
  [../]
  [./right_u]
    type = DirichletBC
    variable = u
    value = 580.0
    boundary = 'right'
  [../]
[]

#[ICs]
#  [./u_ic]
#    type = ConstantIC
#    variable = u
#    value = 580.0
#  [../]
#[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  line_search = 'none'

  l_tol = 1.0e-6
  nl_max_its = 15
  nl_rel_tol = 1.0e-10
  nl_abs_tol = 1.0e-9

  start_time = 0.0
  end_time = 50.0
  dt = 25.0

  max_xfem_update = 2
[]

[Outputs]
  interval = 1
  execute_on = 'initial timestep_end' # TODO may need to turn this off
  exodus = true
  [./console]
    type = Console
    output_linear = true
  [../]
[]
