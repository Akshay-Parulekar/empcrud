import 'package:empcrud/entity/Employee.dart';

class EmpRepo
{
  List<Employee> listEmp = [
    Employee(1, 1, "Kaif", 99999, 1111, 0),
    Employee(1, null, "Hedley", 99999, null, 0),
    Employee(1, 1, "Govind", 99999, 1111, 0),
    Employee(1, null, "Baburav", 99999, null, 0),
  ];

  List<Employee> findAll()
  {
    return listEmp;
  }

  void save(Employee emp)
  {
    listEmp.add(emp);
  }

  void delete(Employee emp)
  {
    listEmp.remove(emp);
  }
}