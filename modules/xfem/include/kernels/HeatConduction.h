/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef HEATCONDUCTION_H
#define HEATCONDUCTION_H

#include "Diffusion.h"
#include "Material.h"

// Forward Declarations
class HeatConduction;

template <>
InputParameters validParams<HeatConduction>();

class HeatConduction : public Diffusion
{
public:
  HeatConduction(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();

  virtual Real computeQpJacobian();

private:
  std::string _base_name;

  const MaterialProperty<Real> & _diffusion_coefficient;
  const MaterialProperty<Real> * const _diffusion_coefficient_dT;
};

#endif // HEATCONDUCTION_H
