import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/todoapp/models/todo.dart';

// import 'package:my_todo_app/todoapp/providers/todo_default.dart';
import 'dart:async';
import 'package:my_todo_app/todoapp/controller/circular_progress_control.dart';
import 'package:my_todo_app/todoapp/providers/todo_firestore.dart';

import 'package:my_todo_app/todoapp/providers/todo_sqlite.dart';
import 'package:reorderables/reorderables.dart';

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Todo> todos = [];
  TodoFirebase todoFirebase = TodoFirebase();

  // TodoDefault todoDefault = TodoDefault();
  TodoSqlite todoSqlite = TodoSqlite();
  bool isLoading = true;

  Future initDb() async {
    await todoSqlite.initDb().then((value) async {
      todos = await todoSqlite.getTodos();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      //Firebase의 firestore를 이용한 db연동
      todoFirebase.initDb();
    });
    //실제로 외부 영역에서 데이터를 불러올 때에는 시간이 소요되기 때문에,
    //이를 구현하기 위해 Timer를 설정
    // Timer(Duration(seconds: 3), () {
    //   // todos = todoDefault.getTodos();
    //   initDb().then((_) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
        stream: todoFirebase.todoStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: CircularProgressWidget()),
            );
          } else {
            todos = todoFirebase.getTodos(snapshot);
            return Scaffold(
              appBar: AppBar(
                title: Text('할 일 목록 앱'),
                actions: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book),
                          Text('뉴스'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  child: Text('+', style: TextStyle(fontSize: 25)),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String title = '';
                          String description = '';
                          return AlertDialog(
                            title: Text('할 일 추가하기'),
                            content: Container(
                              height: 200,
                              child: Column(
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      title = value;
                                    },
                                    decoration:
                                        InputDecoration(labelText: '제목'),
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      description = value;
                                    },
                                    decoration:
                                        InputDecoration(labelText: '설명'),
                                  )
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  child: Text('추가'),
                                  onPressed: () {
                                    Todo newTodo = Todo(
                                      title: title, description: description
                                    );
                                    todoFirebase.todosReference
                                    .add(newTodo.toMap()).then((value) { Navigator.of(context).pop();});
                                  },
                                  // onPressed: () async {
                                  //   await todoSqlite.addTodo(
                                  //     Todo(
                                  //         title: title,
                                  //         description: description),
                                  //   );
                                  //
                                  //   List<Todo> newTodos =
                                  //       await todoSqlite.getTodos();
                                  //   setState(() {
                                  //     print("[UI] ADD");
                                  //     todos = newTodos;
                                  //     // todoDefault.addTodo(
                                  //     //   Todo(title: title, description: description),
                                  //     // );
                                  //   });
                                  //   Navigator.of(context).pop();
                                  // }
                                  ),
                              TextButton(
                                  child: Text('취소'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          );
                        });
                  }),
              body: ReorderableListView.builder(
                      onReorder: (oldIndex, newIndex) => setState(() {
                            final index =
                                newIndex > oldIndex ? newIndex - 1 : newIndex;

                            final todo = todos.removeAt(oldIndex);
                            todos.insert(index, todo);
                          }),
                      itemBuilder: (context, index) {
                        return ListTile(
                          key: ValueKey(index),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          title: Text(
                            todos[index].title,
                            // style: TextStyle(
                            //   decoration: TextDecoration.lineThrough,
                            //   decorationThickness: 3.0,
                            //   decorationColor: Colors.red,
                            // )
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    backgroundColor: Colors.white,
                                    elevation: 50.0,
                                    title: Text('할 일'),
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child:
                                            Text('제목 : ' + todos[index].title),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                            '설명 : ' + todos[index].description),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            //TextButton 만 사용하면 완료 text가 center로 맞춰지기에
                                            //SizedBox를 추가하여 text를 우측으로 배치
                                            SizedBox(width: 200),
                                            TextButton(
                                              child: Text('완료',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              onPressed: () async {
                                                setState(() {
                                                  print("[UI] Complete");
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          trailing: Container(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: InkWell(
                                    child: Icon(Icons.edit),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String title = todos[index].title;
                                            String description =
                                                todos[index].description;
                                            return AlertDialog(
                                              title: Text('할 일 수정하기'),
                                              content: Container(
                                                height: 200,
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      onChanged: (value) {
                                                        title = value;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            todos[index].title,
                                                      ),
                                                    ),
                                                    TextField(
                                                      onChanged: (value) {
                                                        description = value;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: todos[index]
                                                            .description,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    child: Text('수정'),
                                                    onPressed: () {
                                                      Todo newTodo = Todo(
                                                        title: title,
                                                        description: description,
                                                        reference:
                                                          todos[index].reference,
                                                      );
                                                      todoFirebase.updateTodo(newTodo)
                                                      .then((value) => Navigator.of(context).pop());
                                                    },
                                                    // onPressed: () async {
                                                    //   Todo newTodo = Todo(
                                                    //     id: todos[index].id,
                                                    //     title: title,
                                                    //     description:
                                                    //         description,
                                                    //   );
                                                    //   await todoSqlite
                                                    //       .updateTodo(newTodo);
                                                    //   List<Todo> newTodos =
                                                    //       await todoSqlite
                                                    //           .getTodos();
                                                    //   setState(() {
                                                    //     todos = newTodos;
                                                    //     // todoDefault.updateTodo(newTodo);
                                                    //   });
                                                    //   Navigator.of(context)
                                                    //       .pop();
                                                    // }
                                                    ),
                                                TextButton(
                                                    child: Text('취소'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: InkWell(
                                    child: Icon(Icons.delete),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('할 일 삭제하기'),
                                              content: Container(
                                                child: Text('삭제하시겠습니까?'),
                                              ),
                                              actions: [
                                                TextButton(
                                                    child: Text('삭제'),
                                                    onPressed: () {
                                                      todoFirebase.deleteTodo(todos[index])
                                                          .then((value) => Navigator.of(context).pop());
                                                    },
                                                    // onPressed: () async {
                                                    //   await todoSqlite
                                                    //       .deleteTodo(
                                                    //           todos[index].id ??
                                                    //               0);
                                                    //   List<Todo> newTodos =
                                                    //       await todoSqlite
                                                    //           .getTodos();
                                                    //   setState(() {
                                                    //     todos = newTodos;
                                                    //     // todoDefault.deleteTodo(
                                                    //     //     todos[index].id ?? 0);
                                                    //   });
                                                    //   Navigator.of(context)
                                                    //       .pop();
                                                    // }
                                                    ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('취소'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      // separatorBuilder: (context, index) {
                      //   return Divider();
                      // },
                      itemCount: todos.length),
            );
          }
        });
  }
}
