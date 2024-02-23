import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double starRating = 0;
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    void submitFeedback() {
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

      print(starRating);
      print(feedbackController.text);
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
              SizedBox(height: 20),
              Text(
                "Every word you share helps us build a better experience. We're all ears for your feedback! 🌟",
                style: textTheme.titleMedium,
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              TextField(
                controller: feedbackController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Your Feedback",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                glow: true,
                glowColor: Colors.amber,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    starRating = rating;
                  });
                },
              ),
              SizedBox(height: 30),
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
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
