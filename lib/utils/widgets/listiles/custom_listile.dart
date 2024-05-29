import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String pushName;
  const CustomListTile({
    super.key,
    required this.title,
    required this.pushName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(context, pushName),
      title: Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      trailing: IconButton(
          onPressed: () => Navigator.pushNamed(context, pushName),
          icon: const Icon(Icons.chevron_right)),
    );
  }
}
