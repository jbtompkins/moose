/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef NSWEAKSTAGNATIONBC_H
#define NSWEAKSTAGNATIONBC_H

#include "NSIntegratedBC.h"

// Forward Declarations
class NSWeakStagnationBC;


// Specialization required of all user-level Moose objects
template<>
InputParameters validParams<NSWeakStagnationBC>();


/**
 * This is the base class for "weakly-imposed" stagnation boundary
 * conditions, that is the relevant boundary integrals are evaluated
 * based on valued implied by fixed stagnation temperature and pressure
 * values and specified flow direction (but not magnitude).
 */
class NSWeakStagnationBC : public NSIntegratedBC
{
public:
  // Constructor
  NSWeakStagnationBC(const std::string & name, InputParameters parameters);

  // Destructor, better be virtual
  virtual ~NSWeakStagnationBC(){}

protected:
  /**
   * Must be implemented in derived classes.
   */
  // virtual Real computeQpResidual();
  // virtual Real computeQpJacobian();
  // virtual Real computeQpOffDiagJacobian(unsigned jvar);

  // Required parameters
  Real _stagnation_pressure;
  Real _stagnation_temperature;

  // Specified flow direction.  Should be the components of
  // a unit vector.  TODO: Test reading RealVectorValue objects
  // directly?
  Real _sx;
  Real _sy;
  Real _sz; // only required in 3D

  //
  // Helper functions...
  //

  // Given |u|, p_0, and T_0, compute static quantities.  Each
  // on depends on the previous, so it makes sense to compute them
  // all even if you don't need them all...
  void static_values(Real& T_s, Real& p_s, Real& rho_s);

  // Nicer interface if you actually only want one of the static values.
  // Note that they will all still be computed!
  Real rho_static();

  // The velocity magnitude, squared
  Real velmag2();

  // The specified flow direction, s, dotted with the outward unit normal
  // normal vector
  Real sdotn();
};


#endif // NSSTAGNATIONBC_H
