import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor_example/data/moor_database.dart';
import 'package:provider/provider.dart';

import 'ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) => AppDatabase(),
      child: MaterialApp(
          title: 'Prueba moor',
          home: HomePage()
      ),
    );
  }
}