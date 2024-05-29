import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamir_kolay/features/bussiness/bussiness_view.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/utils/enums/date_type.dart';

mixin BussinessViewModel on ConsumerState<BussinessView> {
  double totalEarnedMoney = 0;
  double totalExpenses = 0;
  double lastWeekEarnedMoney = 0;
  double lastMonthEarnedMoney = 0;
  String totalCompletedWorks = '0';
  double avarageHourToWorkDone = 0;
  double dailyEarnedMoney = 0;

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

    lastMonthEarnedMoney = calculateLastMonthEarnedMoney(works);

    lastWeekEarnedMoney = calculateLastWeekEarnedMoney(works);

    avarageHourToWorkDone = calculateAvarageHourToWorkDone(works);

    dailyEarnedMoney = calculateDailyEarnedMoney(works);
  }

  bool isWithinGivenDate(
    String dateString,
    DateType dateType,
  ) {
    final period = switch (dateType) {
      DateType.lastMonth => 30,
      DateType.lastWeek => 7,
      DateType.today => 1,
    };

    if (dateString.isEmpty) return false;

    // Verilen stringi DateTime formatına çeviriyoruz
    DateTime givenDate = DateTime.parse(dateString);

    // Şu anki zamanı alıyoruz
    DateTime now = DateTime.now();

    // Verilen tarih kadar onceki zamanı alıyoruz
    DateTime oneMonthAgo = now.subtract(Duration(days: period));

    // Verilen tarihin içinde olup olmadığını kontrol ediyoruz
    return givenDate.isAfter(oneMonthAgo) && givenDate.isBefore(now);
  }

  double calculateDailyEarnedMoney(List<Work> works) {
    final filteredWorks = works
        .where((element) =>
            element.status == 'done' &&
            isSameDay(element.endTime ?? '', DateTime.now().toString()))
        .toList();

    if (filteredWorks.isEmpty) return 0.0;

    return filteredWorks
        .map((e) => e.totalAmount!)
        .reduce((value, element) => value + element)
        .toDouble();
  }

  double calculateLastWeekEarnedMoney(List<Work> works) {
    final filteredWorks = works
        .where((element) =>
            element.status == 'done' &&
            isWithinGivenDate(element.endTime ?? '', DateType.lastWeek))
        .toList();

    // Eğer filteredWorks boş ise, toplam kazanç 0 olarak ayarlanır
    if (filteredWorks.isEmpty) {
      return 0.0;
    }

    return filteredWorks
        .map((e) => e.totalAmount!)
        .reduce((value, element) => value + element)
        .toDouble();
  }

  double calculateLastMonthEarnedMoney(List<Work> works) {
    final filteredWorks = works
        .where((element) =>
            element.status == 'done' &&
            isWithinGivenDate(element.endTime ?? '', DateType.lastMonth))
        .toList();

    // Eğer filteredWorks boş ise, toplam kazanç 0 olarak ayarlanır
    if (filteredWorks.isEmpty) {
      return 0.0;
    }

    return filteredWorks
        .map((e) => e.totalAmount!)
        .reduce((value, element) => value + element)
        .toDouble();
  }

  double calculateAvarageHourToWorkDone(List<Work> works) {
    final filteredWorks = works
        .where((element) =>
            element.status == 'done' && element.endTime!.isNotEmpty)
        .toList();

    if (filteredWorks.isEmpty) {
      return 0.0;
    }

    double totalHours = 0;

    for (var work in filteredWorks) {
      totalHours +=
          calculateHourDifference(work.endTime ?? '', work.createTime ?? '');
    }

    return totalHours / filteredWorks.length;
  }

  double calculateHourDifference(String startDateString, String endDateString) {
    DateTime startDate = DateTime.parse(startDateString);
    DateTime endDate = DateTime.parse(endDateString);

    Duration difference = endDate.difference(startDate);

    return difference.inHours.toDouble();
  }

  bool isSameDay(String dateTimeString1, String dateTimeString2) {
    if(dateTimeString1.isEmpty) return false;
    DateTime dateTime1 = DateTime.parse(dateTimeString1);
    DateTime dateTime2 = DateTime.parse(dateTimeString2);

    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }
}
