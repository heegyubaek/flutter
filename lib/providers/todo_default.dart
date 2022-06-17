import 'package:my_todo_app/models/todo.dart';

class TodoDefault {
  List<Todo> dummyTodos = [
    Todo(id: 1, title: 'flutter study', description: 'Read flutter book.'),
    Todo(id: 2, title: 'Exercise', description: 'Go to gym.'),
    Todo(id: 3, title: '공원 가기', description: '집 근저 공원가서 산책'),
    Todo(id: 4, title: '밥먹기', description: '저녁 약속'),
  ];

  List<Todo> getTodos() {
    return dummyTodos;
  }

  Todo getTodo(int id) {
    return dummyTodos[id];
  }

  Todo addTodo(Todo todo) {
    Todo newTodo = Todo(
      id: dummyTodos.length + 1,
      title: todo.title,
      description: todo.description);
    dummyTodos.add(newTodo);
    return newTodo;
  }

  void deleteTodo(int id) {
    for (int i = 0; i < dummyTodos.length; i++) {
      if(dummyTodos[i].id == id) {
        dummyTodos.removeAt(i);
      }
    }
  }

  void updateTodo(Todo todo) {
    for (int i = 0; i < dummyTodos.length; i++) {
      if(dummyTodos[i].id == todo.id) {
        dummyTodos[i] = todo;
      }
    }
  }
}
