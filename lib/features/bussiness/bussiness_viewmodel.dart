import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamir_kolay/features/bussiness/bussiness_view.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/service/firebase_service.dart';
import 'package:tamir_kolay/utils/enums/date_type.dart';
import 'package:tamir_kolay/utils/enums/vehicle_status.dart';

mixin BussinessViewModel on ConsumerState<BussinessView> {
  double totalEarnedMoney = 0;
  double lastMonthEarnedMoney = 0;
  String totalCompletedWorks = '0';
  double avarageHourToWorkDone = 0;
  double dailyEarnedMoney = 0;
  String avarageHourToWorkDoneAsString = '';
  Map<String, double> monthlyRate = {};
  double mounthlyEarnedMoney = 0;
  double mounthlyWorksDone = 0;
  double weeklyRate = 0;

  Future<void> initialize(List<Work> works) async {
    final works = ref.read(workProvider);

    totalCompletedWorks = calculateTotalCompletedWorks(works);

    totalEarnedMoney = calculatedtotalEarnedMoney(works);

    lastMonthEarnedMoney = calculateLastMonthEarnedMoney(works);

    avarageHourToWorkDone = calculateAvarageHourToWorkDone(works);

    avarageHourToWorkDoneAsString = avarageHourToWorkDone.toStringAsFixed(2);

    dailyEarnedMoney = calculateDailyEarnedMoney(works);


    mounthlyEarnedMoney = monthlyRate['compareEarnedAmount'] ?? 0;
    mounthlyWorksDone = monthlyRate['compareWorksCount'] ?? 0;
    setState(() {});
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

  String calculateTotalCompletedWorks(List<Work> works) {
    final filteredWorks = works
        .where((element) => element.status == VehicleStatus.done.name)
        .toList();

    if (filteredWorks.isEmpty) return '0';

    return works
        .where((element) => element.status == VehicleStatus.done.name)
        .toList()
        .length
        .toString();
  }

  // double compareMonthlyAmounts(){
    
  // }

  double calculateDailyEarnedMoney(List<Work> works) {
    final filteredWorks = works
        .where((element) =>
            element.status == VehicleStatus.done.name &&
            isSameDay(element.endTime ?? '', DateTime.now().toString()))
        .toList();

    if (filteredWorks.isEmpty) return 0.0;

    return filteredWorks
        .map((e) => e.totalAmount!)
        .reduce((value, element) => value + element)
        .toDouble();
  }

  double calculatedtotalEarnedMoney(List<Work> works) {
    final filteredWorks = works
        .where((element) => element.status == VehicleStatus.done.name)
        .toList();
    if (filteredWorks.isEmpty) return 0.0;

    return filteredWorks
        .map((e) => e.totalAmount!)
        .reduce((value, element) => value + element)
        .toDouble();
  }

  double calculateLastMonthEarnedMoney(List<Work> works) {
    final filteredWorks = works
        .where((element) =>
            element.status == VehicleStatus.done.name &&
            isSameMonth(element.endTime ?? '', DateTime.now().toString()))
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
            element.status == VehicleStatus.done.name &&
            element.endTime!.isNotEmpty)
        .toList();

    if (filteredWorks.isEmpty) {
      return 0.0;
    }

    double totalHours = 0;

    for (var work in filteredWorks) {
      totalHours +=
          calculateHourDifference(work.createTime ?? '', work.endTime ?? '');
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
    if (dateTimeString1.isEmpty) return false;
    DateTime dateTime1 = DateTime.parse(dateTimeString1);
    DateTime dateTime2 = DateTime.parse(dateTimeString2);

    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }

  bool isSameMonth(String dateTimeString1, String dateTimeString2) {
    if (dateTimeString1.isEmpty) return false;
    DateTime dateTime1 = DateTime.parse(dateTimeString1);
    DateTime dateTime2 = DateTime.parse(dateTimeString2);

    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month;
  }
}
