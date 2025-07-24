import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../entity/Employee.dart';
import '../repo/EmpRepo.dart';

part 'AppDatabase.g.dart';

@Database(version: 1, entities: [Employee])
abstract class AppDatabase extends FloorDatabase
{
  EmpRepo get empRepo;
}