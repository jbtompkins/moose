//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Action.h"
#include "UserObjectInterface.h"

class XFEMAction;

template <>
InputParameters validParams<XFEMAction>();

class XFEMAction : public Action
{
public:
  XFEMAction(InputParameters params);

  virtual void act();

protected:
  std::vector<UserObjectName> _geom_cut_userobjects;
  std::string _xfem_qrule;
  std::string _order;
  std::string _family;
  bool _xfem_cut_plane;
  bool _xfem_use_crack_growth_increment;
  Real _xfem_crack_growth_increment;
  bool _use_crack_tip_enrichment;
  UserObjectName _crack_front_definition;
  std::vector<VariableName> _enrich_displacements;
  std::vector<VariableName> _displacements;
  std::vector<BoundaryName> _cut_off_bc;
  Real _cut_off_radius;
  bool _setup_variable_constraints;
  std::vector<NonlinearVariableName> _constraint_variables;
  std::vector<UserObjectName> _constraint_cut_userobjects;
  bool _define_continuity_method;
  std::vector<bool> _penalty_method_use;
  bool _define_constraint_alphas;
  std::vector<Real> _constraint_alphas;
  bool _define_constraint_jumps;
  std::vector<FunctionName> _constraint_jumps;
  bool _define_constraint_flux_jumps;
  std::vector<FunctionName> _constraint_flux_jumps;
  bool _define_use_displaced_mesh_constraint;
  bool _displaced_mesh_constraint;
};

