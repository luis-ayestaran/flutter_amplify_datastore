import 'dart:async';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_datastore/amplifyconfiguration.dart';
import 'package:flutter_amplify_datastore/models/ModelProvider.dart';
import 'package:flutter_amplify_datastore/models/Todo.dart';
import 'package:flutter_amplify_datastore/screens/add_todo_screen.dart';
import 'package:flutter_amplify_datastore/widgets/todo_list.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // subscription of Todo QuerySnapshots - to be initialized at a runtime
  late StreamSubscription<QuerySnapshot<Todo>> _subscription;

  // Loading ui state - initially set to a loading state
  bool _isLoading = true;

  // List of todos - Initially empty
  List<Todo> _todos = [];

  // Amplify plugins
  final _dataStorePlugin = AmplifyDataStore( modelProvider: ModelProvider.instance );

  @override
  void initState() {
    //kick off app initialization
    _initializeApp();

    super.initState();
  }

  @override
  void dispose() {
    // to be filled in a later step
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // configure Amplify
    await _configureAmplify();

    // Query and Observe updates to Todo models. DataStore.observeQuery() will
    // emit an initial QuerySnapshot with a list of Todo models in the local store,
    // and will emit subsequent snapshots as updates are made
    //
    // each time a snapshot is received, the following will happen:
    // _isLoading is set to false if it is not already false
    // _todos is set to the value in the latest snapshot
    _subscription = Amplify.DataStore.observeQuery( Todo.classType ).listen((QuerySnapshot<Todo> snapshot) {
      setState(() {
        if( _isLoading ) _isLoading = false;
        _todos = snapshot.items;
      });
    });

    // after configuring Amplify, update loading UI style to loaded state
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _configureAmplify() async {
    try {
      // add Amplify plugins
      await Amplify.addPlugins([
        _dataStorePlugin,
      ]);

      // configure Amplify
      //
      // note that Amplify cannot be configured more than once!
      await Amplify.configure( amplifyconfig );
    } catch( e ) {
      // error handling can be improved for sure!
      // but this will be sufficient for the purposes of this tutorial
      print( 'Ocurrió un error al configurar Amplify: $e' );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi lista de tareas'),
      ),
      //body: Center(child: CircularProgressIndicator()),
      body: _isLoading  ? Center(child: CircularProgressIndicator())
                        : TodoList(todos: _todos),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
        },
        tooltip: 'Nueva Tarea',
        label: Row(
          children: [Icon(Icons.add), Text('Nueva Tarea')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}