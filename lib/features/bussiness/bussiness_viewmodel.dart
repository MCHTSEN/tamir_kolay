import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamir_kolay/features/bussiness/bussiness_view.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';

mixin BussinessViewModel on ConsumerState<BussinessView> {
  double totalEarnedMoney = 0;
  double totalExpenses = 0;
  String totalCompletedWorks = '0';

  void initialize(List<Work> works) {
    final works = ref.read(workProvider);
    totalEarnedMoney = works
        .map((e) => e.totalAmount!)
        .reduce((value, element) => value + element)
        .toDouble();

    totalExpenses = works
        .map((e) => e.totalAmount!)
        .reduce((value, element) => value + element)
        .toDouble();

    totalCompletedWorks = works
        .where((element) => element.status == 'done')
        .toList()
        .length
        .toString();
  }
}
