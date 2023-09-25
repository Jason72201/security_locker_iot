import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchClass extends StatefulWidget {
  const SwitchClass({Key? key}) : super(key: key);
  @override
  State<SwitchClass> createState() => _SwitchClass();
}

class _SwitchClass extends State<SwitchClass> {
  bool isSwitched = false;
  bool isCustomSwitch = false;
  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    DatabaseReference ref = FirebaseDatabase.instance.ref("lockerSwitch");

    Stream<DatabaseEvent> stream = ref.child("switch").onValue;

    // Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      if (event.snapshot.value == "open") {
        setState(() {
          isSwitched = true;
          isCustomSwitch = true;
        });
      } else {
        setState(() {
          isSwitched = false;
          isCustomSwitch = false;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Remote Control"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              CupertinoIcons.question_circle,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        content: const Text(
                            'This page will be used for opening or closing the locker.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ));
            },
          ),
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset(
                    isSwitched == true
                        ? 'assets/lockOpen.png'
                        : 'assets/lockClose.png',
                    fit: BoxFit.fill,
                    width: widthOfScreen / 1.3,
                    height: widthOfScreen / 1.3,
                  ),
                )),
            Align(
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 2.0,
                child: Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    isSwitched = value;
                    if (isSwitched == true) {
                      ref.update({
                        "switch": "open",
                      });
                    } else {
                      ref.update({
                        "switch": "close",
                      });
                    }
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ),

            ),
          ]),
    );
  }
}
