import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor_example/data/moor_database.dart';
import 'package:provider/provider.dart';

class NewTaskInput extends StatefulWidget{
  NewTaskInput({
    Key key,
  }) : super (key:key);

  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput>
{
  DateTime newtask;
  TextEditingController controller;

  @override
  void initState(){
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTextField(context),
          _buildDateButton(context),
        ],
      ),
    );

  }

  Expanded _buildTextField(context)
  {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Nombre de la tarea'),
        onSubmitted: (inputName) async {
          final database = Provider.of<AppDatabase>(context);
          final task = Task(
            name: inputName,
            dueDate: newtask,
          );
          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Te encuentras sin conexion, se guardara en registro local'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),));
            return database.insert(task);
          }
          else if (connectivityResult == ConnectivityResult.mobile) {
            // I am connected to a mobile network.
          }
          else if (connectivityResult == ConnectivityResult.wifi) {
            return Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Tienes internet'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),));
          }

          resetValueAfterSubmit();
        },
      ),
    );
  }

  void resetValueAfterSubmit()
  {
    setState(() {
      newtask = null;
      controller.clear();
    });
  }

  IconButton _buildDateButton(BuildContext context)
  {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed:() async{
        var now = new DateTime.now();
        newtask = await showDatePicker(context: context,initialDate: DateTime(now.year,now.month,now.day),firstDate: DateTime(now.year,now.month,now.day), lastDate: DateTime(now.year,now.month,now.day+15));
      },
    );
  }
}