import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_model.dart';
void main(){
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Todo() ,
  ));
}

class Todo extends StatefulWidget {
  
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  
  List<TodoModel> todos = [];
  TextEditingController textController = TextEditingController();  
  
  Future<List<String>?> getTodos() async {
     SharedPreferences prefs =  await SharedPreferences.getInstance();
     List<String>? todos = prefs.getStringList('todos');
     if(todos == null){
       prefs.setStringList('todos', []);
     }
     return todos;
  }
  void showDialogIsTodoCompleted(int index){
    showDialog(
     context: context,
     builder: (_) => AlertDialog(
      title: const Text('Note'),
      content: Text('Have u Completed ${todos[index].text}?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('No')),

          TextButton(
          onPressed: () {
             setState(() {
               // Remove the Todo
               todos.remove(todos[index]);
               updatePrefs();
             });
            Navigator.pop(context, true);
          },
          child: const Text('Yes'))
      ],
    ));
  }
  void showDialogToInputTodo(){
    showDialog(
     context: context,
     builder: (_) => AlertDialog(
      title: const Text('Input Todo'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),  
          hintText: 'Write a Todo'  
        ),
      ),
      actions: [
          TextButton(
           onPressed: () {
             Navigator.of(context).pop();
           },
           child: const Text('Cancel')
          ),
          TextButton(
          onPressed: () {
             setState(() {
                // Adds a Todo
                todos.add(TodoModel(textController.text));
                // Update The Saved Data
                updatePrefs();
                textController.text = '';
             });
            Navigator.of(context).pop();
          },
          child: const Text('Add'))
      ],
    ));
  }
  void updatePrefs(){
    List<String> todosTexts = [];
        for(int i = 0; i < todos.length; i++){
          todosTexts.add(todos[i].text);
        }
        SharedPreferences.getInstance().then((prefs){
        prefs.setStringList('todos', todosTexts);
      });  
  }
  @override
  void initState() {
    super.initState();
    getTodos().then((values){
      if(values != null){
       for(int i = 0; i < values.length; i++){
          todos.add(TodoModel(values[i]));
       }
       setState(() { });
     }
    });
  }
  @override
  Widget build(BuildContext context) {
    if(todos.isEmpty){
      return Scaffold(
        appBar : AppBar(
        title: const Text("Todo App"),
      ),
       body: Center(
         child: Text(
           "No Todos Added ...",
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialogToInputTodo();
           
          },
          child: const Icon(Icons.add),
      ),
      );
    }
    return Scaffold(
      appBar : AppBar(
        title: const Text("Todo App"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 4.0,
        ),
        child: ListView.builder(
              itemCount: todos.length,
              itemBuilder:(context, index) {
                // returns a widget for Todo Data
                return GestureDetector(
                   onLongPress: () {
                     showDialogIsTodoCompleted(index);
                   },
                   child: Card(
                       child: ListTile(
                       title: Text(todos[index].text),
                     ),
                   ),  
                 ); 
            }, 
           ), 
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogToInputTodo();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}