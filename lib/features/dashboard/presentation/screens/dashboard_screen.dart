import 'package:flutter/material.dart';

import '../../../documents/presentation/screens/documents_screen.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_recent_documents.dart';
import '../widgets/dashboard_bottom_navigation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  Widget _buildCurrentPage() {
    if (_currentIndex == 0) {
      return _buildHomeDashboard();
    }

    if (_currentIndex == 1) {
      return const DocumentsScreen();
    }

    final pages = ['Home', 'My Documents', 'Approvals', 'My Profile'];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.construction_rounded,
            size: 55,
            color: Color(0xFF2457D6),
          ),
          const SizedBox(height: 16),
          Text(
            '${pages[_currentIndex]} Coming Soon',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This section is under development.',
            style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(userName: 'Sandip'),
          const SizedBox(height: 28),
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.25,
            children: const [
              DashboardStatCard(
                title: 'Total Documents',
                value: '128',
                icon: Icons.folder_copy_outlined,
                color: Color(0xFF2457D6),
              ),
              DashboardStatCard(
                title: 'Pending Approvals',
                value: '12',
                icon: Icons.pending_actions_rounded,
                color: Color(0xFFEA9B24),
              ),
              DashboardStatCard(
                title: 'Approved Documents',
                value: '96',
                icon: Icons.verified_outlined,
                color: Color(0xFF16A36A),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const DashboardQuickActions(),
          const SizedBox(height: 28),
          const DashboardRecentDocuments(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: _currentIndex == 1
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'DMS Mobile',
                style: TextStyle(
                  color: Color(0xFF172B4D),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF172B4D),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFE8EEFF),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF2457D6),
                    ),
                  ),
                ),
              ],
            ),
      body: SafeArea(child: _buildCurrentPage()),
      bottomNavigationBar: DashboardBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
