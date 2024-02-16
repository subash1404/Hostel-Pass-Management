import 'package:flutter/material.dart';
import 'package:hostel_pass_management/pages/student/new_pass_page.dart';
import 'package:hostel_pass_management/widgets/student/active_passes.dart';
import 'package:hostel_pass_management/widgets/student/custom_drawer.dart';
import 'package:hostel_pass_management/widgets/student/pass_log.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SVCE Hostel'),
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: Hero(
        tag: "newpass",
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewPassPage(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              width: 130,
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 25,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    Text("New Pass")
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      drawer: const CustomDrawer(),
      body: const Column(
        children: [
          ActivePasses(),
          Expanded(
            child: PassLog(),
          ),
        ],
      ),
    );
  }
}
