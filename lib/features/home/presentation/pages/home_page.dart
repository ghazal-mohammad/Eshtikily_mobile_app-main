import 'package:eshhtikiyl_app/features/home/presentation/pages/more_tab.dart';
import 'package:flutter/material.dart';

import '../../../complaints/complaint_list.dart';
import '../../../complaints/create_complaint.dart';
import '../../../profile/presentation/pages/show_profile_page.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ListComplaintsPage(),
    CreateComplaintPage(),
    NotificationsPage(),
    MoreTab(),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
