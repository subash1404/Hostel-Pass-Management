import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileData extends StatelessWidget {
  const ProfileData(
      {super.key,
      required this.path,
      required this.attribute,
      required this.value});
  final String path;
  final String attribute;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Image.asset(
                path,
                height: 25,
                width: 25,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attribute,
                    style: GoogleFonts.lato(
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                                color: Color.fromARGB(255, 112, 106, 106),
                                fontSize: 14)),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.lato(
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Color.fromARGB(255, 54, 53, 53))),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 30,
          height: 0.35,
          color: Color.fromARGB(255, 102, 97, 97),
        ),
        SizedBox(
          height: 12,
        )
      ],
    );
  }
}
