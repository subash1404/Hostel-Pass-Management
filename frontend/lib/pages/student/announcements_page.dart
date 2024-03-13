import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  int _selectedValue = 3;
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  void initState() {
    super.initState();
    int excludedBlock = prefs!.getInt("permanentBlock")!;
    _selectedValue = excludedBlock == 1 ? 2 : 1;
  }

  void _submit(BuildContext context) {
    TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              "Type \"SWITCH\" to delete",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          content: TextField(
            controller: confirmController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (confirmController.text == "SWITCH") {
                  try {
                    await http.post(
                      Uri.parse(
                        "${dotenv.env["BACKEND_BASE_API"]}/rt/block/switchRt",
                      ),
                      headers: {
                        "Content-Type": "application/json",
                        "Authorization": prefs!.getString("jwtToken")!,
                      },
                      body: jsonEncode({
                        "permanentBlockNo": prefs!.getInt("permanentBlock"),
                        "blockNo": _selectedValue
                      }),
                    );
                  } catch (err) {
                    print(
                        "Error occurred: $err"); // Handle error more gracefully
                  }
                  print("selected value : $_selectedValue");
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please type SWITCH to switch RT"),
                  ));
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _revert() {
    TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              "Type \"REVERT\" to delete",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          content: TextField(
            controller: confirmController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (confirmController.text == "REVERT") {
                  try {
                    await http.post(
                      Uri.parse(
                        "${dotenv.env["BACKEND_BASE_API"]}/rt/block/revertSwitchRt",
                      ),
                      headers: {
                        "Content-Type": "application/json",
                        "Authorization": prefs!.getString("jwtToken")!,
                      },
                      body: jsonEncode({
                        "permanentBlockNo": prefs!.getInt("permanentBlock"),
                      }),
                    );
                  } catch (err) {
                    print(
                        "Error occurred: $err"); // Handle error more gracefully
                  }
                  print("selected value : $_selectedValue");
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please type SWITCH to switch RT"),
                  ));
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int excludedBlock = prefs!.getInt("permanentBlock")!;
    List<DropdownMenuItem<int>> items = List.generate(
      8,
      (int index) {
        int value = index + 1;
        if (value != excludedBlock) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('Block $value'),
          );
        }
        return null;
      },
    ).where((item) => item != null).toList().cast<DropdownMenuItem<int>>();

    if (items.isEmpty) {
      items.add(DropdownMenuItem<int>(
        value: _selectedValue,
        child: Text('Block $_selectedValue'),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Example'),
      ),
      drawer: RtDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<int>(
              value: _selectedValue,
              onChanged: (int? value) {
                setState(() {
                  _selectedValue = value!;
                });
              },
              items: items,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submit(context);
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _revert,
              child: Text('Revert'),
            ),
          ],
        ),
      ),
    );
  }
}
