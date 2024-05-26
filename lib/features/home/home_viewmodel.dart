import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamir_kolay/features/home/home_view.dart';

mixin HomeViewModel on ConsumerState<HomeView> {
  int selectedIndex = 0;
  int selectedTab = 2;
  BottomNavigationBar HomeBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Ödemeler'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Kayıt Aç'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
      ],
      currentIndex: selectedTab,
      onTap: (index) {
        print('index: $index selectedIndex: $selectedIndex');
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
    );
  }
}
