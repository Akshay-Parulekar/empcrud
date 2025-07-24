import 'package:empcrud/entity/Employee.dart';
import 'package:empcrud/pages/form.dart';
import 'package:empcrud/repo/EmpRepo.dart';
import 'package:empcrud/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../db/AppDatabase.dart';

class HomePage extends StatefulWidget {

  AppDatabase db;


  HomePage(this.db);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EmpRepo empRepo;
  late List<Employee> listEmp;


  @override
  void initState() {
    empRepo = widget.db.empRepo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employees"), backgroundColor: Colors.lightBlue, foregroundColor: Colors.white,),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        Employee empModified = await Navigator.push(context, MaterialPageRoute(builder: (context) => EmpForm(null)));
        empRepo.save(empModified);
      }, child: Icon(Icons.add), backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
      body: RefreshIndicator(
        onRefresh: () async{
          setState(() {});},
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
                  setState(() {});
                },
                child: ListTile(
                  title: Text(emp.name),
                  subtitle: Text(emp.salary.toString()),
                  trailing: Icon(
                    emp.id==null?Icons.access_time:Icons.done,
                    color: emp.id==null?Colors.red:Colors.green,
                  ),
                  onTap: () async {
                    Employee empModified = await Navigator.push(context, MaterialPageRoute(builder: (context) => EmpForm(emp)));
                    empRepo.save(empModified);
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
}