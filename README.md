# 🍲 IoT-Based Smart Food Surplus Redistribution System

An end-to-end sustainable ecosystem combining IoT hardware sensors (Load cell & Temperature sensor via ESP32 & Firebase Realtime Database) with a cross-platform Flutter application. The system enables food donors to instantly log surplus meals with precise geolocation and real-time sensor metrics, while receivers (NGOs/shelters) can browse available food, inspect freshness indicators, navigate via Google Maps, and reserve donations seamlessly.

---

## 🌟 Key Features
- **IoT Hardware Integration:** Automated weight and temperature monitoring of placed food packages via ESP32 connected sensors.
- **Donor Dashboard:** Quick entry for food items, categories (Fresh/Cooked vs. Packed/Dry), and automatic GPS location tagging using Flutter `Geolocator`.
- **NGO Dashboard:** Real-time stream of available food donations accompanied by live temperature metrics, weight indicators, and dynamic expiry countdowns.
- **Direct Map Navigation:** One-tap integration with Google Maps for seamless pickup logistics.
- **Reservation Workflow:** Instant status updates from 'Available' to 'Accepted' to prevent duplicate pickups.

---

## 📱 Tech Stack
- **Frontend:** Flutter (Dart)
- **Backend & Database:** Firebase Realtime Database
- **Hardware:** ESP32 Microcontroller, HX711 Load Cell Amplifier, Temperature Sensor
- **Libraries:** `firebase_database`, `geolocator`, `url_launcher`

---

## ⚙️ Getting Started & Installation

### 1. Clone the Repository and run inside chrome
```bash
git clone [https://github.com/felixthomasroy/smart_food_redistribution.git](https://github.com/felixthomasroy/smart_food_redistribution.git)
cd smart-food-redistribution
flutter run -d chrome
## needs flutter sdk and flutter and dart extensions installed for running