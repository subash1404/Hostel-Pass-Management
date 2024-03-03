import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/providers/student_pass_provider.dart';

class NewPassPage extends ConsumerStatefulWidget {
  NewPassPage({super.key});
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
  bool isSpecialPass = false;

  bool isTimeOfDayBefore(TimeOfDay first, TimeOfDay second) {
    if (first.hour < second.hour) {
      return true;
    } else if (first.hour == second.hour) {
      return first.minute < second.minute;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Radio<String>(
                      value: 'GatePass',
                      groupValue: passType,
                      onChanged: (value) {
                        setState(() {
                          passType = value;
                          if (passType == "GatePass") {
                            outDate = inDate;
                          }
                        });
                      },
                    ),
                    const Text("GatePass"),
                    Radio<String>(
                      value: 'StayPass',
                      groupValue: passType,
                      onChanged: (value) {
                        setState(() {
                          passType = value;
                        });
                      },
                    ),
                    const Text("StayPass"),
                  ],
                ),
                const SizedBox(height: 20),
                Text("Leaving Time"),
                const SizedBox(height: 8),
                _buildDateTimePicker("Out", outDate, outTime),
                const SizedBox(height: 20),
                Text("Returning Time"),
                const SizedBox(height: 8),
                _buildDateTimePicker("In", inDate, inTime),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: "Normal Pass",
                    items: const [
                      DropdownMenuItem(
                        value: "Normal Pass",
                        child: Text("Normal Pass"),
                      ),
                      DropdownMenuItem(
                        value: "Special Pass",
                        child: Text("Special Pass"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == "Normal Pass") {
                        setState(() {
                          isSpecialPass = false;
                        });
                      } else {
                        setState(() {
                          isSpecialPass = true;
                        });
                      }
                    }),
                const SizedBox(height: 20),
                TextField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Reason here...',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    onChanged: (text) {}),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime? date) {
    String buttonText = date != null ? _formatDate(date) : '$label Date';

    return Expanded(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.calendar_month_outlined),
        onPressed: passType == "GatePass" && label == "In"
            ? null
            : () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2026),
                );
                if (pickedDate != null) {
                  setState(() {
                    if (label == "Out") {
                      outDate = pickedDate;
                      if (passType == "GatePass") {
                        inDate = pickedDate;
                      }
                    } else {
                      inDate = pickedDate;
                      if (passType == "GatePass") {
                        outDate = pickedDate;
                      }
                    }
                  });
                }
              },
        label: Text(buttonText),
      ),
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay? time) {
    String buttonText = time != null ? _formatTime(time) : '$label Time';

    return Expanded(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.watch_later_outlined),
        onPressed: () async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            setState(() {
              if (label == "In") {
                inTime = pickedTime;
              } else {
                outTime = pickedTime;
              }
            });
          }
        },
        label: Text(buttonText),
      ),
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

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  // String _formatTime(TimeOfDay time) {
  //   final hour = time.hour.toString().padLeft(2, '0');
  //   final minute = time.minute.toString().padLeft(2, '0');
  //   return '$hour:$minute';
  // }
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      print(passType);
      if (passType == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Select the Pass type")));
        return;
      }
      if (_reasonController.text == "") {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter the reason")));
        return;
      }
      if (inDate != null &&
          inTime != null &&
          outDate != null &&
          outTime != null) {
        if (passType == 'StayPass' && (inDate!.isBefore(outDate!))) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('In date should be after out date')));
          return;
        }
        if (passType == "GatePass" &&
            (inDate == outDate && isTimeOfDayBefore(inTime!, outTime!))) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('In time can\'t be after out time')));
          return;
        }
        if (passType == "StayPass" && (inDate!.isBefore(outDate!))) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('In date can\'t be after out date')));
          return;
        }
        print("Destination: ${_destinationController.text}");
        print(_reasonController.text);
        print("In Date: $inDate");
        print("In Time: $inTime");
        print("Out Date: $outDate");
        print("Out Time: $outTime");
        print(passType);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select all date and time fields.'),
          ),
        );
      }
    }
    try {
      await ref.read(studentPassProvider.notifier).addPass(
            destination: _destinationController.text,
            inDate: _formatDate(inDate!),
            inTime: _formatTime(inTime!),
            outDate: _formatDate(outDate!),
            outTime: _formatTime(outTime!),
            reason: _reasonController.text,
            type: passType!,
            isSpecialPass: isSpecialPass,
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
