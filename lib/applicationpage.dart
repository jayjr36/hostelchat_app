import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class HostelForm extends StatefulWidget {
  const HostelForm({super.key});

  @override
  HostelFormState createState() => HostelFormState();
}

class HostelFormState extends State<HostelForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final Random _random = Random();

  String _homeAddress = '';
  String _guardianName = '';
  String _guardianContact = '';
  String _relationship = '';
  String _duration = 'semester';
  int _roomNumber = 0;

  void _assignRoomNumber() {
    setState(() {
      _roomNumber = _random.nextInt(51);
    });
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _assignRoomNumber();
      _firestore.collection('bookings').add({
        'homeAddress': _homeAddress,
        'guardianName': _guardianName,
        'guardianContact': _guardianContact,
        'relationship': _relationship,
        'duration': _duration,
        'roomNumber': _roomNumber,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking Confirmed! Room Number: $_roomNumber')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm booking: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const  Color.fromARGB(236, 232, 190, 4),
        title: const Text('Hostel Application Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Home Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter home address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _homeAddress = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Guardian Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter guardian name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _guardianName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Guardian Contact'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter guardian contact number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _guardianContact = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Relationship with Guardian'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter relationship with the guardian';
                  }
                  return null;
                },
                onSaved: (value) {
                  _relationship = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Duration of Stay'),
                value: _duration,
                items: const [
                  DropdownMenuItem(value: 'semester', child: Text('Semester')),
                  DropdownMenuItem(value: 'year', child: Text('Year')),
                ],
                onChanged: (value) {
                  setState(() {
                    _duration = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text('Assigned Room Number: $_roomNumber'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const  Color.fromARGB(236, 232, 190, 4),
                ),
                child: const Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
