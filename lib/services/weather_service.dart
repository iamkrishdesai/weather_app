import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherService {
  final String apiKey =
      "*************"; //  OpenWeather API key

  Future<Map<String, dynamic>> getWeather(String city) async {
    // Use URL encoding for the city name to handle spaces and special characters
    final encodedCity = Uri.encodeComponent(city);
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?q=$encodedCity&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> originalData = json.decode(response.body);
        // Create a new map to store our processed data
        final Map<String, dynamic> processedData = {...originalData};

        // Extract the timezone offset (in seconds)
        int timezoneOffset = originalData['timezone'];

        // Format the timestamps in a more readable way
        DateFormat timeFormat = DateFormat('h:mm a');
        DateFormat dateFormat = DateFormat('EEE, MMM d, yyyy');

        // Get current time at the location
        DateTime nowUtc = DateTime.now().toUtc();
        DateTime localTime = nowUtc.add(Duration(seconds: timezoneOffset));

        // Process sunrise time
        DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(
                originalData['sys']['sunrise'] * 1000,
                isUtc: true)
            .add(Duration(seconds: timezoneOffset));

        // Process sunset time
        DateTime sunset = DateTime.fromMillisecondsSinceEpoch(
                originalData['sys']['sunset'] * 1000,
                isUtc: true)
            .add(Duration(seconds: timezoneOffset));

        // Add formatted time strings to the data
        processedData['formatted'] = {
          'location':
              originalData['name'] + ', ' + originalData['sys']['country'],
          'temperature': '${originalData['main']['temp'].round()}°C',
          'condition': originalData['weather'][0]['main'],
          'description': originalData['weather'][0]['description'],
          'feels_like': '${originalData['main']['feels_like'].round()}°C',
          'humidity': '${originalData['main']['humidity']}%',
          'wind_speed': '${originalData['wind']['speed']} m/s',
          'local_time':
              '${timeFormat.format(localTime)} (${dateFormat.format(localTime)})',
          'sunrise': timeFormat.format(sunrise),
          'sunset': timeFormat.format(sunset),
          'icon': originalData['weather'][0]['icon'],
        };

        // Keep the original data too
        processedData['raw'] = originalData;

        return processedData;
      } else if (response.statusCode == 404) {
        throw Exception("City not found");
      } else {
        throw Exception(
            "Failed to fetch weather: ${response.statusCode}\n${response.body}");
      }
    } catch (e) {
      print("Weather service error: $e");
      rethrow;
    }
  }
}
