# 🍲 IoT-Based Smart Food Surplus Redistribution System

An end-to-end sustainable ecosystem combining IoT hardware sensors (Load cell & Temperature sensor via ESP32/ESP8266 & Firebase Realtime Database) with a cross-platform Flutter application[cite: 1]. The system enables food donors to instantly log surplus meals with precise geolocation and real-time sensor metrics, while receivers (NGOs/shelters) can browse available food, inspect freshness indicators, navigate via Google Maps, and reserve donations seamlessly[cite: 1].

---

## 🌟 Key Features
- **IoT Hardware Integration:** Automated weight and temperature monitoring of placed food packages via ESP32 connected sensors[cite: 1].
- **Donor Dashboard:** Quick entry for food items, categories (Fresh/Cooked vs. Packed/Dry), and automatic GPS location tagging using Flutter `Geolocator`[cite: 1].
- **NGO Dashboard:** Real-time stream of available food donations accompanied by live temperature metrics, weight indicators, and dynamic expiry countdowns[cite: 1].
- **Direct Map Navigation:** One-tap integration with Google Maps for seamless pickup logistics[cite: 1].
- **Reservation Workflow:** Instant status updates from 'Available' to 'Accepted' to prevent duplicate pickups[cite: 1].

---

## 📱 Tech Stack
- **Frontend:** Flutter (Dart)[cite: 1]
- **Backend & Database:** Firebase Realtime Database[cite: 1]
- **Hardware:** ESP32 Microcontroller, HX711 Load Cell Amplifier, Temperature Sensor[cite: 1]
- **Libraries:** `firebase_database`, `geolocator`, `url_launcher`[cite: 1]

---
## 📱 App Screenshots

### 1. Home Page
![Home Page](assets/home_page.png)

### 2. Donor Dashboard
![Donor Dashboard](assets/donor_page.png)

### 3. NGO Dashboard
![NGO Dashboard](assets/ngo_page.png)

---

## ⚙️ Getting Started & Installation

### 1. Clone the Repository
```bash
git clone [https://github.com/felixthomasroy/smart_food_redistribution.git](https://github.com/felixthomasroy/smart_food_redistribution.git)
cd smart-food-redistribution