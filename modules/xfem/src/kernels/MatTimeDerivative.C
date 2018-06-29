#include "MatTimeDerivative.h"

registerMooseObject("XFEMApp", MatTimeDerivative);

template<>
InputParameters
validParams<MatTimeDerivative>()
{
  InputParameters params = validParams<TimeDerivative>();
  params.addRequiredParam<MaterialPropertyName>("mat_prop_value", "Material"
                                                "property to multiply by time"
                                                "derivative");
  return params;
}

MatTimeDerivative::MatTimeDerivative(const InputParameters & parameters)
  : TimeDerivative(parameters),
    _mat_prop_value(getMaterialProperty<Real>("mat_prop_value"))
{}

Real MatTimeDerivative::computeQpResidual()
{
  return _mat_prop_value[_qp] * TimeDerivative::computeQpResidual();
}

Real MatTimeDerivative::computeQpJacobian()
{
  return _mat_prop_value[_qp] * TimeDerivative::computeQpJacobian();
}
