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
        // Navigator.pop(AppRouter.navigatorKey.currentContext!);
        emit(LoadedEmployeeState(employeeGroups));
      } catch (e) {
        emit(ErrorEmployeeState('Something went wrong'));
      }
    });


    on<AddEmployee>((event, emit) async {
      try {
        await repository.addEmployee(event.employee);
        final employees = await repository.getEmployees();
        Navigator.pushNamed(AppRouter.navigatorKey.currentContext!, RouteConstants.homeRoute);
        debugPrint('employee list ${employees[0].name}');
        emit(LoadedEmployeeState(employees));
      } catch (e) {
        emit(ErrorEmployeeState('Failed to add employee'));
      }
    });

    on<DeleteEmployee>((event, emit) async {
      try {
        await repository.deleteEmployee(int.parse(event.id));
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
      } catch (e) {
        emit(ErrorEmployeeState('Failed to delete employee'));
      }
    });
  }

  // @override
  // Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
  //   on<AddEmployee>((emit,state)async{
  //     emit(UserLoadingState());
  //
  //   });
  //   if (event is LoadEmployees) {
  //     yield EmployeeLoading();
  //     try {
  //       final employeeGroups = await repository.getEmployeeGroups();
  //       yield EmployeeLoaded(employeeGroups);
  //     } catch (e) {
  //       yield EmployeeError('Failed to load employees');
  //     }
  //   } else if (event is AddEmployee) {
  //     try {
  //       await repository.insertEmployee(event.employee);
  //       final employeeGroups = await repository.getEmployeeGroups();
  //       yield EmployeeLoaded(employeeGroups);
  //     } catch (e) {
  //       yield EmployeeError('Failed to add employee');
  //     }
  //   } else if (event is UpdateEmployee) {
  //     try {
  //       await repository.updateEmployee(event.employee);
  //       final employeeGroups = await repository.getEmployeeGroups();
  //       yield EmployeeLoaded(employeeGroups);
  //     } catch (e) {
  //       yield EmployeeError('Failed to update employee');
  //     }
  //   } else if (event is DeleteEmployee) {
  //     try {
  //       await repository.deleteEmployee(event.name);
  //       final employeeGroups = await repository.getEmployeeGroups();
  //       yield EmployeeLoaded(employeeGroups);
  //     } catch (e) {
  //       yield EmployeeError('Failed to delete employee');
  //     }
  //   }
  // }
}
