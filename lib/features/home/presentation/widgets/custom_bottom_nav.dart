import 'package:flutter/material.dart';
import '../models/bottom_nav_item.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  static const List<BottomNavItem> _items = [
    BottomNavItem(
        icon: Icons.list_alt,
        activeIcon: Icons.list_alt_rounded,
        label: "الشكاوى"),
    BottomNavItem(
        icon: Icons.add_circle_outline,
        activeIcon: Icons.add_circle,
        label: "إضافة"),
    BottomNavItem(
        icon: Icons.notifications_outlined,
        activeIcon: Icons.notifications,
        label: "إشعارات"),
    BottomNavItem(
        icon: Icons.more_horiz,
        activeIcon: Icons.more_horiz,
        label: "المزيد"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1CA7B),
        borderRadius: BorderRadius.circular(70),
      ),
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = currentIndex == index;

          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive ? item.activeIcon : item.icon,
                    color: isActive
                        ? const Color(0xFF0A3C3A)
                        : Colors.white70,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFF0A3C3A)
                          : Colors.white70,
                      fontSize: 12,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
