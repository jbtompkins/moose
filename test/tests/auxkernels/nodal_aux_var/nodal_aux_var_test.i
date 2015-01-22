[Mesh]
  file = square.e
[]

[Variables]
  active = 'u'

  [./u]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  active = 'one five coupled'

  [./one]
    order = FIRST
    family = LAGRANGE
  [../]

  [./five]
    order = FIRST
    family = LAGRANGE
  [../]

  [./coupled]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  active = 'diff force'

  [./diff]
    type = Diffusion
    variable = u
  [../]

  #Coupling of nonlinear to Aux
  [./force]
    type = CoupledForce
    variable = u
    v = one
  [../]
[]

[AuxKernels]
  #Simple Aux Kernel
  [./constant]
    variable = one
    type = ConstantAux
    value = 1
  [../]

  #Shows coupling of Aux to nonlinear
  [./coupled]
    variable = coupled
    type = CoupledAux
    value = 2
    coupled = u
  [../]

  [./five]
    type = ConstantAux
    variable = five
    boundary = '1 2'
    value = 5
  [../]

[]

[BCs]
  active = 'left right'

  [./left]
    type = DirichletBC
    variable = u
    boundary = 1
    value = 0
  [../]

  [./right]
    type = DirichletBC
    variable = u
    boundary = 2
    value = 1
  [../]
[]

[Executioner]
  type = Steady

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
[]

[Outputs]
  output_initial = true
  file_base = out
  exodus = true
  print_perf_log = true
[]
