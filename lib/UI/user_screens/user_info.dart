import 'package:fire/google_Maps/maps.dart';
import 'package:fire/utils/sized.dart';
import 'package:fire/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  String? gender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Enter your Info', 20, Colors.black, FontWeight.bold),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                      controller: firstnamecontroller,
                      decoration: const InputDecoration(
                          labelText: 'First Name',
                          focusColor: Colors.black,
                          icon: Icon(
                            Icons.person,
                            size: 25,
                          ))),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 123,
                  child: TextField(
                      controller: lastnamecontroller,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        focusColor: Colors.black,
                      )),
                )
              ],
            ),
            SizedBox(
              width: getWidth(context),
              child: TextField(
                  controller: emailcontroller,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      focusColor: Colors.black,
                      icon: Icon(Icons.email))),
            ),
            Row(
              children: [
                DropdownButton<String>(
                  value: gender,
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                  items: <String>["Male", "Female", "Other"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: text(value, 15, Colors.black, FontWeight.bold),
                    );
                  }).toList(),
                  hint:
                      text("Select Gender", 15, Colors.black, FontWeight.w700),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 232,
                  child: TextField(
                      controller: phonecontroller,
                      decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          focusColor: Colors.black,
                          icon: Icon(Icons.phone))),
                )
              ],
            ),
            SizedBox(
              width: getWidth(context),
              child: TextField(
                controller: addresscontroller,
                decoration: InputDecoration(
                    labelText: "Address",
                    icon: Icon(Icons.location_on_sharp),
                    labelStyle: TextStyle(color: Colors.black)),
                readOnly: true,
                onTap: () async {
                  final selectedAddress = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocationPickerScreen()));
                  if (selectedAddress != null) {
                    setState(() {
                      addresscontroller.text = selectedAddress;
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
