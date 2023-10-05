import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:security_locker_iot/Utility/general_utils.dart';
import 'package:security_locker_iot/Utility/keypad_layout.dart';

class KeypadPassword extends StatefulWidget {
  const KeypadPassword({Key? key}) : super(key: key);
  @override
  State<KeypadPassword> createState() => _KeypadPassword();
}

class _KeypadPassword extends State<KeypadPassword> {
  bool isSwitched = false;
  String text = "";

  onKeyboardTap(String value) {
    setState(() {
      if (text.length < 6) {
        text = text + value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Keypad Password"),
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
                      'This page will be used for changing the keypad password.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Center(
              child: Column(children: [
        const Spacer(),
        Text(text,
            style: Theme.of(context).textTheme.headline6?.apply(
                color: Colors.black, fontSizeFactor: 2.3, fontWeightDelta: 2)),
        const Spacer(),
        NumericKeyboard(
            onKeyboardTap: onKeyboardTap,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
            leftButtonFn: () {
              GeneralUtils.showLoadingDialog(context);
              if (text.isEmpty) {
                Navigator.pop(context);
                GeneralUtils.showToast("Keypad password is empty.");
              } else {
                FirebaseFirestore db = FirebaseFirestore.instance;

                final locker = <String, String>{
                  "keypadPassword": text,
                };

                db
                    .collection("locker")
                    .doc("yGCZLiD8yD4XAGR0mjSO7")
                    .set(locker, SetOptions(merge: true))
                    .onError((e, _) =>
                        GeneralUtils.showToast("Something Went Wrong"))
                    .then((value) {
                  Navigator.pop(context);
                  GeneralUtils.showToast("Keypad password has been changed.");
                });
              }
            },
            rightButtonFn: () {
              if (text.isEmpty) return;
              setState(() {
                text = text.substring(0, text.length - 1);
              });
            },
            rightButtonLongPressFn: () {
              if (text.isEmpty) return;
              setState(() {
                text = '';
              });
            },
            rightIcon: const Icon(
              Icons.backspace_outlined,
              color: Colors.blueGrey,
            ),
            mainAxisAlignment: MainAxisAlignment.spaceBetween),
      ]))),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
