import 'package:floor/floor.dart';

@entity
class Employee
{
  @PrimaryKey(autoGenerate: true)
  int? idTemp;
  int? id;
  String name;
  int salary;
  int? ts;
  int deleted;

  Employee(this.idTemp, this.id, this.name, this.salary, this.ts, this.deleted);

  factory Employee.fromJson(Map<String, dynamic> json)
  {
    return Employee(json['idTemp'], json['id'], json['name'], json['salary'], json['ts'], json['deleted']);
  }

  Map<String, dynamic> toJson()
  {
    return {'idTemp':idTemp, 'id':id, 'name':name, 'salary':salary, 'ts':ts, 'deleted':deleted};
  }
}