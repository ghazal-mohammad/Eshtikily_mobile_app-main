import 'package:eshhtikiyl_app/features/complaints/complaints_controller.dart';
import 'package:eshhtikiyl_app/models/complaint.dart';
import 'package:eshhtikiyl_app/models/complaint_display.dart';
import 'package:eshhtikiyl_app/features/complaints/complaint_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/logout_srevice.dart';

class ListComplaintsPage extends StatefulWidget {
  const ListComplaintsPage({super.key});

  @override
  State<ListComplaintsPage> createState() => _ListComplaintsPageState();
}

class _ListComplaintsPageState extends State<ListComplaintsPage> {
   ComplaintsController controller = Get.put(ComplaintsController());

  List<ComplaintDisplay> complaints = [
    ComplaintDisplay(
      uuid: 'cmp-001',
      type: 'شكوى ضوضاء',
      agency: 'بلدية دمشق',
      location: 'شارع بغداد - المزة',
      description:
          'وجود ضوضاء عالية من ورشة بناء تعمل حتى الساعة الثانية صباحاً',
      images: ['https://example.com/noise1.jpg'],
      status: ComplaintStatus.processing,
      notesFromEmployee: 'تم إرسال فرق التفتيش للموقع',
      extraInformation: 'يرجى تحديد وقت الضوضاء بدقة',
    ),
    ComplaintDisplay(
      uuid: 'cmp-002',
      type: 'مشكلة مرورية',
      agency: 'إدارة السير',
      location: 'تقاطع شارع النصر مع شارع القوتلي',
      description: 'إشارة مرور معطلة تسبب ازدحاماً مرورياً شديداً',
      images: [
        'https://example.com/traffic1.jpg',
        'https://example.com/traffic2.jpg'
      ],
      docs: ['تقرير_المرور.pdf'],
      status: ComplaintStatus.requiresExtraInformation,
      notesFromEmployee: 'مطلوب صور إضافية من زوايا مختلفة',
      extraInformation: null,
    ),
    ComplaintDisplay(
      uuid: 'cmp-003',
      type: 'تسرب مياه',
      agency: 'شركة مياه عدرا',
      location: 'حي الطبالة - أمام المدرسة الابتدائية',
      description: 'تسرب مياه مستمر من خط رئيسي لمدة 48 ساعة',
      images: ['https://example.com/water1.jpg'],
      status: ComplaintStatus.newStatus,
    ),
    ComplaintDisplay(
      uuid: 'cmp-004',
      type: 'انقطاع كهرباء',
      agency: 'شركة كهرباء ريف دمشق',
      location: 'حي القدم - المنطقة الصناعية',
      description: 'انقطاع متكرر للتيار الكهربائي 5 مرات يومياً',
      images: [],
      docs: ['فاتورة_الكهرباء.pdf', 'شهادة_المولد.pdf'],
      status: ComplaintStatus.finished,
      notesFromEmployee: 'تم إصلاح الخط وضبط التيار',
    ),
    ComplaintDisplay(
      uuid: 'cmp-005',
      type: 'تراكم نفايات',
      agency: 'شركة النظافة',
      location: 'حي الميدان - سوق الحريقة',
      description: 'تراكم النفايات لأكثر من أسبوع دون جمع',
      images: [
        'https://example.com/waste1.jpg',
        'https://example.com/waste2.jpg'
      ],
      status: ComplaintStatus.rejected,
      notesFromEmployee: 'الموقع خارج منطقة الخدمة',
    ),
    ComplaintDisplay(
      uuid: 'cmp-006',
      type: 'تضرر أرصفة',
      agency: 'مديرية الطرق',
      location: 'شارع 29 أيار - أمام المستشفى الوطني',
      description: 'أرصفة متضررة تشكل خطراً على المشاة',
      images: ['https://example.com/sidewalk1.jpg'],
      docs: ['تقرير_الهندسة.pdf'],
      status: ComplaintStatus.processing,
    ),
    ComplaintDisplay(
      uuid: 'cmp-007',
      type: 'إعلانات مخالفة',
      agency: 'دائرة الإعلانات',
      location: 'وسط مدينة دمشق - ساحة الأمويين',
      description: 'إعلانات غير مرخصة تعيق الرؤية وتشوه المنظر العام',
      images: [
        'https://example.com/ad1.jpg',
        'https://example.com/ad2.jpg',
        'https://example.com/ad3.jpg'
      ],
      status: ComplaintStatus.requiresExtraInformation,
      extraInformation: 'مطلوب صور توضح أبعاد الإعلانات',
    ),
    ComplaintDisplay(
      uuid: 'cmp-008',
      type: 'حفر طرق',
      agency: 'وزارة الأشغال العامة',
      location: 'طريق المطار - بالقرب من الجسر',
      description: 'حفر في الطريق العام دون إشارات تحذيرية',
      images: ['https://example.com/hole1.jpg'],
      status: ComplaintStatus.finished,
      notesFromEmployee: 'تم إصلاح الحفر ووضع التحذيرات اللازمة',
    ),
  ];

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
              'شكواي',
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
      body:Obx(() =>
        controller.loading==true? CircularProgressIndicator(): Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.complaintsModel!.data.complaints.length,
          itemBuilder: (context, index) {
            var complaint =  controller.complaintsModel!.data.complaints[index];

            return _buildComplaintCard(ComplaintDisplay(type: complaint.type.name, agency: complaint.department.name, location:complaint.location.name, description: complaint.description), context);
          },
        ),
      ),)
    );
  }

  Widget _buildComplaintCard(ComplaintDisplay complaint, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: const Color(0xFF1A4A47),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal[300]!.withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _getStatusIcon(complaint.status),
        title: Text(
          complaint.type,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Almarai',
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.teal[200]),
                const SizedBox(width: 4),
                Text(
                  complaint.location,
                  style: TextStyle(
                    color: Colors.teal[100],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(complaint.status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _getStatusColor(complaint.status).withOpacity(0.5),
                ),
              ),
              child: Text(
                _getArabicStatusText(complaint.status),
                style: TextStyle(
                  color: _getStatusColor(complaint.status),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.teal[300],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComplaintDetailsPage(complaint: complaint),
            ),
          );
        },
      ),
    );
  }

  Icon _getStatusIcon(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.newStatus:
        return Icon(Icons.new_releases, color: Colors.blue[300]);
      case ComplaintStatus.processing:
        return Icon(Icons.hourglass_empty, color: Colors.orange[300]);
      case ComplaintStatus.finished:
        return Icon(Icons.check_circle, color: Colors.green[300]);
      case ComplaintStatus.rejected:
        return Icon(Icons.cancel, color: Colors.red[300]);
      case ComplaintStatus.requiresExtraInformation:
        return Icon(Icons.warning_amber_rounded, color: Colors.yellow[300]);
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
}
