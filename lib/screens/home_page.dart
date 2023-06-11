import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:realtime_task/bloc/employee_bloc.dart';
import 'package:realtime_task/bloc/employee_bloc_event.dart';
import 'package:realtime_task/models/employee_model.dart';
import 'package:realtime_task/repository/database.dart';
import 'package:realtime_task/utility/constants.dart';
import 'package:realtime_task/utility/custom_appbar.dart';
import 'package:realtime_task/utility/route_constants.dart';
import '../bloc/employee_bloc_state.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  late EmployeeBloc _employeeBloc ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _employeeBloc=BlocProvider.of<EmployeeBloc>(context);
    loadData();
  }


  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    _employeeBloc.add(LoadEmployees());
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Employee List',
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  EmployeeRepository().clearData();
                });
              },
              icon: const Icon(Icons.clear))
        ],
      ),
      body:
      BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is LoadingEmployeeState && _isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedEmployeeState) {
            final employees = state.employee;
            return EmployeeList(
              employeeList: employees,
            );
          } else {
            return const SizedBox();
          }
        },
      ),      bottomSheet: Container(
          height: screenSize.height * 0.04,
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
                child: Text(
              'Swipe left or right to delete an item',
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
    BlocProvider.of<EmployeeBloc>(context).close();
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

  EmployeeList({this.employeeList});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  void _removeItem(int employeeGroupIndex, int employeeIndex) {
    setState(() {
      // employeeGroups[employeeGroupIndex].employees.removeAt(employeeIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.employeeList?.length,
      itemBuilder: (context, childIndex) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            setState(() {
             widget.employeeList?.removeAt(childIndex);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Employee data has been deleted!'),
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
              Navigator.pushNamed(context, RouteConstants.editEmployeeRoute);
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
                          widget.employeeList?[childIndex].name ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          widget.employeeList?[childIndex].profession ?? '',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          widget.employeeList?[childIndex].dateTime ?? '',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        );
      },
    );

    //   ListView.builder(
    //   itemCount: employeeGroups.length,
    //   itemBuilder: (context, index) {
    //     final employeeGroup = employeeGroups[index];
    //     return Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Container(
    //           color: Colors.grey.withOpacity(0.1),
    //           width: double.infinity,
    //           child: Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
    //             child: Text(
    //                 index == 0 ? 'Current Employees' : 'Previous Employees',
    //                 style: Theme.of(context).textTheme.titleLarge),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
