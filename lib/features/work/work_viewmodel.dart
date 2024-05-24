import 'package:flutter/material.dart';
import 'package:tamir_kolay/features/work/work_view.dart';
import 'package:tamir_kolay/models/job_model.dart';

mixin WorkViewModel on State<WorkView> {
  final TextEditingController addTaskController= TextEditingController();
  final TextEditingController addExpenseAmountController= TextEditingController(); 
  final TextEditingController addExpenseDetailController= TextEditingController(); 
  final List<Work> _works = [];
  List<Work> get works => _works;
}
