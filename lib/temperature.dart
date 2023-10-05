import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:security_locker_iot/Utility/general_utils.dart';

class TemperatureTracking extends StatefulWidget {
  const TemperatureTracking({Key? key}) : super(key: key);
  @override
  State<TemperatureTracking> createState() => _TemperatureTracking();
}

class _TemperatureTracking extends State<TemperatureTracking> {
  bool isSwitched = false;
  String text = "";
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Temperature Tracking"),
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
                            'This page will be used for notifying the user on the temperature when it reach a amount that the user set.'),
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
      body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: TextField(
                    maxLength: 2,
                    controller: myController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: Theme.of(context).textTheme.headline6?.apply(
                        color: Colors.black,
                        fontSizeFactor: 1.3,
                        fontWeightDelta: 2)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                child: SizedBox(
                  width: widthOfScreen,
                  child: ElevatedButton(
                    onPressed: () {
                      GeneralUtils.showLoadingDialog(context);
                      if (myController.text.isEmpty) {
                        Navigator.pop(context);
                        GeneralUtils.showToast("Temperature limit is empty.");
                      } else {
                        FirebaseFirestore db = FirebaseFirestore.instance;

                        final locker = <String, String>{
                          "temperatureLimit": myController.text.trim(),
                        };

                        db
                            .collection("locker")
                            .doc("yGCZLiD8yD4XAGR0mjSO7")
                            .set(locker, SetOptions(merge: true))
                            .onError((e, _) =>
                                GeneralUtils.showToast("Something Went Wrong"))
                            .then((value) {
                          Navigator.pop(context);
                          GeneralUtils.showToast(
                              "Temperature limit has been set.");
                        });
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ),
            ]),
          ),
        )
      ])),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
