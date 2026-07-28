#include <WiFi.h>
#include <FirebaseESP32.h>
#include <HX711.h>
#include <OneWire.h>
#include <DallasTemperature.h>

// Wi-Fi Credentials
#define WIFI_SSID "YOUR_WIFI_SSID"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"

// Firebase Credentials
#define FIREBASE_HOST "YOUR_FIREBASE_DATABASE_URL"
#define FIREBASE_AUTH "YOUR_FIREBASE_DATABASE_SECRET"

// Pin Configurations
#define LOADCELL_DOUT_PIN 4
#define LOADCELL_SCK_PIN 5
#define ONE_WIRE_BUS 2 // Temperature sensor pin

HX711 scale;
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

void setup() {
  Serial.begin(115200);

  // Connect Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWi-Fi Connected!");

  // Initialize Firebase
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  Firebase.setReconnectionTime(true, 10);

  // Initialize Sensors
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  scale.set_scale(2280.f); // Adjust scale calibration factor as needed
  scale.tare();            // Reset the scale to 0

  sensors.begin();
}

void loop() {
  // Read Temperature
  sensors.requestTemperatures();
  float temperatureC = sensors.getTempCByIndex(0);

  // Read Weight (converted to kg for Firebase payload)
  float weightKg = 0.0;
  if (scale.is_ready()) {
    weightKg = scale.get_units(5);
    if (weightKg < 0) weightKg = 0.0;
  } else {
    Serial.println("HX711 not found.");
  }

  // Send Data to Firebase Realtime Database (/esp_data)
  if (Firebase.ready()) {
    Firebase.setFloat(fbdo, "/esp_data/temperature", temperatureC);
    Firebase.setFloat(fbdo, "/esp_data/weight", weightKg);
    Serial.println("Data synced to Firebase successfully.");
  } else {
    Serial.println("Firebase disconnected, retrying...");
  }

  delay(2000); // Send update every 2 seconds
}