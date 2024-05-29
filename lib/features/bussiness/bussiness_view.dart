import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/bussiness/bussiness_viewmodel.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/utils/extensions/double_extension.dart';
import 'package:tamir_kolay/utils/widgets/buttons/sign_out_button.dart';
import 'package:tamir_kolay/utils/widgets/charts/custom_chart.dart';
import 'package:tamir_kolay/utils/widgets/containers/basic_info_card.dart';
import 'package:tamir_kolay/utils/widgets/containers/clickable_info_container.dart';
import 'package:tamir_kolay/utils/widgets/listiles/custom_listile.dart';

class BussinessView extends ConsumerStatefulWidget {
  const BussinessView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BussinessViewState();
}

class _BussinessViewState extends ConsumerState<BussinessView>
    with BussinessViewModel, SingleTickerProviderStateMixin {
  bool isClickedEarnedMoney = false;

  @override
  Widget build(BuildContext context) {
    final works = ref.read(workProvider);
    initialize(works);
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: 50.h,
          width: 100.w,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Theme.of(context).colorScheme.secondary),
          child: Column(
            children: [Gap(6.h), _homeAndSignout(context), _charts()],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40.h),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BasicInfoCard(
                        width: 45.w,
                        text: 'Ortalama İş Bitirme Süresi',
                        text2: '$avarageHourToWorkDone saat',
                        icon: Icons.timelapse_sharp,
                      ),
                    ),
                    Gap(4.w),
                    Expanded(
                        child: BasicInfoCard(
                      width: 45.w,
                      text: 'Günlük Kazanç',
                      text2: '$dailyEarnedMoney₺',
                      icon: Icons.monetization_on_sharp,
                    )),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: Text('❋ Kazanç detayları için tıklayın',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                ),
                const Divider(),
                const CustomListTile(
                  title: 'Müşteriler',
                  pushName: '/customers',
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Row _charts() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomChart(
          height: 3.h,
          title: 'Tamamlanan İş',
          value: totalCompletedWorks,
        ),
        Gap(5.w),
        CustomChart(
            title: 'Aylık Kazanç',
            value: '${lastMonthEarnedMoney.toCurrency()}₺',
            height: 0),
        Gap(5.w),
        CustomChart(
          title: 'Tüm Zamanlar',
          value: '${totalEarnedMoney.toCurrency()}₺',
          height: 4.h,
        ),
      ],
    );
  }

  Row _homeAndSignout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            )),
        const SignoutButton(
          color: Colors.white,
        ),
      ],
    );
  }
}
