// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
        backgroundColor: const Color.fromARGB(236, 232, 190, 4),
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
            var updateWidget = Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(36, 105, 240, 175),
                  width: 2,
                ),
              ),
              child: ListTile(
                title: Text(updateData['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(updateData['content']),
                    if (updateData['imageUrl'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.network(updateData['imageUrl']),
                      ),
                  ],
                ),
              ),
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
              return const AddUpdateDialog();
            },
          );
        },
        tooltip: 'Add Update',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddUpdateDialog extends StatefulWidget {
  const AddUpdateDialog({super.key});

  @override
  AddUpdateDialogState createState() => AddUpdateDialogState();
}

class AddUpdateDialogState extends State<AddUpdateDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instanceFor(bucket:"hostelchat-1.appspot.com").ref().child('updates/$fileName');
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _addUpdate(BuildContext context) async {
    try {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }
      await _firestore.collection('updates').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'imageUrl': imageUrl,
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
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          if (_imageFile != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.file(
                _imageFile!,
                height: 150,
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
