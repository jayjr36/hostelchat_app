// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatesPage extends StatefulWidget {
  const UpdatesPage({super.key});

  @override
  UpdatesPageState createState() => UpdatesPageState();
}

class UpdatesPageState extends State<UpdatesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updates'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('updates').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No updates to display'),
            );
          }
          var updates = snapshot.data?.docs;
          List<Widget> updateWidgets = [];
          for (var update in updates!) {
            var updateData = update.data();
            var updateWidget = ListTile(
              title: Text(updateData['title']),
              subtitle: Text(updateData['content']),
            );
            updateWidgets.add(updateWidget);
          }
          return ListView(
            children: updateWidgets,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddUpdateDialog();
            },
          );
        },
        tooltip: 'Add Update',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddUpdateDialog extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AddUpdateDialog({super.key});

  void _addUpdate(BuildContext context) async {
    try {
      await _firestore.collection('updates').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'timestamp': DateTime.now(),
      });
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to add update. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Update'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _addUpdate(context),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
