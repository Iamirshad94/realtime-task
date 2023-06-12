import '../models/employee_model.dart';

class EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;

  AddEmployee(this.employee);
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;

  UpdateEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final int id;

  DeleteEmployee(this.id);
}

class EmployeeFormUpdate<T> extends EmployeeEvent {
  DateTime? selectedDate;
  T? employeeRole;


  EmployeeFormUpdate({this.selectedDate, this.employeeRole});
}
