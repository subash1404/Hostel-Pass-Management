import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RtPassRequestNotifier extends StateNotifier<List<Pass>> {
  RtPassRequestNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
}
