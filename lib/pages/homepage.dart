import 'package:empcrud/entity/Employee.dart';
import 'package:empcrud/pages/form.dart';
import 'package:empcrud/repo/EmpRepo.dart';
import 'package:empcrud/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../db/AppDatabase.dart';
import '../service/api_service.dart';

class HomePage extends StatefulWidget
{
  AppDatabase db;

  HomePage(this.db);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EmpRepo empRepo;
  late List<Employee> listEmp;
  late StompClient stompClient;


  @override
  void initState() {
    empRepo = widget.db.empRepo;
    empRepo.configDio(context);
    empRepo.syncData();
    _initWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employees"), backgroundColor: Colors.lightBlue, foregroundColor: Colors.white,),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        Employee empModified = await Navigator.push(context, MaterialPageRoute(builder: (context) => EmpForm(null)));
        await empRepo.save(empModified);
        await empRepo.uploadData();
      }, child: Icon(Icons.add), backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
      body: RefreshIndicator(
        onRefresh: () async{
          await empRepo.syncData();
          },
        child: StreamBuilder(
          stream: empRepo.watchAll(),
          builder: (BuildContext context, AsyncSnapshot<List<Employee>> snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }

            if(snapshot.hasError){
              return Center(child: Text("Errors : ${snapshot.error}"));
            }

            if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(child: Text("No Employee Found"));
            }

            listEmp = snapshot.data!;

            return ListView.builder(itemBuilder: (context, index) {
              Employee emp = listEmp[index];

              return Dismissible(
                key: ValueKey(emp.id),
                background: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  )
                  ,
                ),
                confirmDismiss: (direction) {
                  return showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Delete?"),
                      content: Text("Are you sure you want to delete this record?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, true), child: Text("YES")),
                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text("NO")),
                      ],
                    );
                  },);
                },
                onDismissed: (direction) async {
                  await empRepo.delete(emp);
                  await empRepo.uploadData();
                },
                child: ListTile(
                  title: Text(emp.name),
                  subtitle: Text(emp.salary.toString()),
                  leading: Text(emp.id.toString()),
                  trailing: Icon(
                    emp.id==null?Icons.access_time:Icons.done,
                    color: emp.id==null?Colors.red:Colors.green,
                  ),
                  onTap: () async {
                    Employee empModified = await Navigator.push(context, MaterialPageRoute(builder: (context) => EmpForm(emp)));
                    await empRepo.save(empModified);
                    await empRepo.uploadData();
                  },
                ),
              );
            },
              itemCount: listEmp.length,
            );
          },
        ),
      )
    );
  }

  void _initWebSocket()
  {
    stompClient = StompClient(
        config: StompConfig.sockJS(
          url: "${myBaseUrl}/ws/",
          onWebSocketError: (p0) => print('websocket failed ${p0.toString()}'),
          onConnect: (frame)
          {
            stompClient.subscribe(destination: "/topic/emp/", callback: (frame) async
            {
              if(frame.body != idClient)
              {
                print("recieved data by websocket");
                empRepo.downloadData();
              }
            },);
          },));

    stompClient.activate();
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }
}