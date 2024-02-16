import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PassItem extends StatefulWidget {
  final String dateTime;
  final String type;
  final String status;
  final String? action;

  PassItem({
    required this.dateTime,
    required this.type,
    required this.status,
    this.action,
  });

  @override
  State<PassItem> createState() => _PassItemState();
}

class _PassItemState extends State<PassItem> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    String statusText;
    Color statusColor;
    Widget actionWidget;

    switch (widget.status) {
      case 'Pending':
        statusText = 'Pending';
        statusColor = colorScheme.background;
        actionWidget = TextButton(
          onPressed: () {},
          child: const Text("Delete Pass"),
        );
        break;
      case 'Approved':
        statusText = 'Approved';
        statusColor = const Color.fromARGB(255, 190, 255, 192);
        actionWidget = TextButton.icon(
          onPressed: () {
            showModalBottomSheet(
              scrollControlDisabledMaxHeightRatio: 0.6,
              context: context,
              builder: (context) {
                return BottomSheet();
              },
            );
          },
          icon: const Icon(Icons.qr_code_rounded),
          label: const Text("Get QR"),
        );
        break;
      case 'Rejected':
        statusText = 'Rejected';
        statusColor = colorScheme.errorContainer;
        actionWidget = Container();
        break;
      case 'Expired':
        statusText = 'EXPIRED';
        statusColor = const Color.fromARGB(255, 183, 183, 183);
        actionWidget = Container();
        break;
      default:
        statusText = 'Unknown';
        statusColor = Colors.black;
        actionWidget = Container();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: statusColor),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Column(
            children: [
              Icon(Icons.post_add_sharp),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(statusText),
              Text(widget.dateTime),
              Text(widget.type),
            ],
          ),
          const Spacer(),
          actionWidget,
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  BottomSheet({super.key});

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: colorScheme.background,
            ),
            child: Column(
              children: [
                Text(
                  "Scan QR at Entrance",
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 350,
                  width: 350,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorScheme.primaryContainer,
                  ),
                  child: QrImageView(
                    data:
                        "sqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiopsqwertyuiop",
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Use this QR for Exit and Entry",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
