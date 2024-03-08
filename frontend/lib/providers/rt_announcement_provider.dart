import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/announcement_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RtAnnoucementNotifier extends StateNotifier<List<Announcement>> {
  RtAnnoucementNotifier() : super([]);
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
            announcementId: annoucement["_id"],
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
      print(responseData);
      state = [
        ...state,
        Announcement(
          announcementId: responseData["_id"],
          title: responseData["title"],
          message: responseData["message"],
          blockNo: responseData["blockNo"],
          rtId: responseData["rtId"],
        )
      ];
    } catch (e) {
      throw "posting error";
    }
  }

  Future<void> deleteAnnouncement({
    required String announcementId,
  }) async {
    try {
      var response = await http.delete(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/block/deleteAnnouncement/$announcementId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );
      var responseData = jsonDecode(response.body);
      state = state
          .where(
              (announcement) => announcement.announcementId != announcementId)
          .toList();
    } catch (e) {
      throw "Something went wrong";
    }
  }
}

final rtAnnouncementNotifier =
    StateNotifierProvider<RtAnnoucementNotifier, List<Announcement>>(
  (ref) => RtAnnoucementNotifier(),
);
