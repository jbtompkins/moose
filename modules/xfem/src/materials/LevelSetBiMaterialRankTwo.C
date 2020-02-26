//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "LevelSetBiMaterialRankTwo.h"

registerMooseObject("XFEMApp", LevelSetBiMaterialRankTwo);

template <>
InputParameters
validParams<LevelSetBiMaterialRankTwo>()
{
  InputParameters params = validParams<LevelSetBiMaterialBase>();
  params.addClassDescription(
      "Compute a RankTwoTensor material property for bi-materials problem (consisting of two "
      "different materials) defined by a level set function.");
  return params;
}

LevelSetBiMaterialRankTwo::LevelSetBiMaterialRankTwo(const InputParameters & parameters)
  : LevelSetBiMaterialBase(parameters)
{
  _bimaterial_material_props.resize(_num_props);
  _material_props.resize(_num_props);

  for (unsigned int i = 0; i < _num_props; i++)
  {
    _bimaterial_material_props[i].resize(2);
    _material_props[i] = &declareProperty<RankTwoTensor>(_base_name + _prop_names[i]);

    _bimaterial_material_props[i][0] = &getMaterialProperty<RankTwoTensor>(
        getParam<std::string>("levelset_positive_base") + "_" + _prop_names[i]);
    _bimaterial_material_props[i][1] = &getMaterialProperty<RankTwoTensor>(
        getParam<std::string>("levelset_negative_base") + "_" + _prop_names[i]);
  }
}

void
LevelSetBiMaterialRankTwo::assignQpPropertiesForLevelSetPositive()
{
  for (unsigned int i = 0; i < _num_props; i++)
    (*_material_props[i])[_qp] = (*_bimaterial_material_props[i][0])[_qp];
}

void
LevelSetBiMaterialRankTwo::assignQpPropertiesForLevelSetNegative()
{
  for (unsigned int i = 0; i < _num_props; i++)
    (*_material_props[i])[_qp] = (*_bimaterial_material_props[i][1])[_qp];
}
