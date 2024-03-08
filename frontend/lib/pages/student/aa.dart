import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dropdown Example',
      home: DropdownExample(),
    );
  }
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  int _selectedValue = 1;
  String excludedBlock = '3';

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>>? items = List.generate(
      7,
      (int index) {
        int value = index + 1;
        if (value.toString() == excludedBlock) return null; // Exclude the block
        return DropdownMenuItem<int>(
          value: value,
          child: Text(index == 0 ? "None" : 'Block $index'),
        );
      },
    ).where((item) => item != null).toList().cast<DropdownMenuItem<int>>();

    if (items.isEmpty) {
      items = List.generate(
        6,
        (int index) {
          int value = index + 1;
          return DropdownMenuItem<int>(
            value: value,
            child: Text('Block $value'),
          );
        },
      ).cast<DropdownMenuItem<int>>();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Example'),
      ),
      body: Center(
        child: DropdownButton<int>(
          value: _selectedValue,
          onChanged: (int? value) {
            setState(() {
              _selectedValue = value!;
            });
          },
          items: items,
        ),
      ),
    );
  }
}
