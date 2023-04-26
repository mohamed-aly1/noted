import 'package:flutter/material.dart';
import 'package:noted/shared/cubit/cubit.dart';

Widget defaultTextField({
  required TextEditingController controller,
  required String? Function(String?)? validateFun,
  TextInputType keyboardType = TextInputType.text,
  VoidCallback? onSubmitFun,
  VoidCallback? onChangedFun,
  required String hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  double width = 300,
  bool obscureText = false,
  VoidCallback? onTap,
}) =>
    Container(
      width: width,
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        validator: validateFun,
        onTap: onTap,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.grey[200],
          hintText: hintText,
          prefixIcon: prefixIcon,
          hintStyle: TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        style: TextStyle(color: Colors.black),
      ),
    );

Widget taskItem({required Map tasksList, context}) => Dismissible(
      key: Key('${tasksList['id']}'),
      onDismissed: (direction) {
        AppCubit.get(context).delete(id: tasksList['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              child: Text(
                '${tasksList['time']}',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tasksList['title']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text('${tasksList['date']}',
                      style: TextStyle(fontSize: 15, color: Colors.teal[300])),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'Done', id: tasksList['id']);
                },
                icon: Icon(
                  Icons.checklist_rtl_rounded,
                  color: Colors.green[600],
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'Archived', id: tasksList['id']);
                },
                icon: Icon(
                  Icons.archive_outlined,
                  color: Colors.grey[600],
                )),
          ],
        ),
      ),
    );

Widget TaskList({required List<Map> tasks}) {
  return tasks.isEmpty
      ? Center(
          child: Text('No Tasks'),
        )
      : ListView.separated(
          itemBuilder: (context, index) =>
              taskItem(tasksList: tasks[index], context: context),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: Divider(
                  height: 2,
                  thickness: 1.5,
                ),
              ),
          itemCount: tasks.length);
}
