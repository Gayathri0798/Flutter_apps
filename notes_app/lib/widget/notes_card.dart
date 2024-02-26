import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class NotesCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;
  const NotesCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
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
          navigateEdit(item);
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
          PopupMenuItem(child: Text('Delete'), value: 'delete')
        ];
      }),
    ));
  }
}
