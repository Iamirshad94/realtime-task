// Repository
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/employee_model.dart';

class EmployeeRepository {
  static final EmployeeRepository _singleton = EmployeeRepository._internal();

  factory EmployeeRepository() {
    return _singleton;
  }

  EmployeeRepository._internal();

  late Database _database;

  Future<void> init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'employee_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE employees(id INTEGER PRIMARY KEY, name TEXT, profession TEXT, fromDate TEXT, endDate TEXT)',
        );
      },
    );
  }

  Future<int> addEmployee(Employee employee) async {
    final Map<String, dynamic> employeeMap = employee.toMap();
    final id = await _database.insert('employees', employeeMap);
    return id;
  }

  Future<List<Employee>> getEmployees() async {
    final List<Map<String, dynamic>> employeeMaps = await _database.query('employees');
    return employeeMaps.map((employeeMap) {
      return Employee(
        id: employeeMap['id'],
        name: employeeMap['name'],
        profession: employeeMap['profession'],
        fromDate: employeeMap['fromDate'],
        endDate: employeeMap['endDate'],
      );
    }).toList();
  }

  Future<void> updateEmployee(Employee employee) async {
    final Map<String, dynamic> employeeMap = employee.toMap();
    await _database.update(
      'employees',
      employeeMap,
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<void> deleteEmployee(int employeeId) async {
    await _database.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [employeeId],
    );
  }

  Future<void> closeDatabase() async {
   await _database.close();
  }
}
