import 'package:eshhtikiyl_app/models/complaint.dart';
import 'package:flutter/material.dart';
import '../../models/complaint_display.dart';
import '../../widgets/gold_btn.dart';

class EditComplaintPage extends StatefulWidget {
  final ComplaintDisplay complaint;

  const EditComplaintPage({super.key, required this.complaint});

  @override
  State<EditComplaintPage> createState() => _EditComplaintPageState();
}

class _EditComplaintPageState extends State<EditComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _extraInformationController;

  @override
  void initState() {
    super.initState();
    _extraInformationController = TextEditingController(
      text: widget.complaint.extraInformation ?? '',
    );
  }

  @override
  void dispose() {
    _extraInformationController.dispose();
    super.dispose();
  }

  void _updateComplaint() {
    if (_formKey.currentState!.validate()) {
      final updatedComplaint = ComplaintDisplay(
        uuid: widget.complaint.uuid,
        type: widget.complaint.type,
        agency: widget.complaint.agency,
        location: widget.complaint.location,
        description: widget.complaint.description,
        status: ComplaintStatus.requiresExtraInformation,
        extraInformation: _extraInformationController.text.trim().isNotEmpty
            ? _extraInformationController.text.trim()
            : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث الشكوى بنجاح!'),
          backgroundColor: Colors.teal[400],
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, updatedComplaint);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
            color: Colors.teal[400],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),        title:
            const Text('تعديل الشكوى', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(168, 10, 60, 58),
        foregroundColor: Colors.white,
        elevation: 4,
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  _buildTextField(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: GoldButton(
                      label: 'تحديث الشكوى',
                      onTap: _updateComplaint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.teal[900]!.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal[300]!.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.teal[300],
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات الحالة',
                    style: TextStyle(
                      color: Colors.teal[100],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'الحالة: ${_getArabicStatusText(widget.complaint.status)}\n'
                    'يمكنك إضافة المعلومات الإضافية المطلوبة',
                    style: TextStyle(
                      color: Colors.teal[50],
                      fontSize: 12,
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

  Widget _buildTextField() {
    return TextFormField(
      controller: _extraInformationController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'المعلومات الإضافية المطلوبة',
        labelStyle: TextStyle(color: Colors.teal[300]),
        hintText: 'أضف المعلومات الإضافية المطلوبة...',
        hintStyle: TextStyle(color: Colors.teal[100]!.withOpacity(0.7)),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal[300]!.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal[300]!, width: 2),
        ),
        prefixIcon: Icon(Icons.info_outline, color: Colors.teal[300]),
        filled: true,
        fillColor: Colors.teal[900]!.withOpacity(0.2),
      ),
      maxLines: 5,
      minLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال المعلومات الإضافية';
        }
        return null;
      },
    );
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
}
