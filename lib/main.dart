import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/weather_screen.dart';
import 'controllers/weather_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen1(),
    );
  }
}

// class WeatherScreen extends StatelessWidget {
//   final WeatherController weatherController = Get.put(WeatherController());
//   final TextEditingController cityController = TextEditingController();

//   WeatherScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Weather App")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: cityController,
//               decoration: const InputDecoration(
//                 hintText: "Enter City Name",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 weatherController.fetchWeather(cityController.text);
//               },
//               child: const Text("Get Weather"),
//             ),
//             const SizedBox(height: 20),
//             Obx(() {
//               if (weatherController.isLoading.value) {
//                 return const CircularProgressIndicator();
//               }
//               if (weatherController.weatherData.isEmpty) {
//                 return const Text("Enter a city to see the weather");
//               }
//               return Column(
//                 children: [
//                   Text(
//                     "${weatherController.weatherData['main']['temp']}°C",
//                     style: const TextStyle(
//                         fontSize: 32, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     weatherController.weatherData['weather'][0]['description'],
//                     style: const TextStyle(fontSize: 20),
//                   ),
//                   Text(
//                     "Humidity: ${weatherController.weatherData['main']['humidity']}%",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
