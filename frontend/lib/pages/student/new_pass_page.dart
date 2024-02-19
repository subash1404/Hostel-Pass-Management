import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/providers/pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewPassPage extends ConsumerStatefulWidget {
  const NewPassPage({Key? key}) : super(key: key);

  @override
  _NewPassPageState createState() => _NewPassPageState();
}

class _NewPassPageState extends ConsumerState<NewPassPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  DateTime? inDate;
  TimeOfDay? inTime;
  DateTime? outDate;
  TimeOfDay? outTime;
  String? passType;
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "newpass",
      child: Scaffold(
        appBar: AppBar(
          title: const Text("New Pass"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _destinationController,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      labelText: "Destination",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the destination';
                      }
                      return null;
                    },
                  ),
                  const Text(
                    "Select Pass Type",
                  ),
                  Row(
                    children: [
                      _buildRadio("GatePass"),
                      _buildRadio("StayPass"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Leaving Date and Time"),
                  const SizedBox(height: 8),
                  _buildDateTimePicker("In", inDate, inTime),
                  const SizedBox(height: 20),
                  Text("Returning Date and Time"),
                  const SizedBox(height: 8),
                  _buildDateTimePicker("Out", outDate, outTime),
                  const SizedBox(height: 20),
                  Text("Reason"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Reason here...',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    onChanged: (text) {},
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: const Text('Submit'),
                  ),
                  TextButton(
                    onPressed: () {
                      // ref.read(passProvider.notifier).addPass(
                      //       Pass(
                      //         passId: "passId",
                      //         studentId: "studentId",
                      //         qrId: "qrId",
                      //         status: "Pending",
                      //         destination: "destination",
                      //         type: "Gatepass",
                      //         isActive: true,
                      //         reason: "reason",
                      //         inDate: "43-45-2498",
                      //         inTime: "12:43 PM",
                      //         outDate: "34-65-9876",
                      //         outTime: "23:65 AM",
                      //       ),
                      //     );
                    },
                    child: Text("Add Dummy Pass"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: passType,
          onChanged: (selectedValue) {
            if (selectedValue != null) {
              setState(() {
                passType = selectedValue;
                if (passType == "GatePass") {
                  outDate = inDate;
                }
              });
            }
          },
        ),
        Text(value),
      ],
    );
  }

  Widget _buildDateTimePicker(String label, DateTime? date, TimeOfDay? time) {
    return Row(
      children: [
        _buildDateButton(label, date),
        const SizedBox(width: 20),
        _buildTimeButton(label, time),
      ],
    );
  }

  Widget _buildDateButton(String label, DateTime? dateTime) {
    final buttonText =
        dateTime != null ? '${_formatDate(dateTime)}' : '$label Date';

    return Expanded(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.calendar_month_outlined),
        onPressed: _datePickerPressed(label),
        label: Text(buttonText),
      ),
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay? time) {
    final buttonText = time != null ? '${_formatTime(time)}' : '$label Time';

    return Expanded(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.watch_later_outlined),
        onPressed: _timePickerPressed(label),
        label: Text(buttonText),
      ),
    );
  }

  VoidCallback? _datePickerPressed(String label) {
    return passType == "GatePass" && label == "Out"
        ? null
        : () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2026),
            );
            _updateDate(label, pickedDate);
          };
  }

  VoidCallback _timePickerPressed(String label) {
    return () async {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      _updateTime(label, pickedTime);
    };
  }

  void _updateDate(String label, DateTime? pickedDate) {
    if (pickedDate != null) {
      setState(() {
        if (label == "In") {
          inDate = pickedDate;
          if (passType == "GatePass") {
            outDate = pickedDate;
          }
        } else {
          passType == "GatePass" && label == "In"
              ? outDate = inDate
              : outDate = pickedDate;
        }
      });
    }
  }

  void _updateTime(String label, TimeOfDay? pickedTime) {
    if (pickedTime != null) {
      setState(() {
        if (label == "In") {
          inTime = pickedTime;
        } else {
          outTime = pickedTime;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (passType == null) {
        return _showSnackBar("Please Select the Pass type");
      }

      if (inDate == null ||
          inTime == null ||
          outDate == null ||
          outTime == null) {
        return _showSnackBar("Please select all date and time fields.");
      }

      if (_reasonController.text.isEmpty) {
        return _showSnackBar("Please enter the reason");
      }

      try {
        await ref.read(passProvider.notifier).addPass(
              destination: _destinationController.text,
              inDate: _formatDate(inDate!),
              inTime: _formatTime(inTime!),
              outDate: _formatDate(outDate!),
              outTime: _formatTime(outTime!),
              reason: _reasonController.text,
              type: passType!,
            );
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
      } catch (error) {
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 1));

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).clearSnackBars();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
