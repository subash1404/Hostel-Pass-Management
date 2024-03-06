import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WardenPassRequestsNotifier extends StateNotifier<List<PassRequest>> {
  WardenPassRequestsNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> getSpecailPassesFromDB() async {
    if (prefs!.getString("jwtToken") == null) {
      return;
    }
    try {
      var response = await http.get(
          Uri.parse(
              "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/getPass"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": prefs!.getString("jwtToken")!
          });
      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        throw responseData["message"];
      }
      List<PassRequest> specialPasses = [];
      for (var pass in responseData) {
        specialPasses.add(PassRequest(
          passId: pass["passId"],
          qrId: pass["qrId"],
          studentId: pass["studentId"],
          status: pass["status"],
          destination: pass["destination"],
          type: pass["type"],
          isActive: pass["isActive"],
          reason: pass["reason"],
          expectedInDate: pass["expectedInDate"],
          expectedInTime: pass["expectedInTime"],
          expectedOutDate: pass["expectedOutDate"],
          expectedOutTime: pass["expectedOutTime"],
          isSpecialPass: pass["isSpecialPass"],
          studentName: pass["studentName"],
          dept: pass["dept"],
          fatherPhNo: pass["fatherPhNo"],
          motherPhNo: pass["motherPhNo"],
          phNo: pass["phNo"],
          roomNo: pass["roomNo"],
          year: pass["year"],
          blockNo: pass["blockNo"],
        ));
      }
      state = specialPasses;
    } catch (err) {
      throw "Something went wrong";
    }
  }
}

final specialPassProvider =
    StateNotifierProvider<WardenPassRequestsNotifier, List<PassRequest>>(
        (ref) => WardenPassRequestsNotifier());
