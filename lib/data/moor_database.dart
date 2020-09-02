
import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Tasks extends Table{
  //Atributos
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name  => text()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
  //Definicion primary key
  @override
  Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [Tasks])
class AppDatabase extends _$AppDatabase{
  AppDatabase() :
        super(FlutterQueryExecutor.inDatabaseFolder(
          path: "db.sqlite",logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<List<Task>> getAll() => select(tasks).get();
  Stream<List<Task>> watchAll() => select(tasks).watch();
  Future insert(Task task) => into(tasks).insert(task);
  Future updater(Task task) => update(tasks).replace(task);
  Future deleter(Task task) => delete(tasks).delete(task);

}