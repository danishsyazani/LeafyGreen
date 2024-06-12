import 'package:flutter/material.dart';

class MoreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> details;

  const MoreDetailsScreen({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 91, 142, 85)),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'More Details',
                style: TextStyle(
                  color: Color.fromARGB(255, 91, 142, 85),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(details['image']),
            for (var key in details.keys)
              if (key != 'image')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$key:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${details[key]}'),
                    const SizedBox(height: 8),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
