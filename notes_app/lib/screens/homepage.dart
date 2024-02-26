// ignore_for_file: prefer_const_declarations, sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously

import 'package:demo_app/screens/addpage.dart';
import 'package:demo_app/services/notes_service.dart';
import 'package:demo_app/utils/snackbar_helper.dart';
import 'package:demo_app/widget/notes_card.dart';
import 'package:flutter/material.dart';

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
                      return NotesCard(
                          index: index,
                          item: item,
                          navigateEdit: navigateToEditPage,
                          deleteById: deleteById);
                    },
                  )))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text('Add Notes'),
        backgroundColor: Colors.amberAccent,
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
    final isSuccess = await NotesService.deleteById(id);
    //Remove Item from the list
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage(context, message: 'Not able to Delete');
    }
  }

  //To get all data saved to server
  Future<void> fetchNotes() async {
    final response = await NotesService.fetchNotes();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: 'Error in fetching data');
    }
    setState(() {
      isLoading = false;
    });
  }
}
