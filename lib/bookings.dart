import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  BookingsPageState createState() => BookingsPageState();
}

class BookingsPageState extends State<BookingsPage> {
  final _firestore = FirebaseFirestore.instance;

  void _makePayment(String bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String cardNumber = '';
        String cardExpiry = '';
        String cardCvv = '';
        double paymentAmount = 0.0;

        return AlertDialog(
          title: const Text('Make Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card Number'),
                onChanged: (value) {
                  cardNumber = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card Expiry'),
                onChanged: (value) {
                  cardExpiry = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card CVV'),
                onChanged: (value) {
                  cardCvv = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Payment Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  paymentAmount = double.parse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Submit'),
              onPressed: () {
                // Update payment status in Firestore
                _firestore.collection('bookings').doc(bookingId).update({
                  'payment_status': 'paid',
                  'payment_amount': paymentAmount,
                }).then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment Successful')),
                  );
                }).catchError((error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment Failed: $error')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(236, 232, 190, 4),
        title: const Text('My Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('bookings').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return Card(
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                // title: Text('Hostel: ${booking['hostel_name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hostel: ${booking['hostelName']}'),
                      Text('Duration: ${booking['duration']}'),
                      Text('Price: ${booking['price']}'),
                      Text('Room Number: ${booking['roomNumber']}'),
                      Text('Payment Status: ${booking['payment_status']}'),
                    ],
                  ),
                  trailing: booking['payment_status'] != 'paid'
                      ? ElevatedButton(
                          child: const Text('Make Payment', style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(236, 232, 190, 4),),
                          onPressed: () => _makePayment(booking.id),
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
