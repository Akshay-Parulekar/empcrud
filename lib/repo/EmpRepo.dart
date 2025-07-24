import 'package:empcrud/entity/Employee.dart';
import 'package:floor/floor.dart';

@dao
abstract class EmpRepo
{
  @Query("select * from Employee")
  Stream<List<Employee>> watchAll();

  @Query("select * from Employee where idTemp = :idTemp")
  Future<void> getEmp(int idTemp);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> save(Employee emp);

  Future<void> delete(Employee emp)
  async {
    emp.deleted = 1;
    save(emp);
  }
}