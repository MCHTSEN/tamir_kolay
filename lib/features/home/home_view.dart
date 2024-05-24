import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/vehicle_registration/vehicle_registration_view.dart';
import 'package:tamir_kolay/features/work/work_view.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/service/firebase_service.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedIndex = 0;
  int selectedTab = 2;
  final List<String> _tabs = ["Devam Eden", "Yeni", "Biten"];

  @override
  void initState() {
    super.initState();
    ref.watch(workProvider.notifier).getWorks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tamir Kolay"),
      ),
      body: Column(
        children: [
          Row(
            children: List.generate(
              _tabs.length,
              (index) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: FilterChip(
                  label: Text(_tabs[index]),
                  selected: _selectedIndex == index,
                  onSelected: (selected) {
                    setState(() {
                      _selectedIndex =
                          selected ? index : 0; // set to null when not selected
                    });
                  },
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: ref.watch(workProvider.notifier).getWorks(),
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
                  child: Text('Henüz bir işlem yok.\n Hadi ise başlayalım!'),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: ref.watch(workProvider).length,
                  itemBuilder: (context, index) {
                    final work = ref.watch(workProvider)[index];
                    return GestureDetector(
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
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${work.model}'.toUpperCase(),
                                      style: context
                                          .general.textTheme.headlineMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20.sp),
                                    ),
                                    Gap(1.w),
                                    Text(
                                      work.brand.toString(),
                                      style: context
                                          .general.textTheme.bodyLarge!
                                          .copyWith(fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: _getStatusColor(work.status!),
                                          width: 1.5,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        work.statusToString,
                                        style: TextStyle(
                                          color: _getStatusColor(work.status!),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      work.createTime
                                          .toString()
                                          .substring(0, 10),
                                      style: context
                                          .general.textTheme.bodyLarge!
                                          .copyWith(fontSize: 14.sp),
                                    ),
                                    const Gap(3),
                                  ],
                                ),
                              ],
                            ),
                            Gap(1.h),
                            Text(
                              work.issue.toString(),
                              style: context.general.textTheme.bodyLarge!
                                  .copyWith(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Ödemeler'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Kayıt Aç'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
        ],
        currentIndex: selectedTab,
        onTap: (index) {
          print('index: $index selectedIndex: $_selectedIndex');
          if (index != selectedTab) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/payment');
                break;
              case 1:
                Navigator.pushNamed(context, '/registration');
                break;
              case 2:
                Navigator.pushNamed(context, '/home');
                break;
            }
          }
        },
      ),
    );
  }

  _getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return Theme.of(context).colorScheme.primary;
      case 'done':
        return Theme.of(context).colorScheme.tertiary;
      case 'inProgress':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Colors.black;
    }
  }
}
