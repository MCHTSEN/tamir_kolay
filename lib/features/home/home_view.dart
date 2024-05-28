import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/home/home_viewmodel.dart';
import 'package:tamir_kolay/features/work/work_view.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/utils/enums/vehicle_status.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with HomeViewModel {
  final List<String> _tabs = ["Devam Eden", "Yeni", "Biten"];
  final List<String> _tabName = [
    VehicleStatus.inProgress.name,
    VehicleStatus.waiting.name,
    VehicleStatus.done.name
  ];
  @override
  void initState() {
    super.initState();
    getWorks();
  }

  Future<void> getWorks() async {
    await ref.read(workProvider.notifier).getWorks();
    print('getWorks triggered.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/bussiness');
              },
              icon: const Icon(Icons.home_work)),
        ],
        title: const Text("Tamir Kolay"),
      ),
      body: LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 400,
        showChildOpacityTransition: false,
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          await getWorks();
        },
        child: Padding(
          padding: context.padding.low,
          child: Column(
            children: [
              _statusChips(),
              FutureBuilder(
                future: getWorks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Bir hata oluştu. Lütfen tekrar deneyin.'),
                    );
                  }
                  if (snapshot.hasData) {
                    return const Center(
                      child:
                          Text('Henüz bir işlem yok.\n Hadi ise başlayalım!'),
                    );
                  }
                  return Expanded(
                    child: _workCards(),
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(context),
    );
  }

  ListView _workCards() {
    final works = ref.read(workProvider);
    return ListView.builder(
      itemCount: works.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final work = works[index];
        return _tabName[selectedIndex] != work.status
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkView(
                        workModel: work,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _brandAndModel(work, context),
                              Gap(1.h),
                              _issue(work, context),
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _statusAndDate(work, context),
                            ],
                          )),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Row _brandAndModel(Work work, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${work.model}'.toUpperCase(),
          style: context.general.textTheme.headlineMedium!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
        Gap(1.w),
        Text(
          work.plate.toString(),
          style: context.general.textTheme.bodyLarge!.copyWith(fontSize: 15.sp),
        ),
      ],
    );
  }

  Text _issue(Work work, BuildContext context) {
    return Text(
      work.issue.toString(),
      style: context.general.textTheme.bodyLarge!.copyWith(fontSize: 14.sp),
    );
  }

  Column _statusAndDate(Work work, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _getStatusColor(work.status!),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _getStatusColor(work.status!),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            work.statusToString,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          work.createTime.toString().substring(0, 10),
          style: context.general.textTheme.bodyLarge!.copyWith(fontSize: 14.sp),
        ),
        const Gap(3),
      ],
    );
  }

  Row _statusChips() {
    return Row(
      children: List.generate(
        _tabs.length,
        (index) => Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FilterChip(
            checkmarkColor: Colors.white,
            color: MaterialStateColor.resolveWith((states) =>
                selectedIndex == index
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onPrimary),
            label: Text(
              _tabs[index],
              style: TextStyle(
                  color: selectedIndex == index ? Colors.white : Colors.black),
            ),
            selected: selectedIndex == index,
            onSelected: (selected) {
              setState(() {
                selectedIndex =
                    selected ? index : 0; // set to null when not selected
              });
            },
          ),
        ),
      ),
    );
  }

  _getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return Theme.of(context).colorScheme.primary;
      case 'done':
        return Theme.of(context).colorScheme.onTertiary;
      case 'inProgress':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Colors.black;
    }
  }
}
