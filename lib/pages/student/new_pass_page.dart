import 'package:flutter/material.dart';

class NewPassPage extends StatelessWidget {
  const NewPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "newpass",
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Pass"),
        ),
      ),
    );
  }
}
