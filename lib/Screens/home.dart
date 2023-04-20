import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/Model/todo.dart';
import 'package:todo_app/Screens/login.dart';
import 'package:todo_app/Widgets/todo_item.dart';
import 'package:todo_app/constants/Colors.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/todo_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // FirebaseFirestore db = FirebaseFirestore.instance;
  final TodoService _todoService = TodoService();
  final todosList = ToDo.todoList();
  final _todoController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  AuthService authService = AuthService();

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // db.collection("todo").snapshots().listen((snapshot) {});
    // final CollectionReference todosRef =
    //     FirebaseFirestore.instance.collection('todo');

    return StreamBuilder<QuerySnapshot>(
      // stream: db.collection("todo").snapshots(),
      stream: _todoService.todoStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        var docs = snapshot.data?.docs ?? [];

        return Scaffold(
          drawer: Drawer(
            child: Column(children: [
              Container(
                height: 230,
                width: double.infinity,
                color: tdBlue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pickImage();
                      },
                      child: image == null
                          ? CircleAvatar(
                              radius: 50,
                              child: Image.asset(
                                'lib/assets/images/avatar2.png',
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(
                                image!,
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      user!.email!.replaceAll('@gmail.com', '').toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "${user!.email}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(left: 20, bottom: 0),
                  height: 300,
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                            onPressed: (() {}),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 24,
                            ),
                            label: const Text(
                              "Change Username",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            )),
                        TextButton.icon(
                            onPressed: (() {}),
                            icon: const Icon(
                              Icons.privacy_tip,
                              color: Colors.black,
                              size: 24,
                            ),
                            label: const Text(
                              "Privacy",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            )),
                        TextButton.icon(
                            onPressed: (() {}),
                            icon: const Icon(
                              Icons.help,
                              color: Colors.black,
                              size: 24,
                            ),
                            label: const Text(
                              "Support",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            )),
                        TextButton.icon(
                            onPressed: (() {}),
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.black,
                              size: 24,
                            ),
                            label: const Text(
                              "Settings",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            )),
                        const Divider(
                          thickness: 2,
                        ),
                        GestureDetector(
                          // onTap: () async {
                          //   await authService.signout();
                          //   Navigator.of(context).pushAndRemoveUntil(
                          //       MaterialPageRoute(
                          //           builder: (context) => const LoginScreen()),
                          //       (route) => false);
                          // },
                          child: TextButton.icon(
                              onPressed: (() {
                                showDialog(
                                    context: context,
                                    builder: ((context) => AlertDialog(
                                          title: const Text("Logout"),
                                          content: const Text(
                                              "Are you sure want to logout?"),
                                          actions: [
                                            TextButton(
                                                onPressed: (() {
                                                  Navigator.of(context).pop();
                                                }),
                                                child: const Text("No")),
                                            TextButton(
                                                onPressed: (() async {
                                                  await authService.signout();
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const LoginScreen()),
                                                          (route) => false);
                                                }),
                                                child: const Text("Yes"))
                                          ],
                                        )));
                              }),
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.black,
                                size: 24,
                              ),
                              label: const Text(
                                "Log out",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              )),
                        )
                      ]))
            ]),
          ),
          key: _key,
          resizeToAvoidBottomInset: false,
          backgroundColor: tdBGcolor,
          appBar: _buldAppBar(),
          body: Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                color: tdBlue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pickImage();
                      },
                      child: image == null
                          ? CircleAvatar(
                              radius: 50,
                              child: Image.asset(
                                'lib/assets/images/avatar2.png',
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(
                                image!,
                              ),
                            ),
                    ),
                    Text(
                      "Hi, ${user!.email!.replaceAll('@gmail.com', '').toUpperCase()}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    height: 450,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: double.infinity,
                          color: tdBGcolor,
                          child: Center(
                            child: Text(
                              "To-Do List ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700]),
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            String id = docs[i].id;
                            // DocumentReference docRef = todosRef.doc(docs[i].id);
                            Map<String, dynamic> data =
                                docs[i].data() as Map<String, dynamic>;
                            return ToDoItem(
                              onDeleteItem: (value) {
                                showDialog(
                                    context: context,
                                    builder: ((context) => AlertDialog(
                                          title: const Text("Are you sure ?"),
                                          content: const Text(
                                              "This todo will delete permenantly"),
                                          actions: [
                                            TextButton(
                                                onPressed: (() {
                                                  Navigator.of(context).pop();
                                                }),
                                                child: const Text("Cancel")),
                                            TextButton(
                                                onPressed: (() {
                                                  // docRef.delete();
                                                  _todoService.deleteTodo(id);
                                                  Navigator.of(context).pop();
                                                }),
                                                child: const Text("Delete"))
                                          ],
                                        )));
                              },
                              onToDoChange: (isDone) {
                                // docRef.update({"isDone": value});
                                _todoService.updateTodo(id, isDone!);
                              },
                              todo: ToDo(
                                id: '1',
                                title: data['title'],
                                isDone: data['isDone'],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: FloatingActionButton(
                      backgroundColor: tdBlue,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            height: 240,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 350,
                                  child: TextField(
                                    controller: _todoController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    String title = _todoController.text;
                                    // todosRef.add({
                                    //   'title': title,
                                    //   'isDone': false,
                                    // });
                                    _todoService.addTodo(title);
                                    Navigator.of(context).pop();
                                    _todoController.clear();
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        size: 36,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _buldAppBar() {
    return AppBar(
        backgroundColor: tdBGcolor,
        elevation: 4,
        leading: IconButton(
          onPressed: (() {
            _key.currentState?.openDrawer();
          }),
          icon: const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
        ));
  }
}
