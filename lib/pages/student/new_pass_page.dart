import 'package:flutter/material.dart';

class NewPassPage extends StatefulWidget {
  NewPassPage({super.key});
  @override
  State<NewPassPage> createState() {
    return _NewPassPageState();
  }
}

class _NewPassPageState extends State<NewPassPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  DateTime? inDate;
  TimeOfDay? inTime;
  DateTime? outDate;
  TimeOfDay? outTime;
  String? passType;

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
                _buildDateTimePicker("In", inDate, inTime),
                const SizedBox(height: 20),
                Text("Returning Time"),
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
        icon: Icon(Icons.calendar_month_outlined),
        onPressed: passType == "GatePass" && label == "Out"
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
              },
        label: Text(buttonText),
      ),
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay? time) {
    String buttonText = time != null ? _formatTime(time) : '$label Time';

    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(Icons.watch_later_outlined),
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
    return '${date.day} / ${date.month} / ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print(passType);
      if (passType == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please Select the Pass type")));
        return;
      }
      if (_reasonController.text == "") {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please enter the reason")));
        return;
      }
      if (inDate != null &&
          inTime != null &&
          outDate != null &&
          outTime != null) {
        print("Destination: ${_destinationController.text}");
        print(_reasonController.text);
        // print("In Date: $inDate");
        // print("In Time: $inTime");
        // print("Out Date: $outDate");
        // print("Out Time: $outTime");
        print(passType);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select all date and time fields.'),
          ),
        );
      }
    }
  }
}