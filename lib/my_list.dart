import 'package:flutter/material.dart';

class MyList extends StatefulWidget {
  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  List <String> tasks = [
    'Clean Architecture',
    'Problem Solving',
    'UI figma task',
    'widget catalog',
    'Finish OO thought process'
  ];
  String? _deletedTask;
  int? _deletedTaskIndex;
  @override
  Widget build(BuildContext context) {
	return Scaffold(
    appBar: AppBar(
      title: Text('My List'),
      
    ),

    body: ReorderableListView.builder(
      itemCount: tasks.length, 
       onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final task = tasks.removeAt(oldIndex);
            tasks.insert(newIndex, task);
          });
        },
        itemBuilder: (context, i) {
          return Dismissible(
            key: ValueKey(tasks[i]),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await _showConfirmDialog(context, tasks[i]);
            },
             onDismissed: (direction) {
              setState(() {
                _deletedTask = tasks[i];
                _deletedTaskIndex = i;
                tasks.removeAt(i);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Task deleted"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      if (_deletedTask != null && _deletedTaskIndex != null) {
                        setState(() {
                          tasks.insert(_deletedTaskIndex!, _deletedTask!);
                        });
                      }
                    },
                  ),
                ),
              );
            },
            child: ListTile(
              key: ValueKey(tasks[i]),
              title: Text(tasks[i]),
              trailing: const Icon(Icons.drag_handle),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String task) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '$task'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}