import 'package:tamir_kolay/utils/enums/vehicle_status.dart';

class Work {
  String? id;
  String? brand;
  String? model;
  String? modelYear;
  String? customerName;
  String? customerPhone;
  String? issue;
  String? plate;
  String? kilometer;
  String? tcNo;
  String? createTime;
  String? endTime;
  String? status;
  List<Task>? task;
  List<Expense>? expense;
  bool? isPaid;
  int? totalAmount;

  Work({
    this.id,
    this.brand,
    this.model,
    this.modelYear,
    this.customerName,
    this.customerPhone,
    this.issue,
    this.plate,
    this.kilometer,
    this.tcNo,
    this.createTime,
    this.endTime,
    this.status,
    this.task,
    this.expense,
    this.isPaid,
    this.totalAmount,
  });

  String get statusToString {
    switch (status) {
      case 'waiting':
        return 'Beklemede';
      case 'inProgress':
        return 'Devam Ediyor';
      case 'done':
        return 'Tamamlandı';
      default:
        return 'Beklemede';
    }
  }

  Work copyWith({
    String? id,
    String? brand,
    String? model,
    String? modelYear,
    String? customerName,
    String? customerPhone,
    String? issue,
    String? plate,
    String? kilometer,
    String? tcNo,
    String? createTime,
    String? endTime,
    String? status,
    List<Task>? task,
    List<Expense>? expense,
    bool? isPaid,
    int? totalAmount,
  }) {
    return Work(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      modelYear: modelYear ?? this.modelYear,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      issue: issue ?? this.issue,
      plate: plate ?? this.plate,
      kilometer: kilometer ?? this.kilometer,
      tcNo: tcNo ?? this.tcNo,
      createTime: createTime ?? this.createTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      task: task ?? this.task,
      expense: expense ?? this.expense,
      isPaid: isPaid ?? this.isPaid,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'modelYear': modelYear,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'issue': issue,
      'plate': plate,
      'kilometer': kilometer,
      'tcNo': tcNo,
      'createTime': createTime,
      'endTime': endTime,
      'status': status,
      'tasks': task?.map((task) => task.toJson()).toList(),
      'expenses': expense?.map((expense) => expense.toJson()).toList(),
      'isPaid': isPaid,
      'totalAmount': totalAmount,
    };
  }

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      id: json['id'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      modelYear: json['modelYear'] as String?,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      issue: json['issue'] as String?,
      plate: json['plate'] as String?,
      kilometer: json['kilometer'] as String?,
      tcNo: json['tcNo'] as String?,
      createTime: json['createTime'] as String?,
      endTime: json['endTime'] as String?,
      status: json['status'] as String?,
      task: (json['task'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      expense: (json['expense'] as List<dynamic>?)
          ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPaid: json['isPaid'] as bool?,
      totalAmount: json['totalAmount'] as int?,
    );
  }

  @override
  String toString() =>
      "Work(id: $id,brand: $brand,model: $model,modelYear: $modelYear,customerName: $customerName,customerPhone: $customerPhone,issue: $issue,plate: $plate,kilometer: $kilometer,tcNo: $tcNo,createTime: $createTime,endTime: $endTime,status: $status,task: $task,expense: $expense,isPaid: $isPaid,totalAmount: $totalAmount)";

  @override
  int get hashCode => Object.hash(
      id,
      brand,
      model,
      modelYear,
      customerName,
      customerPhone,
      issue,
      plate,
      kilometer,
      tcNo,
      createTime,
      endTime,
      status,
      task,
      expense,
      isPaid,
      totalAmount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Work &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          brand == other.brand &&
          model == other.model &&
          modelYear == other.modelYear &&
          customerName == other.customerName &&
          customerPhone == other.customerPhone &&
          issue == other.issue &&
          plate == other.plate &&
          kilometer == other.kilometer &&
          tcNo == other.tcNo &&
          createTime == other.createTime &&
          endTime == other.endTime &&
          status == other.status &&
          task == other.task &&
          expense == other.expense &&
          isPaid == other.isPaid &&
          totalAmount == other.totalAmount;
}

class Task {
  String? description;
  bool? isDone;

  Task({
    this.description,
    this.isDone,
  });

  Task copyWith({
    String? description,
    bool? isDone,
  }) {
    return Task(
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'isDone': isDone,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      description: json['description'] as String?,
      isDone: json['isDone'] as bool?,
    );
  }

  @override
  String toString() => "Task(description: $description,isDone: $isDone)";

  @override
  int get hashCode => Object.hash(description, isDone);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          isDone == other.isDone;
}

class Expense {
  String? description;
  int? amount;

  Expense({
    this.description,
    this.amount,
  });

  Expense copyWith({
    String? description,
    int? amount,
  }) {
    return Expense(
      description: description ?? this.description,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      description: json['description'] as String?,
      amount: json['amount'] as int?,
    );
  }

  @override
  String toString() => "Expense(description: $description,amount: $amount)";

  @override
  int get hashCode => Object.hash(description, amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          amount == other.amount;
}
