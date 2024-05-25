import 'package:flutter/material.dart';

class Hostel {
  final String name;
  final String imageAsset;
  final String description;

  Hostel({
    required this.name,
    required this.imageAsset,
    required this.description,
  });
}

class HostelPage extends StatelessWidget {
  final List<Hostel> hostels = [
    Hostel(
      name: 'BLOCK I Hostel',
      imageAsset: 'assets/block1.jpg',
      description:
          'BLOCK I Hostel provides comfortable accommodation for MALE students with various amenities including study areas, and recreational facilities.',
    ),
    Hostel(
      name: 'BLOCK II Hostel',
      imageAsset: 'assets/block2.jpg',
      description:
          'BLOCK II Hostel is for ladies offers modern living spaces with spacious rooms, and 24/7 security for a conducive learning environment.',
    ),
    Hostel(
      name: 'BLOCK III Hostel',
      imageAsset: 'assets/block3.jpg',
      description:
          'BLOCK III MALE\'s Hostel is known for its vibrant community atmosphere, fostering social interactions and academic support among residents.',
    ),
    Hostel(
      name: 'BLOCK IV Hostel',
      imageAsset: 'assets/block4.jpg',
      description:
          'BLOCK IV Female Hostel provides affordable accommodation options with basic amenities and convenient access to campus facilities.',
    ),
    Hostel(
      name: 'BLOCK V Hostel',
      imageAsset: 'assets/block5.jpg',
      description:
          'Block V male Hostel offers a serene environment conducive to study and relaxation, with well-maintained facilities and green spaces.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(236, 232, 190, 4),
        title: const Text('DIT Hostels', style: TextStyle(color: Colors.white,fontSize: 16)),
      ),
      body: ListView.builder(
        itemCount: hostels.length,
        itemBuilder: (context, index) {
          Hostel hostel = hostels[index];
          return ListTile(
            splashColor: Colors.yellowAccent,
            leading: CircleAvatar(
              radius: h * 0.03, // Adjusted the radius to be more appropriate
              backgroundImage: AssetImage(hostel.imageAsset),
            ),
            title: Text(hostel.name, style: const TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold),),
            subtitle: Text(hostel.description),
          );
        },
      ),
    );
  }
}

