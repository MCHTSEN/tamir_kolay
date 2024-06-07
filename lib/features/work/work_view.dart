import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/work/work_viewmodel.dart';
import 'package:tamir_kolay/models/job_model.dart';
import 'package:tamir_kolay/providers/works_provider.dart';
import 'package:tamir_kolay/service/firebase_service.dart';
import 'package:tamir_kolay/service/gemini_service.dart';
import 'package:tamir_kolay/utils/animations/ai_loading_animation.dart';
import 'package:tamir_kolay/utils/animations/bouncing_dots_animation.dart';
import 'package:tamir_kolay/utils/animations/sizing_dot_animation.dart';
import 'package:tamir_kolay/utils/enums/vehicle_status.dart';
import 'package:tamir_kolay/utils/extensions/double_extension.dart';
import 'package:tamir_kolay/utils/widgets/texts/gradient_text.dart';

class WorkView extends ConsumerStatefulWidget {
  Work workModel;
  WorkView({required this.workModel, super.key});

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
    final generalTextTheme = context.general.textTheme.bodyLarge!
        .copyWith(fontSize: 14.sp, color: Colors.grey[800]);
    final work = widget.workModel;
    return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              margin: EdgeInsets.only(right: 3.w),
              decoration: BoxDecoration(
                color: _getStatusColor(work.status!),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _getStatusColor(work.status!),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                work.statusToString,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _brandAndStatus(work, context),
                    const Gap(5),
                    _plateAndPhone(work, generalTextTheme, context),
                    Gap(2.h),
                    _issueText(generalTextTheme, context),
                    _issue(work, generalTextTheme, context),
                    Gap(2.h),
                    _tasksText(generalTextTheme),
                    _tasks(generalTextTheme),
                    Gap(2.h),
                    _expensesText(generalTextTheme),
                    _addExpense(generalTextTheme),
                    Gap(1.h),
                    if (expenses.isNotEmpty) _expenses(generalTextTheme),
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
                            icon: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            label: const Text('Bitir',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      padding: EdgeInsets.all(6.w),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'İşçilik Ücreti Giriniz',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(fontSize: 18.sp),
                                          ),
                                          Gap(2.h),
                                          TextField(
                                            controller: addLabourCostController,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              suffix: const Text('₺'),
                                              label: const Text('Tutar'),
                                              hintStyle: generalTextTheme,
                                            ),
                                          ),
                                          Gap(2.h),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (addLabourCostController
                                                  .text.isNotEmpty) {
                                                work.status =
                                                    VehicleStatus.done.name;
                                                work.endTime =
                                                    DateTime.now().toString();
                                                work.lobourCost = int.parse(
                                                    addLabourCostController
                                                        .text);
                                                work.totalAmount = int.parse(
                                                        addLabourCostController
                                                            .text) +
                                                    expenses.fold(
                                                        0,
                                                        (previousValue,
                                                                element) =>
                                                            previousValue +
                                                            element.amount!);

                                                await FirebaseService.instance
                                                    .updateWork(work);

                                                ref
                                                    .read(workProvider.notifier)
                                                    .updateWork(work);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }
                                            },
                                            child: const Text('Kaydet'),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    if (work.status == VehicleStatus.done.name)
                      Expanded(
                        child: Container(
                          height: 7.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onTertiary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(
                              'Bu iş tamamlandı',
                              style: generalTextTheme.copyWith(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (work.status == VehicleStatus.waiting.name)
                      Expanded(
                        child: Padding(
                          padding: context.padding.low,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              FirebaseService.instance.updateStatus(
                                  work.id!, VehicleStatus.inProgress);
                              work.status = VehicleStatus.inProgress.name;
                              ref.read(workProvider.notifier).updateWork(work);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.refresh_outlined,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Sonraki Adım',
                              style: TextStyle(color: Colors.black),
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

  Text _expensesText(TextStyle generalTextTheme) {
    return Text(
      "Giderler",
      style: generalTextTheme.copyWith(
          fontSize: 17.sp, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Row _addExpense(TextStyle generalTextTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Yeni Gider Ekle',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontSize: 18.sp),
                          ),
                          Gap(2.h),
                          TextField(
                            controller: addExpenseDetailController,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              hintText: 'Conta takımı',
                              label: const Text('Gider Detayı Giriniz'),
                              hintStyle: generalTextTheme,
                            ),
                          ),
                          Gap(2.h),
                          TextField(
                            controller: addExpenseAmountController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              suffix: const Text('₺'),
                              label: const Text('Masraf Tutarı Giriniz'),
                              hintStyle: generalTextTheme,
                            ),
                          ),
                          Gap(2.h),
                          ElevatedButton(
                              onPressed: () async {
                                if (addExpenseAmountController
                                        .text.isNotEmpty &&
                                    addExpenseDetailController
                                        .text.isNotEmpty) {
                                  expenses.add(Expense(
                                      amount: int.parse(
                                          addExpenseAmountController.text),
                                      description:
                                          addExpenseDetailController.text));
                                  widget.workModel.expense = expenses;
                                  // widget.workModel += int.tryParse(
                                  //         addExpenseAmountController.text) ??
                                  //     0;
                                  await FirebaseService.instance
                                      .updateWork(widget.workModel);
                                  // await FirebaseService.instance.updateExpenses(
                                  //     expenses: expenses,
                                  //     workId: widget.workModel.id!);
                                  addExpenseAmountController.clear();
                                  addExpenseDetailController.clear();
                                  setState(() {});
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Ekle'))
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
            label: Text(
              'Yeni Gider Ekle',
              style: generalTextTheme,
            )),
      ],
    );
  }

  ListView _expenses(TextStyle generalTextTheme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondary)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text(
                        expenses[index].description.toString(),
                        style: generalTextTheme.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(11),
                          topRight: Radius.circular(11),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          '${expenses[index].amount!.toDouble().toCurrency()} ₺',
                          style: generalTextTheme.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
                highlightColor: Colors.blue,
                onPressed: () async {
                  expenses.removeAt(index);
                  await FirebaseService.instance.updateExpenses(
                      expenses: expenses, workId: widget.workModel.id!);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ))
          ],
        );
      },
    );
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
                    FirebaseService.instance.updateTasks(
                        tasks: tasks, workId: widget.workModel.id!);
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: tasks[index].isDone,
                    onChanged: (value) {
                      tasks[index].isDone = value!;
                      FirebaseService.instance.updateTasks(
                          tasks: tasks, workId: widget.workModel.id!);
                      setState(() {});
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Text(
                        tasks[index].description.toString(),
                        style: generalTextTheme.copyWith(color: Colors.black),
                      ),
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
          fontSize: 17.sp, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Padding _issue(Work work, TextStyle generalTextTheme, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Text(
        work.issue.toString(),
        style:
            generalTextTheme.copyWith(color: Colors.grey[800], fontSize: 14.sp),
      ),
    );
  }

  Row _issueText(TextStyle generalTextTheme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Sorun",
            style: generalTextTheme.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        InkWell(
          onTap: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                      child: Container(
                    padding: EdgeInsets.all(4.w),
                    child: FutureBuilder(
                        future: GeminiService()
                            .generateContent(widget.workModel.issue!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: BouncingDotsAnimation(),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Bir hata oluştu'),
                            );
                          }
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Yapay Zeka Asistan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(fontSize: 18.sp),
                                    ),
                                    Gap(2.w),
                                    Image.asset(
                                      'assets/icons/ic_gemini.png',
                                      width: 20,
                                      height: 20,
                                    )
                                  ],
                                ),
                                Gap(2.h),
                                Text(
                                  snapshot.data.toString(),
                                  style: generalTextTheme.copyWith(
                                      fontSize: 14.sp, color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }),
                  ));
                });
          },
          child: Row(
            children: [
              const Image(
                image: AssetImage(
                  'assets/icons/ic_gemini.png',
                ),
                width: 18,
                height: 18,
              ),
              Gap(0.7.w),
              const GradientText(
                'Yapay zekaya danış',
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0D47A1), // Gemini Blue
                    Color(0xFF42A5F5), // Light Blue
                    Color(0xFF7E57C2), // Medium Purple
                    Color(0xFF29B6F6), // Light Sky Blue
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _brandAndStatus(Work work, BuildContext context) {
    return Row(children: [
      Text(
        '${work.model}',
        style: context.general.textTheme.headlineLarge!
            .copyWith(fontWeight: FontWeight.w600, fontSize: 22.sp),
      ),
      Gap(1.w),
      Text(
        '/${work.brand}',
        style: context.general.textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
      ),
    ]);
  }

  Row _plateAndPhone(
      Work work, TextStyle generalTextTheme, BuildContext context) {
    const insidePadding = EdgeInsets.symmetric(horizontal: 5, vertical: 1);
    return Row(
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
            style: generalTextTheme.copyWith(fontSize: 14.sp),
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
                  style: generalTextTheme.copyWith(fontSize: 14.sp),
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

