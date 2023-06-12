import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:realtime_task/bloc/employee_bloc.dart';
import 'package:realtime_task/bloc/employee_bloc_event.dart';
import 'package:realtime_task/models/employee_model.dart';
import 'package:realtime_task/utility/constants.dart';
import 'package:realtime_task/utility/custom_appbar.dart';
import 'package:realtime_task/utility/route_constants.dart';
import '../bloc/employee_bloc_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool _isLoading = true;
  late EmployeeBloc _employeeBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    _employeeBloc.add(LoadEmployees());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: const CustomAppBar(
        title: 'Employee List',
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is LoadingEmployeeState && _isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedEmployeeState) {
            final employees = state.employee;
            if (employees.isEmpty) {
              return const EmptyState();
            } else {
              return EmployeeList(
                employeeList: employees,
              );
            }
          } else {
            return const SizedBox();
          }
        },
      ),
      bottomSheet: Container(
          height: screenSize.height * 0.04,
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
                child: Text(
              AppConstants.swipeLeft,
              style: Theme.of(context).textTheme.titleSmall,
            )),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteConstants.addEmployeeRoute);
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: const Icon(Icons.add),
      ),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: SvgPicture.asset(AppConstants.emptyStateImage));
  }
}

class EmployeeList extends StatefulWidget {
  List<Employee>? employeeList;

  EmployeeList({super.key, this.employeeList});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  late EmployeeBloc _employeeBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _employeeBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.employeeList?.length,
      itemBuilder: (context, childIndex) {
        var employee = widget.employeeList?[childIndex];
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            _employeeBloc.add(DeleteEmployee(employee.id!));
            widget.employeeList?.removeAt(childIndex);
            _employeeBloc.add(DeleteEmployee(employee.id!));

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppConstants.dataDeleteMsg),
                duration: Duration(seconds: 2),
              ),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteConstants.editEmployeeRoute,
                  arguments: Employee(
                      id: employee.id,
                      name: employee.name,
                      profession: employee.profession,
                      dateTime: employee.dateTime));
            },
            child: SizedBox(
              width: double.infinity,
              child: Card(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee!.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      employee.profession,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.employeeList?[childIndex].dateTime ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              )),
            ),
          ),
        );
      },
    );
  }
}
