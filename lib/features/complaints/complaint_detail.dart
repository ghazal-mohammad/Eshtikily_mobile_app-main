import 'package:eshhtikiyl_app/models/complaint_display.dart';
import 'package:eshhtikiyl_app/features/complaints/edit_complaint.dart';
import 'package:flutter/material.dart';
import '../../models/complaint.dart';

class ComplaintDetailsPage extends StatelessWidget {
  final ComplaintDisplay complaint;

  const ComplaintDetailsPage({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(Icons.arrow_back,
            color: Colors.teal[400],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),        title: Row(
          children: [
            const Text(
              'تفاصيل الشكوى',
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
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(),
                const SizedBox(height: 20),

                _buildDetailCard(
                    'نوع الشكوى', complaint.type, Icons.report_problem),
                const SizedBox(height: 12),

                _buildDetailCard(
                    'الجهة المعنية', complaint.agency, Icons.business),
                const SizedBox(height: 12),

                _buildDetailCard(
                    'الموقع', complaint.location, Icons.location_on),
                const SizedBox(height: 12),

                _buildDetailCard(
                    'وصف المشكلة', complaint.description, Icons.description),
                const SizedBox(height: 20),

                if (complaint.extraInformation != null)
                  Column(
                    children: [
                      _buildDetailCard('معلومات إضافية',
                          complaint.extraInformation!, Icons.info_outline),
                      const SizedBox(height: 20),
                    ],
                  ),

                if (complaint.notesFromEmployee != null)
                  Column(
                    children: [
                      _buildDetailCard('ملاحظات الموظف',
                          complaint.notesFromEmployee!, Icons.notes),
                      const SizedBox(height: 20),
                    ],
                  ),

                if (complaint.images.isNotEmpty) _buildImagesSection(),

                const SizedBox(height: 20),

                if (complaint.docs.isNotEmpty) _buildDocumentsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: _getStatusBackgroundColor(complaint.status),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: _getStatusColor(complaint.status).withOpacity(0.3),
            width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getStatusIconData(complaint.status),
              color: _getStatusColor(complaint.status),
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'حالة الشكوى',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getArabicStatusText(complaint.status),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(complaint.status),
                    ),
                  ),
                  if (complaint.status ==
                      ComplaintStatus.requiresExtraInformation)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'هذه الشكوى تحتاج إلى معلومات إضافية',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.teal[100],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String content, IconData icon) {
    return Card(
      color: const Color(0xFF1A4A47), // ✅ أخضر أفتح
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal[300]!.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.teal[300], // ✅ أخضر فاتح بدل ذهبي
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.teal[100], // ✅ أخضر فاتح
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white, // ✅ أبيض على خلفية خضراء
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    return Card(
      color: const Color(0xFF1A4A47),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal[300]!.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الصور المرفقة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.teal[300], // ✅ أخضر فاتح
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: complaint.images
                  .where((image) => image != null)
                  .map((image) => GestureDetector(
                        onTap: () {
                          // يمكن إضافة عرض الصورة بحجم كامل هنا
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.teal[300]!.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              image!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.teal[300]!),
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(Icons.broken_image,
                                      color: Colors.teal[300]),
                                );
                              },
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Card(
      color: const Color(0xFF1A4A47),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal[300]!.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المستندات المرفقة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.teal[300],
              ),
            ),
            const SizedBox(height: 12),
            ...complaint.docs
                .where((doc) => doc != null)
                .map((doc) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.teal[300]!.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.teal[900]!.withOpacity(0.2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.insert_drive_file,
                              size: 24, color: Colors.teal[300]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              doc!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // يمكن إضافة تنزيل المستند هنا
                            },
                            icon: Icon(Icons.download,
                                size: 20, color: Colors.teal[300]),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIconData(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.newStatus:
        return Icons.new_releases;
      case ComplaintStatus.processing:
        return Icons.hourglass_empty;
      case ComplaintStatus.finished:
        return Icons.check_circle;
      case ComplaintStatus.rejected:
        return Icons.cancel;
      case ComplaintStatus.requiresExtraInformation:
        return Icons.warning_amber_rounded;
    }
  }

  String _getArabicStatusText(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.newStatus:
        return 'جديد';
      case ComplaintStatus.processing:
        return 'قيد المعالجة';
      case ComplaintStatus.finished:
        return 'مكتمل';
      case ComplaintStatus.rejected:
        return 'مرفوض';
      case ComplaintStatus.requiresExtraInformation:
        return 'يحتاج معلومات إضافية';
    }
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.newStatus:
        return Colors.blue[300]!;
      case ComplaintStatus.processing:
        return Colors.orange[300]!;
      case ComplaintStatus.finished:
        return Colors.green[300]!;
      case ComplaintStatus.rejected:
        return Colors.red[300]!;
      case ComplaintStatus.requiresExtraInformation:
        return Colors.yellow[300]!;
    }
  }

  Color _getStatusBackgroundColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.newStatus:
        return Colors.blue.withOpacity(0.1);
      case ComplaintStatus.processing:
        return Colors.orange.withOpacity(0.1);
      case ComplaintStatus.finished:
        return Colors.green.withOpacity(0.1);
      case ComplaintStatus.rejected:
        return Colors.red.withOpacity(0.1);
      case ComplaintStatus.requiresExtraInformation:
        return Colors.yellow.withOpacity(0.1);
    }
  }
}
