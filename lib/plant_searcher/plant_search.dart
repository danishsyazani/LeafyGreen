import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Plant {
  final int id;
  final String searchText;
  final String name;
  final String scientificName;
  final String imageUrl;
  final String cycle;
  final String watering;
  final String sunlight;

  Plant({
    required this.id,
    required this.searchText,
    required this.name,
    required this.scientificName,
    required this.imageUrl,
    required this.cycle,
    required this.watering,
    required this.sunlight,
  });
}

class PlantSearchScreen extends StatelessWidget {
  const PlantSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/bgplant.jpg',
                width: 300,
              ),
            ),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Plant",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " Searcher",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.green),
                  decoration: InputDecoration(
                    hintText: "Search for the plants.....",
                    hintStyle: TextStyle(color: Colors.green.withOpacity(0.5)),
                    icon: const Icon(Icons.search, color: Colors.green),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (searchText) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantListScreen(
                          searchText: searchText,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final void Function(String) onSearch;

  const SearchBar({super.key, required this.onSearch});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for plants',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              widget.onSearch(_searchController.text);
            },
          ),
        ],
      ),
    );
  }
}

class PlantListScreen extends StatefulWidget {
  final String searchText;

  const PlantListScreen({super.key, required this.searchText});

  @override
  _PlantListScreenState createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  List<Plant> _plants = [];

  @override
  void initState() {
    super.initState();
    _fetchPlants(widget.searchText);
  }

  void _fetchPlants(String searchText) async {
    const apiKey = 'sk-MWmz64de0acb084cd1886';
    final apiUrl =
        'https://perenual.com/api/species-list?key=$apiKey&q=$searchText';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);
      print("$searchText here");
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        List<Plant> plants = parsePlantsFromJson(result, searchText);
        setState(() {
          _plants = plants;
        });
      } else {
        throw Exception('Failed to load plants');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
        elevation: 0.0,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Plant",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: " List",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _plants.isEmpty ? 1 : _plants.length + 1,
        itemBuilder: (context, index) {
          if (_plants.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (index < _plants.length) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PlantDetailScreen(plant: _plants[index]),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    _plants[index].name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  leading: Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(_plants[index].imageUrl),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'End of List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

List<Plant> parsePlantsFromJson(dynamic jsonData, String searchText) {
  List<Plant> plants = [];
  if (jsonData != null && jsonData is Map) {
    final data = jsonData['data'];
    if (data != null && data is List) {
      for (var plantData in data) {
        if (plantData['id'] <= 3000) {
          try {
            plants.add(Plant(
              id: plantData['id'],
              searchText: searchText,
              name: plantData['common_name'],
              scientificName: plantData['scientific_name'].toList().join(", "),
              imageUrl: plantData['default_image']['original_url'],
              cycle: plantData['cycle'],
              watering: plantData['watering'],
              sunlight: plantData['sunlight'].toList().join(", "),
            ));
          } catch (e) {
            print("error");
          }
        }
      }
    }
  }
  return plants;
}

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailScreen({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
            ),
            const Text(
              'Scientific Name:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              plant.scientificName,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cycle:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              plant.cycle,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Watering:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              plant.watering,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sunlight:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              plant.sunlight,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildInfoRow(String heading, String value) {
  return Row(
    children: [
      Text(
        heading,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    ],
  );
}
