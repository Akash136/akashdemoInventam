import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inventam_flutter_task/utils/constants.dart';
import 'package:localstorage/localstorage.dart';

class TaskModel with ChangeNotifier {
  TaskModel() {
    getFromLocal();
  }

  List<Task> myList = [];

  void add(Map<String, dynamic> singledata) {
    myList.add(Task.fromJson(singledata));
    saveToLocal();
    notifyListeners();
  }

  void setList(List<Task> list) {
    myList = list;
  }

  List<Task> getList() {
    return myList;
  }

  void removeCategory() {
    myList.clear();
  }

  void removeAllTask() {
    myList.clear();
    final LocalStorage storage = LocalStorage("fstore");
    storage.clear();
  }

  void delete(Task task) {
    try {
      int index = myList.indexWhere((element) => element == task);
      myList.removeAt(index);
      saveToLocal();
      notifyListeners();
    } catch (err) {
      debugPrint(err);
    }
  }

  Future<void> saveToLocal() async {
    try {
      final LocalStorage storage = LocalStorage("fstore");
      final ready = await storage.ready;
      if (ready) {
        List<Task> temp = [];
        myList.forEach((element) {
          temp.add(element);
        });
        await storage.setItem(kLocalKey["task"], temp);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> getFromLocal() async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        final data = storage.getItem(kLocalKey["task"]);
        if (data != null) {
          data.forEach((element) {
            Task tasks = Task.fromJson(element);
            myList.add(tasks);
          });
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Exception: ' + e.toString());
      debugPrint('Stacktrace: ' + stacktrace.toString());
    }
  }
}

class Task {
  String id;
  String name;
  String description;
  String sdate;

  Task.fromJson(Map<String, dynamic> parseJason) {
    id = parseJason['id'].toString();
    name = parseJason['name'].toString();
    description = parseJason['description'].toString();
    sdate = parseJason['sdate'].toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name.toString(),
      'sdate': sdate.toString(),
      'description': description.toString(),
    };
  }
}
