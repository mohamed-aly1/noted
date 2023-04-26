import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noted/shared/components/compnents.dart';
import 'package:noted/shared/cubit/cubit.dart';
import 'package:noted/shared/cubit/states.dart';

class Tasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        var tasks = cubit.newTasks;
        return TaskList(tasks: tasks);
      },
    );
  }
}
