import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manager Home',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ManagerHomeScreen(),
    );
  }
}

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.black),
          ),
        ),
        title: const Text(
          "Good Morning\nName",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Open Drawer or Menu
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCard(context, "SUN LIGHT", "assets/images/sunlight.png", SunlightScreen()),
            _buildCard(context, "TEMPERATURE", "assets/images/temperature.png", TemperatureScreen()),
            _buildCard(context, "HUMIDITY", "assets/images/humidity.png", HumidityScreen()),
            _buildCard(context, "SOIL MOISTURE", "assets/images/soil_moisture.png", SoilMoistureScreen()),
            _buildCard(context, "NPK LEVELS", "assets/images/npk_levels.png", NPKScreen()),
            _buildCard(context, "RAINFALL", "assets/images/rainfall.png", RainfallScreen()),
            _buildCard(context, "TREE COUNT", "assets/images/tree_count.png", TreeCountScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String imagePath, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 50, height: 50),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// Separate Screens
class SunlightScreen extends StatelessWidget {
  const SunlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailScreen(context, "Sun Light");
  }
}

class TemperatureScreen extends StatelessWidget {
  const TemperatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailScreen(context, "Temperature");
  }
}

class HumidityScreen extends StatelessWidget {
  const HumidityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailScreen(context, "Humidity");
  }
}

class SoilMoistureScreen extends StatelessWidget {
  const SoilMoistureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailScreen(context, "Soil Moisture");
  }
}

class NPKScreen extends StatelessWidget {
  const NPKScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailScreen(context, "NPK Levels");
  }
}

class RainfallScreen extends StatelessWidget {
  const RainfallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailScreen(context, "Rainfall");
  }
}

class TreeCountScreen extends StatelessWidget {
  const TreeCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDetailScreen(context, "Tree Count");
  }
}


// Reusable Detail Page
Widget _buildDetailScreen(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text("Details of $title")),
  );
}
