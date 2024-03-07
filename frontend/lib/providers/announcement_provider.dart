import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/announcement_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AnnoucementNotifier extends StateNotifier<List<Announcement>> {
  AnnoucementNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> loadAnnouncementsFromDB() async {
    if (prefs?.getString("jwtToken") == null) {
      return;
    }
    try {
      var response = await http.get(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/block/getAnnouncement/${prefs!.getInt('permanentBlock')}"),
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
      for (var annoucement in responseData) {
        announcements.add(Announcement(
            rtId: annoucement["rtId"],
            title: annoucement["title"],
            message: annoucement["message"],
            blockNo: annoucement["blockNo"]));
      }
      state = announcements;
    } catch (err) {
      throw "annoucement error";
    }
  }

  Future<void> makeAnnouncement({
    required String title,
    required String message,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/block/postAnnouncement"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
        body: jsonEncode(
          {
            "title": title,
            "rtId": prefs!.getString("rtId"),
            "message": message,
            "blockNo": prefs!.getInt("permanentBlock"),
          },
        ),
      );
      var responseData = jsonDecode(response.body);
      state = [
        ...state,
        Announcement(
          title: responseData["title"],
          message: responseData["message"],
          blockNo: responseData["blockNo"],
          rtId: responseData["rtId"],
        )
      ];
    } catch (e) {
      throw "Something went wrong";
    }
  }
}

final announcementNotifier =
    StateNotifierProvider<AnnoucementNotifier, List<Announcement>>(
  (ref) => AnnoucementNotifier(),
);
