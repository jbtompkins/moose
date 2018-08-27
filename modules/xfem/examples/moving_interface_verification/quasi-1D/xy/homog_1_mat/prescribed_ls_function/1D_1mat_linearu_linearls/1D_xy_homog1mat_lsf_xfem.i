# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# XFEM Moving Interface Verification Problem #0.0.0.0.03
# Dimensionality:                                         1D
# Coordinate System:                                      xy
# Material Numbers/Types:   homogeneous 1 material, 2 region
# Element Order:                                         1st
# Companion Problems:                            #0.0.0.0.04
# Interface Characteristics: u independent, prescribed linear level set function 
# A simple single element heat transfer problem designed with the Method of 
#   Manufactured Solutions to have a linear temperature profile. After the
#   results of Problem #00.0 showed that the XFEM module does not have the
#   capability to preserve 2nd order elements in enriched elements, this 
#   problem was developed to further investigate differences in MOOSE
#   solutions on linear elements and XFEM performance. Both the temperature
#   solution and level set function are chosen to be linear to attempt to 
#   minimize error between the MOOSE/exact solution and XFEM results.
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
  [./xfem_constraint]
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
    value = '10*(-200*x+200)'
  [../]
  [./ls_func]
    type = ParsedFunction
    value = '1-(x-0.04)-0.2*t'
  [../]
  [./neumann_func]
    type = ParsedFunction
    value = '1.5*200*t'
  [../]
[]

[Materials]
  [./mat_time_deriv_prop]
    type = GenericConstantMaterial
    prop_names = 'rhoCp'
    prop_values = 10
  [../]
  [./therm_cond_prop]
    type = GenericConstantMaterial
    prop_names = 'diffusion_coefficient'
    prop_values = 1.5
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
