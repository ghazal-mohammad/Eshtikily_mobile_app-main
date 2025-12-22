import 'package:flutter/material.dart';
import '../../../../core/utils/local_noti_storage.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifs = await LocalNotificationStorage.getNotifications();
    setState(() {
      _notifications = notifs.reversed.toList();
    });
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final dateFormat = DateFormat('HH:mm', 'ar_AE');
    final dateFormatFull = DateFormat('d MMMM HH:mm', 'ar_AE');

    if (time.year == now.year &&
        time.month == now.month &&
        time.day == now.day) {
      return 'اليوم ${dateFormat.format(time)}';
    } else {
      return dateFormatFull.format(time);
    }
  }

  Future<void> _deleteNotification(int index) async {
    final removedNotification = _notifications[index];
    setState(() {
      _notifications.removeAt(index);
    });
    await LocalNotificationStorage.saveNotifications(_notifications.reversed.toList());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حذف الإشعار'),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () async {
            setState(() {
              _notifications.insert(index, removedNotification);
            });
            await LocalNotificationStorage.saveNotifications(_notifications.reversed.toList());
          },
          textColor: Colors.yellowAccent,
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showNotificationDetails(String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF144D4A),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.right,
        ),
        content: Text(
          body,
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إغلاق',
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'الاشعارات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(168, 10, 60, 58),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF0F2E2B),
      body: _notifications.isEmpty
          ? const Center(
        child: Text(
          'لا توجد إشعارات',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notif = _notifications[index];
          final title = notif['title'] ?? '';
          final body = notif['body'] ?? '';
          final time = notif['receivedAt'] != null
              ? DateTime.parse(notif['receivedAt'])
              : DateTime.now();

          return Dismissible(
            key: Key(notif['receivedAt'] ?? index.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            onDismissed: (direction) async {
              await _deleteNotification(index);
            },
            child: Card(
              color: const Color(0xFF1A5B57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 6,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _showNotificationDetails(title, body),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 14),
                        decoration: BoxDecoration(
                          color: Colors.teal[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 10,),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              body,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 15,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _formatTime(time),
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
