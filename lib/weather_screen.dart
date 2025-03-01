import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/weather_card.dart';

class WeatherScreen1 extends StatefulWidget {
  const WeatherScreen1({super.key});

  @override
  _WeatherScreen1State createState() => _WeatherScreen1State();
}

class _WeatherScreen1State extends State<WeatherScreen1> {
  final WeatherService weatherService = WeatherService();
  Map<String, dynamic> weatherData = {};
  final TextEditingController _cityController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchWeather("New York"); // Default city
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      var data = await weatherService.getWeather(city);
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().contains("City not found")
            ? "City not found. Try again!"
            : "Failed to fetch weather data. Check your connection.";
        weatherData = {}; // Clear invalid data
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter city name",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        fetchWeather(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      fetchWeather(_cityController.text);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : errorMessage != null
                      ? Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      : weatherData.isNotEmpty
                          ? WeatherCard(weatherData: weatherData)
                          : const Text(
                              "Enter a city to get weather data",
                              style: TextStyle(color: Colors.white),
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
