import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.attribute,
    required this.value,
  });

  final String attribute;
  final String value;

  @override
  Widget build(BuildContext context) {
    TextStyle customFont = GoogleFonts.lato();

    return Container(
      // color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 30,
                ),
                SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attribute,
                      style: customFont.copyWith(
                        color: Color.fromARGB(255, 25, 32, 42),
                        // color: Color.fromARGB(255, 112, 106, 106),
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      value,
                      style: customFont.copyWith(
                        color: Color.fromARGB(255, 96, 102, 110),
                        fontSize: 17,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
