import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/announcement_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentAnnouncementNotifier extends StateNotifier<List<Announcement>> {
  StudentAnnouncementNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> loadAnnouncementsFromDB() async {
    if (prefs?.getString("jwtToken") == null) {
      return;
    }
    try {
      var response = await http.get(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/student/block/getAnnouncement/${prefs!.getInt('blockNo')}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        throw responseData["message"];
      }
      List<Announcement> announcements = [];
      for (var announcement in responseData) {
        announcements.add(Announcement(
            announcementId: announcement["_id"],
            rtId: announcement["rtId"],
            title: announcement["title"],
            isBoysHostelRt: announcement['isBoysHostelRt'],
            message: announcement["message"],
            blockNo: announcement["blockNo"]));
      }
      state = announcements;
    } catch (err) {
      throw "student announcement error";
    }
  }
}

final studentAnnouncementNotifier =
    StateNotifierProvider<StudentAnnouncementNotifier, List<Announcement>>(
  (ref) => StudentAnnouncementNotifier(),
);
