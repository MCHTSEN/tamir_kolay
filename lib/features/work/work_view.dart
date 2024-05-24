import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/work/work_viewmodel.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/service/firebase_service.dart';
import 'package:tamir_kolay/utils/enums/vehicle_status.dart';
import 'package:tamir_kolay/utils/theme/color_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkView extends ConsumerStatefulWidget {
  final Work workModel;
  const WorkView({required this.workModel, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WorkViewState();
}

class _WorkViewState extends ConsumerState<WorkView> with WorkViewModel {
  List<Task> tasks = [];
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    tasks = widget.workModel.task ?? [];
    expenses = widget.workModel.expense ?? [];
  }

  @override
  Widget build(BuildContext context) {
    print('workModel: ${widget.workModel.expense}');
    final generalTextTheme = context.general.textTheme.bodyLarge!.copyWith(
        fontSize: 16.8.sp, color: Theme.of(context).colorScheme.secondary);
    final work = widget.workModel;

    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _brandAndStatus(work, context),
                    _plateAndPhone(work, generalTextTheme, context),
                    Gap(2.h),
                    _problemText(generalTextTheme),
                    _issue(work, generalTextTheme, context),
                    Gap(2.h),
                    _tasksText(generalTextTheme),
                    _tasks(generalTextTheme),
                    Gap(2.h),
                    Text(
                      "Giderler",
                      style: generalTextTheme.copyWith(
                          fontSize: 18.5.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(2.w),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: addExpenseAmountController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              suffix: const Text('₺'),
                              label: const Text('Tutar'),
                              hintStyle: generalTextTheme,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Gap(2.w),
                        Expanded(
                          flex: 7,
                          child: TextField(
                            controller: addExpenseDetailController,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                hintText: 'Detaylari giriniz',
                                hintStyle: generalTextTheme,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                        ),
                        Gap(2.w),
                        IconButton(
                            onPressed: () {
                              if (addExpenseAmountController.text.isNotEmpty &&
                                  addExpenseDetailController.text.isNotEmpty) {
                                expenses.add(Expense(
                                    amount: int.parse(
                                        addExpenseAmountController.text),
                                    description:
                                        addExpenseDetailController.text));
                                addExpenseAmountController.clear();
                                addExpenseDetailController.clear();
                                setState(() {});
                              }
                            },
                            icon: const Icon(
                              Icons.add_circle_outline_sharp,
                              size: 30,
                            )),
                      ],
                    ),
                    Gap(1.h),
                    if (expenses.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 20.w,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${expenses[index].amount} ₺',
                                    style: generalTextTheme.copyWith(
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Text(
                                  expenses[index].description.toString(),
                                  style: generalTextTheme.copyWith(
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    Gap(10.h)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: context.padding.normal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (work.status == VehicleStatus.inProgress.name)
                      Expanded(
                        child: Padding(
                          padding: context.padding.low,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            label: const Text('Bitir',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: context.padding.low,
                        child: ElevatedButton(
                          onPressed: () {
                            work.task = tasks;
                            work.expense = expenses;
                            work.totalAmount = expenses
                                .map((e) => e.amount!)
                                .reduce((value, element) => value + element);

                            ref.read(workProvider.notifier).updateWork(work);
                            FirebaseService.instance.updateWork(work);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Kaydet',
                                style: TextStyle(color: Colors.black),
                              ),
                              Gap(1.w),
                              const Icon(
                                Icons.save_outlined,
                                color: Colors.black,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (work.status == VehicleStatus.waiting.name)
                      Expanded(
                        child: Padding(
                          padding: context.padding.low,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.refresh_outlined,
                            ),
                            label: const Text(
                              'Sonraki Adım',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Column _tasks(TextStyle generalTextTheme) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  if (addTaskController.text.isNotEmpty) {
                    tasks.add(Task(
                        description: addTaskController.text, isDone: false));
                    print(tasks);
                    addTaskController.clear();
                    setState(() {});
                  }
                },
                icon: const Icon(
                  Icons.add_circle_outline_sharp,
                  size: 30,
                )),
            Expanded(
              child: TextField(
                controller: addTaskController,
                decoration: InputDecoration(
                    hintText: 'Yeni işlem ekle',
                    hintStyle: generalTextTheme,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
          ],
        ),
        if (tasks.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Checkbox(
                    value: tasks[index].isDone,
                    onChanged: (value) {
                      tasks[index].isDone = value!;
                      print(tasks[index].isDone);
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text(
                      tasks[index].description.toString(),
                      style: generalTextTheme.copyWith(color: Colors.black),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Text _tasksText(TextStyle generalTextTheme) {
    return Text(
      "Yapılan İşlemler",
      style: generalTextTheme.copyWith(
          fontSize: 18.5.sp, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Padding _issue(Work work, TextStyle generalTextTheme, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Text(
        work.issue.toString(),
        style: generalTextTheme.copyWith(
            color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Text _problemText(TextStyle generalTextTheme) {
    return Text("Sorun",
        style: generalTextTheme.copyWith(
            fontSize: 18.5.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black));
  }

  Row _brandAndStatus(Work work, BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${work.model}',
            style: context.general.textTheme.headlineLarge!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 22.sp),
          ),
          Gap(1.w),
          Text(
            '/${work.brand}',
            style:
                context.general.textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _getStatusColor(work.status!),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              work.statusToString,
              style: TextStyle(
                color: _getStatusColor(work.status!),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  Padding _plateAndPhone(
      Work work, TextStyle generalTextTheme, BuildContext context) {
    const insidePadding = EdgeInsets.symmetric(horizontal: 5, vertical: 1);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: insidePadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
            child: Text(
              "${work.plate}".toUpperCase(),
              style: generalTextTheme.copyWith(fontSize: 15.sp),
            ),
          ),
          Gap(5.w),
          InkWell(
            onTap: () async {
              Clipboard.setData(ClipboardData(text: work.customerPhone!));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  content: Center(
                      child: Text(
                    'Numara kopyalandı!',
                    style: generalTextTheme.copyWith(color: Colors.white),
                  )),
                ),
              );
            },
            child: Container(
              padding: insidePadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "${work.customerPhone}".toUpperCase(),
                    style: generalTextTheme.copyWith(fontSize: 15.sp),
                  ),
                  Gap(1.w),
                  const Icon(
                    Icons.call,
                    size: 13,
                  ),
                ],
              ),
            ),
          ),
        ],
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
