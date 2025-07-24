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
}