import 'package:flutter/material.dart';
import 'package:realtime_task/screens/add_employee.dart';
import 'package:realtime_task/screens/edit_employee.dart';
import 'package:realtime_task/screens/home_page.dart';

class AppRouter {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/add-employee':
        return MaterialPageRoute(builder: (_) => AddEmployeeScreen());
      case '/edit-employee':
        return MaterialPageRoute(builder: (_) => EditEmployeeDetails());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}