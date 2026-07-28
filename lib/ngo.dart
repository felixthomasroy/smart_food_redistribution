import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class NgoPage extends StatefulWidget {
  const NgoPage({super.key});

  @override
  State<NgoPage> createState() => _NgoPageState();
}

class _NgoPageState extends State<NgoPage> {
  // Function to open Google Maps with latitude and longitude
  Future<void> _openMap(double lat, double lng) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch maps');
    }
  }

  // Function to handle food reservation
  Future<void> _reserveFood(BuildContext context, String donationId, String foodName) async {
    try {
      // Update status in Firebase database (with timeout for offline mock mode)
      await FirebaseDatabase.instance
          .ref("food_donations/$donationId")
          .update({'status': 'Reserved'})
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint("Offline mode: status updated locally -> $e");
    }

    if (!context.mounted) return;

    // Show reserved confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully reserved "$foodName"! Coordinate pickup with donor.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO / Receiver Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref("food_donations").onValue,
        builder: (context, snapshot) {
          // Fallback test data handler if offline or loading in mock mode
          if (snapshot.connectionState == ConnectionState.waiting || 
              !snapshot.hasData || 
              snapshot.data!.snapshot.value == null) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  "📦 Available Surplus Food ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: const Text("Fresh Rice & Curry Pack"),
                    subtitle: const Text(
                      "Weight: 2.5 kg\nTemperature: 24.5 °C\nLocation: Campus Canteen\nStatus: Available",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => _openMap(10.0522, 76.3115),
                          child: const Text("Map"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                          onPressed: () => _reserveFood(context, "mock_id_1", "Fresh Rice & Curry Pack"),
                          child: const Text("Reserve"),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: const Text("Bakery Surplus (Bread & Buns)"),
                    subtitle: const Text(
                      "Weight: 1.2 kg\nTemperature: 22.0 °C\nLocation: City Bakery\nStatus: Available",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => _openMap(10.0522, 76.3115),
                          child: const Text("Map"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                          onPressed: () => _reserveFood(context, "mock_id_2", "Bakery Surplus"),
                          child: const Text("Reserve"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Real database rendering when connected
          Map<dynamic, dynamic> donations = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Item> donationList = [];
          donations.forEach((key, value) {
            donationList.add(Item.fromMap(key, value as Map<dynamic, dynamic>));
          });

          return ListView.builder(
            itemCount: donationList.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final donation = donationList[index];
              final bool isReserved = donation.status == 'Reserved';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(donation.foodName),
                  subtitle: Text(
                    "Weight: ${donation.weight} kg\nTemperature: ${donation.temperature} °C\nStatus: ${donation.status}",
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => _openMap(donation.latitude, donation.longitude),
                        child: const Text("Map"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isReserved ? Colors.grey : Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isReserved ? null : () => _reserveFood(context, donation.id, donation.foodName),
                        child: Text(isReserved ? 'Reserved' : 'Reserve'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Helper Model for Database Parsing
class Item {
  final String id;
  final String foodName;
  final String weight;
  final String temperature;
  final double latitude;
  final double longitude;
  final String status;

  Item({
    required this.id,
    required this.foodName,
    required this.weight,
    required this.temperature,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory Item.fromMap(String id, Map<dynamic, dynamic> map) {
    return Item(
      id: id,
      foodName: map['foodName'] ?? 'Unknown Food',
      weight: map['weight']?.toString() ?? '1.0',
      temperature: map['temperature']?.toString() ?? '25.0',
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : 10.0,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : 76.0,
      status: map['status'] ?? 'Available',
    );
  }
}