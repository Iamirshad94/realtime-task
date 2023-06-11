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
          'CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, profession TEXT, dateTime TEXT)',
        );
      },
    );
  }

  Future<void> addEmployee(Employee employee) async {
    debugPrint('id id - ${employee.id}');
    debugPrint('name -- ${employee.name}');
    debugPrint('profession ${employee.profession}');
    debugPrint('date time --- ${employee.dateTime}');
    await _database.insert(
      'employees',
      {
        // 'id':employee.id,
        'name': employee.name,
        'profession': employee.profession,
        'dateTime': employee.dateTime,
      },
    );
  }

    Future<void> clearData() async {
      await _database.delete('employees');
    }


  Future<List<Employee>> getEmployees() async {
    final List<Map<String, dynamic>> employeeMaps = await _database.query('employees');
    return employeeMaps.map((employeeMap) {
      return Employee(
        // id: employeeMap['id'],
        name: employeeMap['name'],
        profession: employeeMap['profession'],
        dateTime: employeeMap['dateTime'],
      );
    }).toList();
  }

  Future<void> updateEmployee(Employee employee) async {
    await _database.update(
      'employees',
      {
        'name': employee.name,
        'profession': employee.profession,
        'dateTime': employee.dateTime,
      },
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<void> deleteEmployee(int id) async {
    await _database.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
