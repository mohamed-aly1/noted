import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noted/modules/archived.dart';
import 'package:noted/modules/done.dart';
import 'package:noted/modules/tasks.dart';
import 'package:noted/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  late Database database;
  bool isSheet = false;
  IconData actionIcon = Icons.edit;
  List<Widget> bodyScreen = [
    Tasks(),
    Done(),
    Archived(),
  ];
  List<Widget> titles = [
    Text('New Tasks'),
    Text('Done Tasks'),
    Text('Archived Tasks'),
  ];

  int currentIndex = 0;
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBar());
  }

  void createDB() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        print("DB et3mlt");
        await db.execute(
            "CREATE TABLE Tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT, status TEXT)");
        print("Table et3ml");
      },
      onOpen: (db) {
        getDataFromDB(db);
        print('DatabaseOpened');
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  insertDB({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(title,date,time,status)VALUES("$title","$date","$time","New")')
          .then((value) {
        print("$value inserted");
        emit(InsertDatabaseState());
        getDataFromDB(database);
      });
    });
  }

  void getDataFromDB(db) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetDatabaseLoadingState());
    db.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach(
        (element) {
          if (element['status'] == 'New') {
            newTasks.add(element);
          } else if (element['status'] == 'Done') {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        },
      );
      emit(GetDatabaseState());
    });
  }

  void changeBottomSheetState({
    required bool isshow,
    required IconData icon,
  }) {
    isSheet = isshow;
    actionIcon = icon;
    emit(ChangeBottomSheetState());
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE Tasks SET status = ?WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDB(database);
      emit(UpdateDatabaseState());
    });
  }

  void delete({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDataFromDB(database);
      emit(DeleteDatabaseState());
    });
  }
}
