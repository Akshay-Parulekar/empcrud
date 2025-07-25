import 'package:dio/dio.dart';
import 'package:empcrud/entity/Employee.dart';
import 'package:empcrud/util/utils.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

import '../service/api_service.dart';

@dao
abstract class EmpRepo
{
  Dio? dio;

  @Query("select * from Employee where deleted = 0")
  Stream<List<Employee>> watchAll();

  @Query("select * from Employee where id = :id")
  Future<Employee?> getById(int id);

  @Query("select coalesce(max(ts), 0) from Employee")
  Future<int?> getMaxTs();

  @Query("select * from Employee where ts is null")
  Future<List<Employee?>> getUnsynced();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> save(Employee emp);

  Future<void> delete(Employee emp)
  async {
    emp.deleted = 1;
    emp.ts = null;
    save(emp);
  }

  Future<void> downloadData() async
  {
    int? maxTs = await getMaxTs();
    print('maxTs before download() : ${maxTs}');
    print('endpoint for download : ${Endpoints.emp}');

    final response = await dio?.post(Endpoints.emp, data: {'ts': maxTs});

    print('response after download() : ${response.toString()}');

    List<Employee> listEmpDownloaded = (response?.data as List).map((jsonObj) => Employee.fromJson(jsonObj)).toList();
    for(Employee empServer in listEmpDownloaded)
    {
      Employee? empClient = await getById(empServer.id!);

      if(empClient != null)
      {
        empServer.idTemp = empClient.idTemp;
      }

      save(empServer);
    }
  }

  Future<void> uploadData() async
  {
    List<Employee?> listEmpUnsynced = await getUnsynced();
    for(Employee? emp in listEmpUnsynced)
    {
      if(emp != null)
      {
        Map<String, dynamic> payload = emp.toJson();
        payload['idClient'] = idClient;
        payload.remove('idTemp');

        print('payload = ${payload.toString()}');

        final response = await dio?.post("${Endpoints.emp}/save/", data: payload);
        print('response after upload() : ${response}');

        Employee empServer = Employee.fromJson(response?.data);
        emp.id = empServer.id;
        emp.ts = empServer.ts;
        await save(emp);
      }
    }
  }

  // Configure Dio
  void configDio(BuildContext context)
  {
    print('myBaseUrl : ${myBaseUrl}');
    this.dio = Dio(BaseOptions(
        baseUrl: myBaseUrl,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30)
    ));

    dio?.interceptors.add(getInterceptor(context));
  }

  Future<void> syncData() async {
    await downloadData();
    await uploadData();
  }

}