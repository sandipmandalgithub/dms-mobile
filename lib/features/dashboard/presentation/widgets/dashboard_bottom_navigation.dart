import 'package:flutter/material.dart';

class DashboardBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DashboardBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.folder_outlined),
      activeIcon: Icon(Icons.folder_rounded),
      label: 'Documents',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.approval_outlined),
      activeIcon: Icon(Icons.approval_rounded),
      label: 'Approvals',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline_rounded),
      activeIcon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: _items,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF2457D6),
      unselectedItemColor: const Color(0xFF718096),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      elevation: 10,
    );
  }
}
