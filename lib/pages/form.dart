import 'package:empcrud/entity/Employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmpForm extends StatelessWidget
{
  Employee? emp;
  var tName = TextEditingController();
  var tSalary = TextEditingController();


  EmpForm(Employee? emp)
  {
    if(emp != null)
    {
      this.emp = emp;
      tName.text = emp.name;
      tSalary.text = emp.salary.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employees"), backgroundColor: Colors.lightBlue, foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: tName,
              decoration: InputDecoration(
                hintText: "Enter Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
              )),
            SizedBox(height: 10,),

            TextField(
                controller: tSalary,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    hintText: "Enter Salary",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                )),
            SizedBox(height: 10,),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                Employee empModified = Employee(emp?.idTemp, emp?.id, tName.text, int.parse(tSalary.text), null, 0);
                return Navigator.pop(context, empModified);
              }, child: Text("SAVE"), style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),),
            )
          ],
        ),
      ),
    );
  }

}