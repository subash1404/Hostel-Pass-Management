import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double starRating = 0;
  final TextEditingController feedbackController = TextEditingController();
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Future<void> submitFeedback() async {
      if (feedbackController.text.isEmpty) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter  your feedback."),
          ),
        );
        return;
      }
      if (starRating == 0) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please rate the app."),
          ),
        );
        return;
      }
      try {
        var response = await http.post(
          Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/feedback/newFeedback"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": prefs!.getString("jwtToken")!,
          },
          body: jsonEncode({
            "feedback": feedbackController.text,
            "rating": starRating,
          }),
        );

        var responseData = jsonDecode(response.body);

        if (response.statusCode >= 400) {
          throw responseData["message"];
        }

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData["message"],
            ),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/images/feedback.svg",
                  width: MediaQuery.of(context).size.width - 100,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Every word you share helps us build a better experience. We're all ears for your feedback! 🌟",
                style: textTheme.titleMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: feedbackController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Your Feedback",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                glow: true,
                glowColor: Colors.amber,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    starRating = rating;
                  });
                },
              ),
              const SizedBox(height: 30),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: submitFeedback,
                child: Ink(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: MediaQuery.of(context).size.width - 200,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Submit Feedback",
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
