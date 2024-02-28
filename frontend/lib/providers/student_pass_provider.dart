import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentPassNotifier extends StateNotifier<List<Pass>> {
  StudentPassNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> loadPassFromDB() async {
    if (prefs!.getString("jwtToken") == null) {
      return;
    }

    try {
      var response = await http.get(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/getPass"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      List<Pass> passes = [];
      for (var pass in responseData["data"]) {
        passes.add(
          Pass(
            passId: pass["passId"],
            studentId: pass["studentId"],
            qrId: pass["qrId"],
            status: pass["status"],
            destination: pass["destination"],
            type: pass["type"],
            isActive: pass["isActive"],
            reason: pass["reason"],
            expectedInDate: pass["expectedInDate"],
            expectedInTime: pass["expectedInTime"],
            expectedOutDate: pass["expectedOutDate"],
            expectedOutTime: pass["expectedOutTime"],
          ),
        );
      }
      state = passes;
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<void> addPass({
    required String destination,
    required String type,
    required String reason,
    required String inDate,
    required String inTime,
    required String outDate,
    required String outTime,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/newPass"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
        body: jsonEncode(
          {
            "studentId": prefs!.getString("studentId"),
            "destination": destination,
            "type": type,
            "reason": reason,
            "inDate": inDate,
            "inTime": inTime,
            "outDate": outDate,
            "outTime": outTime,
          },
        ),
      );
      var responseData = jsonDecode(response.body);

      state = [
        ...state,
        Pass(
          passId: responseData["passId"],
          studentId: prefs!.getString("studentId")!,
          qrId: responseData["qrId"],
          status: responseData["status"],
          destination: responseData["destination"],
          type: responseData["type"],
          isActive: responseData["isActive"],
          reason: responseData["reason"],
          expectedInDate: responseData["inDate"],
          expectedInTime: responseData["inTime"],
          expectedOutDate: responseData["outDate"],
          expectedOutTime: responseData["outTime"],
        )
      ];
    } catch (e) {
      throw "Something went wrong";
    }
  }

  void deletePass(String passId) {
    state = state.where((pass) => pass.passId != passId).toList();
  }

  Pass? getActivePass() {
    final activePass = state.where((pass) => pass.isActive).toList();
    if (activePass.isEmpty) {
      return null;
    }
    return activePass[0];
  }
}

final studentPassProvider =
    StateNotifierProvider<StudentPassNotifier, List<Pass>>(
  (ref) => StudentPassNotifier(),
);
