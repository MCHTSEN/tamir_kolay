import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamir_kolay/providers/works_provider.dart';

class CustomersView extends ConsumerStatefulWidget {
  const CustomersView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomersViewState();
}

class _CustomersViewState extends ConsumerState<CustomersView> {
  @override
  Widget build(BuildContext context) {
    final customers = ref.read(workProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Müşteriler'),
        ),
        body: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            return customers[index].customerName == null
                ? const SizedBox()
                : ListTile(
                    title:
                        Text(customers[index].customerName ?? 'Isim Girilmedi'),
                    subtitle: Text(
                        customers[index].customerPhone ?? 'Telefon Girilmedi'),
                  );
          },
        ));
  }
}
