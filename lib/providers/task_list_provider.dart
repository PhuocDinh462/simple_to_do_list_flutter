import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/models/task.dart';

List<Map<String, dynamic>> taskListToMap(List<Task> tasks) {
  return tasks.map((task) => task.toMap()).toList();
}

Future<void> saveTasks(List<Task> tasks) async {
  final prefs = await SharedPreferences.getInstance();
  final tasksMapList = taskListToMap(tasks);
  await prefs.setString('taskList', jsonEncode(tasksMapList));
}

Future<List<Task>> loadTasks() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('taskList');

  if (jsonString != null) {
    final tasksMapList = jsonDecode(jsonString).cast<Map<String, dynamic>>();
    return tasksMapList.map<Task>((taskMap) => Task.fromMap(taskMap)).toList();
  } else {
    return [];
  }
}

class TaskListProvider with ChangeNotifier {
  List<Task> _taskList = [];

  List<Task> get getTaskList => _taskList;

  TaskListProvider() {
    // Load tasks
    loadTasks().then((loadedTasks) async {
      _taskList = loadedTasks;
      notifyListeners();
    });
  }

  Future<void> addTask(Task task) async {
    _taskList.add(task);
    notifyListeners();
    await saveTasks(_taskList);
  }

  Future<void> deleteTask(Task task) async {
    _taskList.remove(task);
    notifyListeners();
    await saveTasks(_taskList);
  }

  Future<void> deleteAllDoneTasks() async {
    _taskList.removeWhere((element) => element.status);
    notifyListeners();
    await saveTasks(_taskList);
  }

  Future<void> deleteAll() async {
    _taskList.clear();
    notifyListeners();
    await saveTasks(_taskList);
  }

  Future<void> updateTask({
    String? id,
    String? content,
    DateTime? due,
    bool? status,
  }) async {
    if (id == null) return;

    int index = _taskList.indexWhere((task) => task.id == id);
    if (index == -1) return;

    Task taskToUpdate = _taskList[index];

    if (content != null) {
      taskToUpdate.content = content;
    }

    if (due != null) {
      taskToUpdate.due = due;
    }

    if (status != null) {
      taskToUpdate.status = status;
    }

    notifyListeners();
    await saveTasks(_taskList);
  }
}
