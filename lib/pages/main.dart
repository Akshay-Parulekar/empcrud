import 'package:empcrud/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../db/AppDatabase.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final db = await $FloorAppDatabase.databaseBuilder(
      join(dir.path, 'empdb.db')
  ).build();

  runApp(MyApp(db));
}

class MyApp extends StatelessWidget{
  AppDatabase db;

  MyApp(this.db);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(db));
  }
}