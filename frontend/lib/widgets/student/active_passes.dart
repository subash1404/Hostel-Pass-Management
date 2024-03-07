import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/providers/student_pass_provider.dart';
import 'package:hostel_pass_management/widgets/student/pass_item.dart';

class ActivePasses extends ConsumerStatefulWidget {
  const ActivePasses({
    super.key,
    required this.pass,
  });
  final Pass? pass;

  @override
  ConsumerState<ActivePasses> createState() => _ActivePassesState();
}

class _ActivePassesState extends ConsumerState<ActivePasses> {
  void deletePassConfirmation(BuildContext context) {
    // Create a TextEditingController to handle user input
    TextEditingController confirmController = TextEditingController();

    // Show the AlertDialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              "Type \"CONFIRM\" to delete",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          content: TextField(
            controller: confirmController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (confirmController.text == "CONFIRM") {
                  deletePass();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please type CONFIRM to delete"),
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

  void deletePass() {
    if (widget.pass != null) {
      // Call the function in the provider to delete the pass
      ref.read(studentPassProvider.notifier).deletePass(widget.pass!.passId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activePasses = ref.watch(studentPassProvider);
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(15),
      // padding: EdgeInsets.all(20),
      width: double.infinity,
      // height: 175,
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Active Pass",
                  style: textTheme.titleLarge,
                ),
                IconButton(
                    onPressed: widget.pass == null
                        ? null
                        : () {
                            deletePassConfirmation(context);
                          },
                    icon: Icon(
                      Icons.delete,
                      color: colorScheme.error,
                    ))
              ],
            ),
          ),
          const Divider(height: 0),
          Column(
            children: [
              if (widget.pass != null)
                PassItem(
                  inTime: widget.pass!.expectedInTime,
                  outTime: widget.pass!.expectedOutTime,
                  inDate: widget.pass!.expectedInDate,
                  outDate: widget.pass!.expectedOutDate,
                  type: widget.pass!.type,
                  status: widget.pass!.status,
                )
              else
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text("No Currently Active Passes"),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
