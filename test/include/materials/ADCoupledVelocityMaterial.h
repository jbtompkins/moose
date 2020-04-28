//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Material.h"

class ADCoupledVelocityMaterial : public Material
{
public:
  static InputParameters validParams();

  ADCoupledVelocityMaterial(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  ADMaterialProperty<RealVectorValue> & _velocity;

  const ADVariableValue & _vel_x;
  const ADVariableValue * _vel_y;
  const ADVariableValue * _vel_z;
};
