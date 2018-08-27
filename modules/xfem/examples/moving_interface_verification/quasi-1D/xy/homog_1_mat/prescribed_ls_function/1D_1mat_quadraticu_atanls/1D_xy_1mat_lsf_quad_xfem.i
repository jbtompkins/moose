# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# XFEM Moving Interface Verification Problem #0.0.0.0.00
# Dimensionality:                                         1D
# Coordinate System:                                      xy
# Material Numbers/Types:               1 material, 2 region
# Element Order:                                         2nd
# Companion Problems:                            #0.0.0.0.01
# Interface Characteristics: u independent, prescribed arctan level set function
# The purpose of this problem is as an initial investigation into XFEM
#   capabilities. It is designed in conjuction with its companion problem
#   to illustrate the effect and errors introduced by cutting the mesh and 
#   evaluating a single element problem in an enriched solution field. The
#   companion problem is run in a single region (MOOSE only) designed using the 
#   Method of Manufactured Solutions that is solved exactly (prescribed 
#   solution is quadratic, evaluated with 2nd order basis functions), so any
#   differences between solutions will be due to the XFEM evaluation. The 
#   problem is a transient heat conduction one, but the cut location determined
#   by a prescribed level set function (arctangent) is also compared to the 
#   actual location to illustrate the method the XFEM module uses to mark 
#   the location of a cut for a level set cut user object.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

[GlobalParams]
  order = SECOND
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
  elem_type = QUAD8
[]

[XFEM]
  qrule = volfrac
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
    order = SECOND
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
    value = '10*(-200*x^2+200)+400*1.5*t'
  [../]
  [./ls_func]
    type = ParsedFunction
    value = 'atan(1-(x-0.04)-0.2*t)'
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
  [./left_u]
    type = NeumannBC
    variable = u
    boundary = 'left'
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

  l_tol = 1.0e-3
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
