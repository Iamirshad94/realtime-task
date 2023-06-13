import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../navigation/routing.dart';
import '../repository/database.dart';
import '../utility/route_constants.dart';
import 'employee_bloc_event.dart';
import 'employee_bloc_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc(this.repository) : super(LoadingEmployeeState()) {
    on<LoadEmployees>((event, emit) async {
      emit(LoadingEmployeeState());
      try {
        final employeeGroups = await repository.getEmployees();
        emit(LoadedEmployeeState(employeeGroups));
      } catch (e) {
        emit(ErrorEmployeeState('Something went wrong'));
      }
    });

    on<AddEmployee>((event, emit) async {
      try {
        await repository.addEmployee(event.employee);
        final employees = await repository.getEmployees();
        Navigator.of(AppRouter.navigatorKey.currentContext!)
            .pushNamedAndRemoveUntil( RouteConstants.homeRoute, (Route<dynamic> route) => false);
        debugPrint('employee list ${employees[0].name}');
        emit(LoadedEmployeeState(employees));
      } catch (e) {
        emit(ErrorEmployeeState('Failed to add employee'));
      }
    });

    on<DeleteEmployee>((event, emit) async {
      try {
        await repository.deleteEmployee(event.id);
        final employeeGroups = await repository.getEmployees();
        emit(LoadedEmployeeState(employeeGroups));
      } catch (e) {
        emit(ErrorEmployeeState('Failed to delete employee'));
      }
    });

    on<UpdateEmployee>((event, emit) async {
      try {
        await repository.updateEmployee(event.employee);
        final employeeGroups = await repository.getEmployees();
        emit(LoadedEmployeeState(employeeGroups));
        Navigator.of(AppRouter.navigatorKey.currentContext!)
            .pushNamedAndRemoveUntil( RouteConstants.homeRoute, (Route<dynamic> route) => false);
      } catch (e) {
        emit(ErrorEmployeeState('Failed to delete employee'));
      }
    });

    on<EmployeeFormUpdate>((event, emit) async {
      debugPrint('date parsing ${event.selectedDate}');
      try{
        emit(EmployeeFromState(selectedDate: event.selectedDate,selectedDateTo: event.selectedDateTo,employeeRole: event.employeeRole));
      }
      catch(e){
        debugPrint('$e');
      }
    });
  }
}
