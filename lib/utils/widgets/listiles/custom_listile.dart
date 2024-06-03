import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const CustomListTile({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      trailing:
          IconButton(onPressed: onTap, icon: const Icon(Icons.chevron_right)),
    );
  }
}
