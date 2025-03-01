import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherController extends GetxController {
  var weatherData = Rx<Map<String, dynamic>>({});
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeather(String city) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      weatherData.value = {};

      var data = await _weatherService.getWeather(city);
      weatherData.value = data;
    } catch (e) {
      errorMessage.value = e.toString().contains("City not found")
          ? "City not found. Try again!"
          : "Failed to fetch weather data. Check your connection.";

      Get.snackbar("Error", errorMessage.value ?? "Could not fetch weather",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.3),
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
