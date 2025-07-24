import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


String idClient = Uuid().v4();

void showSnackbar(BuildContext context, String content)
{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}