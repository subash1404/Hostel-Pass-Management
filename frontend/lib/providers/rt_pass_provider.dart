import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RtPassRequestsNotifier extends StateNotifier<List<PassRequest>> {
  RtPassRequestsNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> loadPassRequestsFromDB() async {
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

      List<PassRequest> passRequests = [];
      for (var pass in responseData["data"]) {
        passRequests.add(
          PassRequest(
            // Parent Class Constructor parameters
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

            // This Class Constructor parameters
            studentName: pass["studentName"],
            dept: pass["dept"],
            fatherPhNo: pass["fatherPhNo"],
            motherPhNo: pass["motherPhNo"],
            phNo: pass["phNo"],
            roomNo: pass["roomNo"],
            blockNo: pass["blockNo"],
            year: pass["year"],
          ),
        );
      }
      state = passRequests;
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<void> approvePassRequest(String passId) async {
    if (prefs?.getString == null) {
      return;
    }
    try {
      var response = await http.post(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/approvePass/$passId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );
      var reponseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        return reponseData["message"];
      }
      int passIndex = state.indexWhere((pass) => pass.passId == passId);
      if (passIndex != -1) {
        PassRequest updatedPass = PassRequest(
          passId: state[passIndex].passId,
          qrId: state[passIndex].qrId,
          studentId: state[passIndex].studentId,
          status: 'Approved',
          destination: state[passIndex].destination,
          type: state[passIndex].type,
          isActive: state[passIndex].isActive,
          reason: state[passIndex].reason,
          expectedInDate: state[passIndex].expectedInDate,
          expectedInTime: state[passIndex].expectedInTime,
          expectedOutDate: state[passIndex].expectedOutDate,
          expectedOutTime: state[passIndex].expectedOutTime,
          isSpecialPass: state[passIndex].isSpecialPass,
          studentName: state[passIndex].studentName,
          dept: state[passIndex].dept,
          fatherPhNo: state[passIndex].fatherPhNo,
          motherPhNo: state[passIndex].motherPhNo,
          phNo: state[passIndex].phNo,
          roomNo: state[passIndex].roomNo,
          blockNo: state[passIndex].blockNo,
          year: state[passIndex].year,
        );
        state[passIndex] = updatedPass;
      }
      state = [...state];
    } catch (err) {
      throw "Something went wrong";
    }
  }

  Future<void> rejectPassRequest(String passId) async {
    if (prefs?.getString == null) {
      return;
    }
    try {
      var response = await http.post(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/rejectPass/$passId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );
      var reponseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        return reponseData["message"];
      }
      int passIndex = state.indexWhere((pass) => pass.passId == passId);
      if (passIndex != -1) {
        PassRequest updatedPass = PassRequest(
          passId: state[passIndex].passId,
          qrId: state[passIndex].qrId,
          studentId: state[passIndex].studentId,
          status: 'Rejected',
          destination: state[passIndex].destination,
          type: state[passIndex].type,
          isActive: false,
          reason: state[passIndex].reason,
          expectedInDate: state[passIndex].expectedInDate,
          expectedInTime: state[passIndex].expectedInTime,
          expectedOutDate: state[passIndex].expectedOutDate,
          expectedOutTime: state[passIndex].expectedOutTime,
          isSpecialPass: state[passIndex].isSpecialPass,
          studentName: state[passIndex].studentName,
          dept: state[passIndex].dept,
          fatherPhNo: state[passIndex].fatherPhNo,
          motherPhNo: state[passIndex].motherPhNo,
          phNo: state[passIndex].phNo,
          roomNo: state[passIndex].roomNo,
          blockNo: state[passIndex].blockNo,
          year: state[passIndex].year,
        );
        state[passIndex] = updatedPass;
      }
      state = [...state];
    } catch (err) {
      throw "Something went wrong";
    }
  }
}

final rtPassProvider =
    StateNotifierProvider<RtPassRequestsNotifier, List<PassRequest>>(
  (ref) => RtPassRequestsNotifier(),
);
