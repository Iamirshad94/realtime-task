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
  final int? id;
  final String name;
  final String profession;
  final String dateTime;

  Employee({
     this.id,
    required this.name,
    required this.profession,
    required this.dateTime,
  });

   Map<String,dynamic> toMap(){ // used when inserting data to the database
     return <String,dynamic>{
       "id" : id,
       "name" : name,
       "profession" : profession,
       "dateTime":dateTime
     };
   }
}
