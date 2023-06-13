class Employee {
  final int? id;
  final String name;
  final String profession;
  final String fromDate;
  final String endDate;

  Employee({
     this.id,
    required this.name,
    required this.profession,
    required this.fromDate,
    required this.endDate,
  });

   Map<String,dynamic> toMap(){ // used when inserting data to the database
     return <String,dynamic>{
       "id" : id,
       "name" : name,
       "profession" : profession,
       "fromDate":fromDate,
       'endDate':endDate,
     };
   }
}
