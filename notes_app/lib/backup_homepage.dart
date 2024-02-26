// ignore_for_file: prefer_const_declarations, sort_child_properties_last, prefer_const_constructors

import 'dart:convert';

import 'package:demo_app/screens/addpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  List items = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notes'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Visibility(
          visible: isLoading,
          child: Center(child: CircularProgressIndicator()),
          replacement: RefreshIndicator(
              onRefresh: fetchNotes,
              child: Visibility(
                  visible: items.isNotEmpty,
                  replacement: Center(child: Text('No notes in the list')),
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final item = items[index] as Map;
                      final id = item['_id'] as String;
                      return Card(
                          child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(item['title']),
                        subtitle: Text(item['description']),
                        trailing: PopupMenuButton(onSelected: (value) {
                          if (value == 'edit') {
                            //go to edit page
                            navigateToEditPage(item);
                          } else if (value == 'delete') {
                            //delete the notes
                            deleteById(id);
                          }
                        }, itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                                child: Text('Delete'), value: 'delete')
                          ];
                        }),
                      ));
                    },
                  )))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text('Add Notes'),
      ),
    );
  }

//routes to the Add Notes page.
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchNotes();
  }

//routes to edit the notes
  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(edit: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchNotes();
  }

  //To delete the notes
  Future<void> deleteById(String id) async {
    //delete the items
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    //Remove Item from the list
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage('Not able to Delete');
    }
  }

  //To get all data saved to server
  Future<void> fetchNotes() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } else {}
    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
