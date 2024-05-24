import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/service/firebase_service.dart';

final workProvider = StateNotifierProvider<WorkNotifier, List<Work>>((ref) {
  return WorkNotifier();
});

class WorkNotifier extends StateNotifier<List<Work>> {
  WorkNotifier() : super([]);

  Future<void> getWorks() async {
    state = await FirebaseService.instance.getAllWorks();
  }

  void setState(List<Work> state) {
    state = state;
  }

  void addWork(Work work) {
    state = [...state, work];
  }

  void updateWork(Work work) {
    state = state.map((e) => e.id == work.id ? work : e).toList();
  }
}
