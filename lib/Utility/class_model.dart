import 'package:cloud_firestore/cloud_firestore.dart';

class LockerInformation {
  final double? humidity;
  final String? keypadPassword;
  final String? lockerID;
  final int? lockerNumber;
  final String? rfid;
  final double? temperature;
  final String? temperatureLimit;
  final String? voiceRecognition;

  LockerInformation( 
      {this.humidity,
      this.temperatureLimit,
      this.keypadPassword,
      this.lockerID,
      this.lockerNumber,
      this.rfid,
      this.temperature,
      this.voiceRecognition});

  factory LockerInformation.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return LockerInformation(
      humidity: data?['humidity'],
      keypadPassword: data?['keypadPassword'],
      lockerID: data?['lockerID'],
      lockerNumber: data?['lockerNumber'],
      rfid: data?['rfid'],
      temperature: data?['temperature'],
      temperatureLimit: data?['temperatureLimit'],
      voiceRecognition: data?['voiceRecognition'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (temperatureLimit != null) "temperatureLimit": temperatureLimit,
      if (humidity != null) "humidity": humidity,
      if (keypadPassword != null) "keypadPassword": keypadPassword,
      if (lockerID != null) "lockerID": lockerID,
      if (lockerNumber != null) "lockerNumber": lockerNumber,
      if (rfid != null) "rfid": rfid,
      if (temperature != null) "temperature": temperature,
      if (voiceRecognition != null) "temperature": voiceRecognition,
    };
  }
}
