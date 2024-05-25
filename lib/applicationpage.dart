import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelchat/bookings.dart';
import 'package:loading_overlay/loading_overlay.dart';

class HostelForm extends StatefulWidget {
  const HostelForm({super.key});

  @override
  HostelFormState createState() => HostelFormState();
}

class HostelFormState extends State<HostelForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assignRoomNumber();
  }

  String _homeAddress = '';
  String _guardianName = '';
  String _guardianContact = '';
  String _relationship = '';
  String _duration = 'semester';
  String _selectedHostel = 'BLOCK I Hostel';
  int _price = 50000; // Default price
  String _roomNumber = 'Not Assigned';
  bool isloading = false;
  String _disability = 'none';

  void _assignRoomNumber() {
    final random = Random();
    int randomRoomNumber = random.nextInt(100) + 1;
    _roomNumber = randomRoomNumber.toString();
  }

  void _confirmBooking() {
    setState(() {
      isloading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _assignRoomNumber();
      _firestore.collection('bookings').add({
        'hostelName': _selectedHostel,
        'homeAddress': _homeAddress,
        'guardianName': _guardianName,
        'guardianContact': _guardianContact,
        'relationship': _relationship,
        'duration': _duration,
        'disability': _disability,
        'price': _price,
        'roomNumber': _roomNumber,
        'payment_status': 'not paid'
      }).then((value) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Booking Confirmed! Room Number: $_roomNumber')),
        );
      }).catchError((error) {
        setState(() {
          isloading = false;
        });
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
        backgroundColor: const Color.fromARGB(236, 232, 190, 4),
        title: const Text('Hostel Application Form'),
      ),
      body: LoadingOverlay(
        isLoading: isloading,
        progressIndicator: const CircularProgressIndicator(
          color: Color.fromARGB(255, 65, 58, 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Select Hostel'),
                  value: _selectedHostel,
                  items: const [
                    DropdownMenuItem(
                        value: 'BLOCK I Hostel', child: Text('BLOCK I Hostel')),
                    DropdownMenuItem(
                        value: 'BLOCK II Hostel',
                        child: Text('BLOCK II Hostel')),
                    DropdownMenuItem(
                        value: 'BLOCK III Hostel',
                        child: Text('BLOCK III Hostel')),
                    DropdownMenuItem(
                        value: 'BLOCK IV Hostel',
                        child: Text('BLOCK IV Hostel')),
                    DropdownMenuItem(
                        value: 'BLOCK V Hostel', child: Text('BLOCK V Hostel')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedHostel = value!;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Home Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                       setState(() {
                        isloading = false;
                      });
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
                     setState(() {
                        isloading = false;
                      });
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
                  decoration:
                      const InputDecoration(labelText: 'Guardian Contact'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                       setState(() {
                        isloading = false;
                      });
                      return 'Please enter guardian contact number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _guardianContact = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Relationship with Guardian'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                       setState(() {
                        isloading = false;
                      });
                      return 'Please enter relationship with the guardian';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _relationship = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Disability'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        isloading = false;
                      });
                      return 'Fill in disability state';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _disability = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Duration of Stay'),
                  value: _duration,
                  items: const [
                    DropdownMenuItem(
                        value: 'semester', child: Text('Semester - 50000Tsh')),
                    DropdownMenuItem(value: 'year', child: Text('Year - 100000Tshs')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _duration = value!;
                      _price = _duration == 'semester' ? 50000 : 100000;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text('Assigned Room Number: $_roomNumber'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(236, 232, 190, 4),
                  ),
                  child: const Text('Confirm Booking'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const BookingsPage())));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(236, 232, 190, 4),
                  ),
                  child: const Text('My Bookings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
