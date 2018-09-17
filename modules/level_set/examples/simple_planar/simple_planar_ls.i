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

[Variables]
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

[ICs]
  [./phi_ic]
    type = FunctionIC
    function = phi_exact
    variable = phi
  [../]
[]

[Functions]
  [./phi_exact]
    type = ParsedFunction
    value = '-0.5*x -0.5*y + 2.04 -0.2*t'
  [../]
[]

[Kernels]
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

[Executioner]
  type = Transient
  solve_type = PJFNK
  start_time = 0
  end_time = 2
  scheme = crank-nicolson
  petsc_options_iname = '-pc_type -pc_sub_type'
  petsc_options_value = 'asm      ilu'
  dt = 0.1
[]

[Outputs]
  exodus = true
[]
    
