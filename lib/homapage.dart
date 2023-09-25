import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:security_locker_iot/Utility/class_model.dart';
import 'package:security_locker_iot/Utility/general_utils.dart';
import 'package:security_locker_iot/locker_switch.dart';
import 'package:security_locker_iot/temperature.dart';
import 'package:security_locker_iot/voice_recognition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'keypad_password.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? lockerID;
  String? rfid;
  String temperature = "";
  String humidity = "";
  String? voiceRecognition;

  Future<void> getData() async {
    final ref =
        db.collection("locker").doc("yGCZLiD8yD4XAGR0mjSO7").withConverter(
              fromFirestore: LockerInformation.fromFirestore,
              toFirestore: (LockerInformation lockInformation, _) =>
                  lockInformation.toFirestore(),
            );
    final docSnap = await ref.get();
    final lockInformation = docSnap.data();
    if (lockInformation != null) {
      setState(() {
        lockerID = lockInformation.lockerID;
        rfid = lockInformation.rfid;
        voiceRecognition = lockInformation.voiceRecognition;
      });
    } else {
      GeneralUtils.showToast("Something Went Wrong");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;
    if (lockerID == null) {
      return Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ));
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref("DHT");

    Stream<DatabaseEvent> humidityStream = ref.onValue;
    // Subscribe to the stream!
    humidityStream.listen((DatabaseEvent event) {
      setState(() {
        humidity = event.snapshot.value.toString().split(":")[2];
        temperature = event.snapshot.value.toString().split(":")[1].split(",")[0];
      });
    });

    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Control Panel"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.settings,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //     onPressed: () {
        //       // do something
        //       // Navigator.of(context, rootNavigator: true).push(
        //       //     MaterialPageRoute(builder: (context) => const FriendPage()));
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 10),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 3, left: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: widthOfScreen,
                  child: Column(
                    children: [
                      const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Locker Information",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          )),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Locker ID: $lockerID\nRFID Number: $rfid\nCurrent Temperature: ${temperature.split(".")[0]}\nCurrent Humidity: ${humidity.split(".")[0]}\nVoice Recognition: $voiceRecognition\n",
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SwitchClass()),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: Offset(0, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        'assets/locker.png',
                                        fit: BoxFit.fill,
                                        width: widthOfScreen,
                                        height: heightOfScreen / 4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                "Remote Control",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const KeypadPassword()),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: Offset(0, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        'assets/password.png',
                                        fit: BoxFit.fill,
                                        width: widthOfScreen,
                                        height: heightOfScreen / 4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                "Keypad Password",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TemperatureTracking()),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: Offset(0, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/temperature.png',
                                      fit: BoxFit.fill,
                                      width: widthOfScreen,
                                      height: heightOfScreen / 4,
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                "Temperature Tracking",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VoiceRecognition()),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: Offset(0, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/voice-recognition.png',
                                      fit: BoxFit.fill,
                                      width: widthOfScreen,
                                      height: heightOfScreen / 4,
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                "Voice Recognition Settings",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
          ]),
        ),
      ),
    );
  }
}
