import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';

List<Pass> passes = [];

class PassNotifier extends StateNotifier<List<Pass>> {
  PassNotifier() : super([]);

  void addPass(Pass pass) {
    state = [...state, pass];
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

final passProvider = StateNotifierProvider<PassNotifier, List<Pass>>(
  (ref) => PassNotifier(),
);
