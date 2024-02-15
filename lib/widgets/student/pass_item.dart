import 'package:flutter/material.dart';

class PassItem extends StatelessWidget {
  final String dateTime;
  final String type;
  final String status;
  final String? action;

  const PassItem({
    required this.dateTime,
    required this.type,
    required this.status,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    String statusText;
    Color statusColor;
    Widget actionWidget;

    switch (status) {
      case 'Pending':
        statusText = 'Pending';
        statusColor = colorScheme.background;
        actionWidget = Container();
        break;
      case 'Approved':
        statusText = 'Approved';
        statusColor = const Color.fromARGB(255, 190, 255, 192);
        actionWidget = Container();
        break;
      case 'Rejected':
        statusText = 'Rejected';
        statusColor = Color.fromARGB(255, 255, 188, 183);
        actionWidget = TextButton(onPressed: () {}, child: Text("Edit Pass"));
        break;
      case 'Expired':
        statusText = 'EXPIRED';
        statusColor = Color.fromARGB(255, 183, 183, 183);
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
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 20),
          Column(
            children: [
              Icon(Icons.perm_identity_rounded),
            ],
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(statusText),
              Text(dateTime),
              Text(type),
            ],
          ),
          Spacer(),
          actionWidget,
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
