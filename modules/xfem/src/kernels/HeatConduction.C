/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#include "HeatConduction.h"
#include "MooseMesh.h"

registerMooseObject("XFEMApp", HeatConduction);

template <>
InputParameters
validParams<HeatConduction>()
{
  InputParameters params = validParams<Diffusion>();
  params.addClassDescription(
      "Computes residual/Jacobian contribution for diffusion equation with diffusivity.");
  params.addParam<std::string>("base_name",
                               "Optional parameter that allows the user to define "
                               "mutliple materials systems on the same block.");
  return params;
}

HeatConduction::HeatConduction(const InputParameters & parameters)
  : Diffusion(parameters),
    _diffusion_coefficient(getMaterialProperty<Real>("diffusion_coefficient")),
    _diffusion_coefficient_dT(hasMaterialProperty<Real>("diffusion_coefficient_dT")
                                  ? &getMaterialProperty<Real>("diffusion_coefficient_dT")
                                  : NULL)
{
}

Real
HeatConduction::computeQpResidual()
{
  return _diffusion_coefficient[_qp] * Diffusion::computeQpResidual();
}

Real
HeatConduction::computeQpJacobian()
{
  Real jac = _diffusion_coefficient[_qp] * Diffusion::computeQpJacobian();
  if (_diffusion_coefficient_dT)
    jac += (*_diffusion_coefficient_dT)[_qp] * _phi[_j][_qp] * Diffusion::computeQpResidual();
  return jac;
}
