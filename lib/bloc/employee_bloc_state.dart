
// States
import '../models/employee_model.dart';

abstract class EmployeeState {}

class LoadingEmployeeState extends EmployeeState {}

class LoadedEmployeeState extends EmployeeState {
  final List<Employee> employee;

  LoadedEmployeeState(this.employee);
}

class ErrorEmployeeState extends EmployeeState {
  final String errorMessage;

  ErrorEmployeeState(this.errorMessage);
}