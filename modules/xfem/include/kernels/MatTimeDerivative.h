#ifndef MATTIMEDERIVATIVE_H
#define MATTIMEDERIVATIVE_H

#include "TimeDerivative.h"

// Forward Declaration
class MatTimeDerivative;

template<>
InputParameters validParams<MatTimeDerivative>();

class MatTimeDerivative : public TimeDerivative
{
public:
  MatTimeDerivative(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  const MaterialProperty<Real> & _mat_prop_value;

};

#endif // MATTIMEDERIVATIVE_H
