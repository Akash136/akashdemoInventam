import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:inventam_flutter_task/Models/taskModel.dart';
import 'package:inventam_flutter_task/utils/constants.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'Screen/loginScreen.dart';
import 'Widgets/mytextField.dart';
import 'Widgets/textButton.dart';

User loggedinUser;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  TaskModel _taskModel = TaskModel();
  TextEditingController taskNameCon = TextEditingController();
  TextEditingController taskDescCon = TextEditingController();
  TextEditingController tasStartDateCon = TextEditingController();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  void initState() {
    super.initState();
    _taskModel = Provider.of<TaskModel>(context, listen: false);
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: loggedinUser.email.toString());
    } catch (e) {
      print(e);
    }
  }

  Widget _search() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: CupertinoSearchTextField(
        placeholder: "Search by Product or Code",
        onChanged: (String value) {
          print('The text has changed to: $value');
        },
        onSubmitted: (String value) {
          List<Task> taskList = [];
          taskList = _taskModel.myList;

          var estateSelected =
              _taskModel.myList.firstWhere((val) => val == value.toString());
          print(estateSelected.toJson.toString());
        },
      ),
    );
  }

  Widget taskList() {
    return Consumer<TaskModel>(
      builder: (context, value, child) {
        return LazyLoadScrollView(
          onEndOfPage: () {
            Map<String, dynamic> param = {
              "id": setting().getCurrantDateTime().toString(),
              "name": "Pagination ",
              "sdate": "-",
              "description": "Pagination Lazzy Loding  Dummy Data",
            };
            _taskModel.add(param);
          },
          child: LiquidPullToRefresh(
            color: kScafolfColor,
            backgroundColor: kPrimaryColor,
            key: _refreshIndicatorKey, // key if you want to add
            onRefresh: () async {
              Map<String, dynamic> param = {
                "id": setting().getCurrantDateTime().toString(),
                "name": "Pull To Refresh",
                "sdate": "-",
                "description": "Pull To refresh Dummy Data",
              };
              _taskModel.add(param);
            },
            showChildOpacityTransition: false,
            child: ListView.builder(
              itemCount: value.myList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(value.myList[index].name),
                  subtitle: Text(value.myList[index].description),
                  leading: Text(value.myList[index].sdate),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _taskModel.delete(value.myList[index]);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void updateDilog() {
    Get.dialog(StatefulBuilder(
      builder: (context, setState) {
        return Container(
          color: Colors.white,
          margin: EdgeInsets.only(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).size.width / 2,
              bottom: MediaQuery.of(context).size.width / 2),
          child: Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Update Password for Send Email"),
                Divider(),
                Text(loggedinUser.email.toString()),
                new FlatButton(
                  color: kPrimaryColor,
                  child: new Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    resetPassword();
                    Get.back();
                    setting().tostMessage(
                        "Reset Password Mail Send to Your Email. Please Check Your Mail Box");
                  },
                )
              ],
            ),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          "Welcome User \n" + loggedinUser.email.toString() ?? "",
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                updateDilog();
              }),
          IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () {
                _auth.signOut();
                _taskModel.removeAllTask();
                Get.offAll(SignInPage());
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addTask();
        },
        label: const Text('Add Task'),
        icon: const Icon(
          Icons.thumb_up,
        ),
        backgroundColor: kPrimaryLightColor,
      ),
      body: Column(
        children: [_search(), Expanded(child: taskList())],
      ),
    );
  }

  void CleanController() {
    taskNameCon.text = "";
    taskDescCon.text = "";
    tasStartDateCon.text = "";
  }

  void addTask() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add New Task",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              CupertinoButton(
                                child: Text("Close"),
                                onPressed: () {
                                  CleanController();
                                  Get.back();
                                },
                              )
                            ],
                          ),
                          MyTextField(
                            suffix: Icons.text_fields,
                            prefix: Icons.person,
                            inputController: taskNameCon,
                            hintText: 'Task Name',
                            inputType: TextInputType.text,
                          ),
                          MyTextField(
                            suffix: Icons.text_fields,
                            prefix: Icons.location_city,
                            inputController: taskDescCon,
                            hintText: 'Description',
                            inputType: TextInputType.text,
                            maxLine: 3,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () async {
                                      var date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));
                                      tasStartDateCon.text =
                                          date.toString().substring(0, 10);
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Select Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Text(tasStartDateCon.text.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MyTextButton(
                            buttonName: 'Save',
                            onTap: () {
                              if (taskNameCon.text.isEmpty) {
                                setting().tostMessage(txtTaskName);
                              } else if (taskDescCon.text.isEmpty) {
                                setting().tostMessage(txtTaskDescription);
                              } else if (tasStartDateCon.text.isEmpty) {
                                setting().tostMessage(txtTaskStartDate);
                              } else {
                                Map<String, dynamic> param = {
                                  "id":
                                      setting().getCurrantDateTime().toString(),
                                  "name": taskNameCon.text.toString(),
                                  "sdate": tasStartDateCon.text.toString(),
                                  "description": taskDescCon.text.toString(),
                                };
                                _taskModel.add(param);
                                CleanController();
                                Get.back();
                              }
                            },
                            bgColor: kPrimaryColor,
                            textColor: Colors.white,
                          ),
                        ]),
                  ),
                ),
              );
            },
          );
        });
  }
}
