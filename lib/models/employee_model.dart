// Models
class EmployeeGroup {
  final String groupName;
  final List<Employee> employees;

  EmployeeGroup({
    required this.groupName,
    required this.employees,
  });
}

class Employee {
   String? id;
  final String name;
  final String profession;
  final String dateTime;

  Employee({
     this.id,
    required this.name,
    required this.profession,
    required this.dateTime,
  });
}