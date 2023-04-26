import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noted/shared/components/compnents.dart';
import 'package:noted/shared/cubit/cubit.dart';
import 'package:noted/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertDB(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    )
                        .then((value) {
                      Navigator.pop(context);
                      cubit.changeBottomSheetState(
                          isshow: false, icon: Icons.add);
                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                          elevation: 25,
                          (context) => Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultTextField(
                                        prefixIcon: Icon(Icons.text_fields),
                                        controller: titleController,
                                        validateFun: (String? val) {
                                          if (val!.isEmpty) {
                                            return "Must not be empty";
                                          }
                                        },
                                        hintText: "Title",
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      defaultTextField(
                                        prefixIcon:
                                            const Icon(Icons.watch_later),
                                        keyboardType: TextInputType.datetime,
                                        controller: timeController,
                                        onTap: () async => showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) =>
                                                timeController.text = value!
                                                    .format(context)
                                                    .toString()),
                                        validateFun: (String? val) {
                                          if (val!.isEmpty) {
                                            return "Must not be empty";
                                          }
                                        },
                                        hintText: "Time",
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      defaultTextField(
                                        prefixIcon:
                                            const Icon(Icons.date_range),
                                        keyboardType: TextInputType.datetime,
                                        controller: dateController,
                                        onTap: () async => showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    "2030-12-31"))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                        }),
                                        validateFun: (String? val) {
                                          if (val!.isEmpty) {
                                            return "Must not be empty";
                                          }
                                        },
                                        hintText: "Date",
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isshow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isshow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.actionIcon),
              backgroundColor: Colors.teal,
            ),
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: cubit.titles[cubit.currentIndex],
            ),
            body: state is GetDatabaseLoadingState
                ? CircularProgressIndicator()
                : cubit.bodyScreen[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.teal,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (value) {
                cubit.changeIndex(value);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done_all_outlined), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived"),
              ],
            ),
          );
        },
      ),
    );
  }
}
