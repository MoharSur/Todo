import 'package:flutter/material.dart';
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
               todos.remove(todos[index]);
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
               textController.text = '';
             });
            Navigator.of(context).pop();
          },
          child: const Text('Add'))
      ],
    ));
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
          )
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