import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/work/work_view.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/utils/enums/vehicle_status.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedIndex = 0;
  int selectedTab = 2;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/bussiness');
            },
            icon: const Icon(Icons.home_work)),
        title: const Text("Tamir Kolay"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/auth');
            },
          ),
        ],
      ),
      body: Padding(
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
                    child: Text('Henüz bir işlem yok.\n Hadi ise başlayalım!'),
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

  ListView _workCards() {
    return ListView.builder(
      itemCount: ref.watch(workProvider).length,
      itemBuilder: (context, index) {
        final work = ref.watch(workProvider)[index];
        return _tabName[_selectedIndex] != work.status
            ? const SizedBox()
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
                          _brandAndModel(work, context),
                          const Spacer(),
                          _statusAndDate(work, context),
                        ],
                      ),
                      Gap(1.h),
                      _issue(work, context),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Row _brandAndModel(Work work, BuildContext context) {
    return Row(
      children: [
        Text(
          '${work.model}'.toUpperCase(),
          style: context.general.textTheme.headlineMedium!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 19.sp),
        ),
        Gap(1.w),
        Text(
          work.brand.toString(),
          style: context.general.textTheme.bodyLarge!.copyWith(fontSize: 15.sp),
        ),
      ],
    );
  }

  Text _issue(Work work, BuildContext context) {
    return Text(
      work.issue.toString(),
      style: context.general.textTheme.bodyLarge!.copyWith(fontSize: 16.sp),
    );
  }

  Column _statusAndDate(Work work, BuildContext context) {
    return Column(
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
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            work.statusToString,
            style: TextStyle(
              fontSize: 13.sp,
              color: _getStatusColor(work.status!),
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
