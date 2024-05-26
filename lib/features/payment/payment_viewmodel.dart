import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/payment/payment_view.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/utils/extensions/double_extension.dart';

mixin PaymentViewModel on State<PaymentView> {
  double calculateTotalAmount(List<Work> works) {
    return works.fold<double>(
        0, (previousValue, element) => previousValue + element.totalAmount!);
  }

  double calculateTotalPaidAmount(List<Work> works) {
    return works.fold<double>(
        0,
        (previousValue, element) =>
            previousValue + (element.isPaid! ? element.totalAmount! : 0));
  }

  BottomAppBar customBottomAppBar(
      double totalPaidAmount, TextStyle generalTextTheme, double totalAmount) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: Container(
            child: Text('Alınan Ödeme: \n ${totalPaidAmount.toCurrency()}₺',
                textAlign: TextAlign.center,
                style: generalTextTheme.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp)),
          )),
          const VerticalDivider(
            color: Colors.white,
            thickness: 1,
          ),
          Expanded(
            child: Container(
                child: Text(
                    'Bekleyen Ödeme: \n ${(totalAmount - totalPaidAmount).toCurrency()}₺',
                    textAlign: TextAlign.center,
                    style: generalTextTheme.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp))),
          ),
        ],
      ),
    );
  }
}
