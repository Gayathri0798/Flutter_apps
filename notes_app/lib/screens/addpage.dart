// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  final Map? edit;
  const AddPage({
    super.key,
    this.edit,
  });

  @override
  State<AddPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final edit = widget.edit;
    if (edit != null) {
      isEdit = true;
      //Prefill data in edit page
      final title = edit['title'];
      final description = edit['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(isEdit ? 'Edit Notes' : 'Text to add Notes'),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Description'),
              keyboardType: TextInputType.multiline,
              minLines: 10,
              maxLines: 20,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: isEdit ? updateData : saveData,
                child: Text(isEdit ? 'Update' : 'Save'))
          ],
        ));
  }

//form handling
  Future<void> saveData() async {
    //Get data from server
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    //Save data to the server(adding http request)
    // ignore: prefer_const_declarations
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //show status that is success or not
    print(response.statusCode);
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      print('Notes saved successfully');
      showSuccessMessage('Notes saved successfully');
    } else {
      showErrorMessage('Error in creation');
    }
  }

  //Edit and update data
  Future<void> updateData() async {
    final edit = widget.edit;
    if (edit == null) {
      print('The data you are trying to update not exist');
      return;
    }
    final id = edit['_id'];
    //final isCompleted = edit['is_completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    //show status that is success or not
    print(response.statusCode);
    if (response.statusCode == 200) {
      titleController.text = '';
      descriptionController.text = '';
      print('Notes saved successfully');
      showSuccessMessage('Updated successfully');
    } else {
      showErrorMessage('Error in updating');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
