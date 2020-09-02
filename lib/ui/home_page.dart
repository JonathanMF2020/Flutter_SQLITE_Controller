import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moor_example/data/moor_database.dart';
import 'package:moor_example/ui/widget/new_task_input_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("titulo"),
        ),
        body: Column(
          children: [
            Expanded(child: _buildTaskList(context)),
            NewTaskInput(),
          ],
        ),
    );
  }


  StreamBuilder<List<Task>> _buildTaskList(BuildContext)
  {
    final database = Provider.of<AppDatabase>(context);
    return StreamBuilder(
      stream: database.watchAll(),
      builder: (context, AsyncSnapshot<List<Task>> snapshot){
        final tasks = snapshot.data ?? List();
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_,index){
            final itemTask = tasks[index];
            return _buildLIst(itemTask,database);
          },
        );
      }
    );
  }

  Widget _buildLIst(Task item,AppDatabase database)
  {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleter(item),
        )
      ],
      child: CheckboxListTile(
        title: Text(item.name),
        subtitle: Text(item.dueDate?.toString() ?? 'Sin informacion'),
        value: item.completed,
        onChanged: (newValue){
          database.updater(item.copyWith(completed: newValue));
        },
      ),
    );
  }

}
