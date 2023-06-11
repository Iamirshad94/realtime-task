import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_task/navigation/routing.dart';
import 'package:realtime_task/repository/database.dart';
import 'package:realtime_task/screens/home_page.dart';
import 'package:realtime_task/utility/route_constants.dart';

import 'bloc/employee_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final employeeRepository = EmployeeRepository();
  await employeeRepository.init();
  runApp( BlocProvider(
    create: (context) => EmployeeBloc(employeeRepository),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealTime Task',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRouter.navigatorKey,
      theme: ThemeData(
       scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blue,
        textTheme:const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            color: Colors.lightBlueAccent,
          ),
          titleMedium: TextStyle(
            color: Colors.black,
            fontSize: 18
          ),
          titleSmall: TextStyle(
            color: Colors.grey,
          ),
          labelLarge: TextStyle(
            color: Colors.grey,
          ),

        ),
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: RouteConstants.homeRoute,
      home: HomePage(),
    );
  }
}

