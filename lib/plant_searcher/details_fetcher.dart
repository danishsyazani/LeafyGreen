import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantDetailsFetcher {
  static Future<Map<String, dynamic>> fetchGeneralDetails(int plantId) async {
    const apiKey =
        'sk-MWmz64de0acb084cd1886'; // Replace with your actual API key
    final apiUrl =
        'https://perenual.com/api/species/details/$plantId?key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return {
          'origin': result['origin'],
          'other_names': result['other_name'].join(", "),
          'type': result['type'],
          'dimension': result['dimension'],
          'propagation': result['propagation'].join(", "),
          'watering': result['watering'],
          'depth_watering_requirement': result['depth_watering_requirement'],
          'volume_water_requirement': result['volume_water_requirement'],
          'maintenance': result['maintenance'],
          'growth_rate': result['growth_rate'],
          'care_level': result['care_level'],
          'medicinal': result['medicinal'],
          'poisonous_to_humans': result['poisonous_to_humans'],
          'poisonous_to_pets': result['poisonous_to_pets'],
          'description': result['description'],
        };
      } else {
        throw Exception('Failed to load general details');
      }
    } catch (error) {
      rethrow;
    }
  }
}
