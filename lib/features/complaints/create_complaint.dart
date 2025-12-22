import 'dart:io';
import 'package:eshhtikiyl_app/features/complaints/complaints_controller.dart';
import 'package:eshhtikiyl_app/widgets/gold_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/utils/toast_services.dart';
import '../../models/complaint.dart';
import 'complaint_model/location_model.dart';
final List<PlatformFile> selectedAttachments = [];

class CreateComplaintPage extends StatefulWidget {
  const CreateComplaintPage({super.key});

  @override
  State<CreateComplaintPage> createState() => _CreateComplaintPageState();
}

class _CreateComplaintPageState extends State<CreateComplaintPage> {
  ComplaintsController complaintsController = Get.put(ComplaintsController());
  LocationsController controller = Get.put(LocationsController());
 DepartmentController departmentController =Get.put(DepartmentController());
  TypesController  typesController=Get.put(TypesController());
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _agencyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<XFile?> _selectedImages = [];
  final List<FilePickerResult?> _selectedDocuments = [];
  // final List<PlatformFile?> selectedAttachments = [];

  bool _isSubmitting = false;
int selectedType = 0;
int selectedDepartment = 0;
int selectedLocation = 0;
  @override
  void dispose() {
    _typeController.dispose();
    _agencyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  // Future<void> _pickDocuments() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //     allowMultiple: true,
  //   );
  //   if (result != null) {
  //     setState(() {
  //       _selectedDocuments.add(result);
  //       result.files.path
  //     });
  //   }
  // }
  Future<void> _pickDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedDocuments.add(result);
        selectedAttachments.addAll(result.files);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeDocument(int index) {
    setState(() {
      _selectedDocuments.removeAt(index);
    });
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate() && !_isSubmitting) {
      setState(() => _isSubmitting = true);

      try {
        final complaint = Complaint(
          type: _typeController.text.trim(),
          agency: _agencyController.text.trim(),
          location: _locationController.text.trim(),
          description: _descriptionController.text.trim(),
          images: _selectedImages,
          docs: _selectedDocuments,
        );

        // TODO: استدعاء API هنا
        complaintsController.addComlaint(departmentId: selectedDepartment.toString(), typeId: selectedType.toString(), locationId: selectedLocation.toString(), description: _descriptionController.text, filePath: "");
        await Future.delayed(const Duration(seconds: 1));

        ToastService.showSuccess(context, "تم إنشاء الشكوى بنجاح");
        Navigator.pop(context, complaint);
      } catch (e) {
        ToastService.showError(context, "فشل في إنشاء الشكوى: $e");
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
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
              'تقديم شكوى',
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  // نوع الشكوى
                  // _buildTextField(
                  //   controller: _typeController,
                  //   label: 'نوع الشكوى *',
                  //   hint: 'مثال: ضوضاء، مشكلة مرورية، كهرباء',
                  //   icon: Icons.report_problem,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'يرجى إدخال نوع الشكوى';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 16),
                  //
                  // // الجهة المعنية
                  // _buildTextField(
                  //   controller: _agencyController,
                  //   label: 'الجهة المعنية *',
                  //   hint: 'مثال: البلدية، إدارة السير، الكهرباء',
                  //   icon: Icons.business,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'يرجى إدخال الجهة المعنية';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 16),


              Obx(() {
                return DropdownButtonFormField<TypesModel>(
                  dropdownColor: Colors.teal[800],

                  value: typesController.selected.value,
                  // hint: const Text('اختر جهة'),
                  icon: const Icon(Icons.arrow_drop_down),
                  decoration: InputDecoration(
                    labelText: 'نوع الشكوى',
                    labelStyle:  TextStyle(color: Colors.teal[300]),
                    prefixIcon:  Icon(Icons.report_problem,color: Colors.teal[300]),
                    filled: true,
                    fillColor:Colors.teal[900]!.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal.shade700,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal.shade700,
                        width: 1.5,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal.shade900,
                        width: 2,
                      ),
                    ),
                  ),
                  items: typesController.types.map((location) {
                    return DropdownMenuItem<TypesModel>(
                      value: location,
                      child: Text(
                        location.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    typesController.selected.value = value;
                    selectedType = typesController.selected.value!.id;
                  },
                );
              }),
                  const SizedBox(height: 16),
  Obx(() {
                return DropdownButtonFormField<DepartmentsModel>(
                  dropdownColor: Colors.teal[800],

                  value: departmentController.selected.value,
                  // hint: const Text('اختر جهة'),
                  icon: const Icon(Icons.arrow_drop_down),
                  decoration: InputDecoration(
                    labelText: 'الجهة المعنية',
                    labelStyle:  TextStyle(color: Colors.teal[300]),
                    prefixIcon:  Icon(Icons.business,color: Colors.teal[300]),
                    filled: true,
                    fillColor:Colors.teal[900]!.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal.shade700,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal.shade700,
                        width: 1.5,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal.shade900,
                        width: 2,
                      ),
                    ),
                  ),
                  items: departmentController.departments.map((location) {
                    return DropdownMenuItem<DepartmentsModel>(
                      value: location,
                      child: Text(
                        location.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    departmentController.selected.value = value;
                    selectedDepartment =departmentController.selected.value!.id;
                  },
                );
              }),
                  const SizedBox(height: 16),

                  Obx(() {
                return DropdownButtonFormField<LocationModel>(
                  dropdownColor: Colors.teal[800],

                  value: controller.selected.value,
                  // hint: const Text('اختر الموقع'),
                  icon: const Icon(Icons.arrow_drop_down),
                  decoration: InputDecoration(
                    labelText: 'الموقع',
                    labelStyle:  TextStyle(color: Colors.teal[300]),
                    prefixIcon:  Icon(Icons.location_on,color: Colors.teal[300]),
                    filled: true,
                    fillColor:Colors.teal[900]!.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal.shade700,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal.shade700,
                        width: 1.5,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal.shade900,
                        width: 2,
                      ),
                    ),
                  ),
                  items: controller.locations.map((location) {
                    return DropdownMenuItem<LocationModel>(
                      value: location,
                      child: Text(
                        location.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selected.value = value;
                    selectedLocation =controller.selected.value!.id ;
                  },
                );
              }),


              // الموقع
              //     _buildTextField(
              //       controller: _locationController,
              //       label: 'الموقع *',
              //       hint: 'مثال: وسط المدينة، الشارع الرئيسي',
              //       icon: Icons.location_on,
              //       validator: (value) {
              //         if (value == null || value.isEmpty) {
              //           return 'يرجى إدخال الموقع';
              //         }
              //         return null;
              //       },
              //     ),
                  const SizedBox(height: 16),

                  // الوصف
                  _buildTextArea(
                    controller: _descriptionController,
                    label: 'وصف المشكلة *',
                    hint: 'صف مشكلتك بالتفصيل...',
                    icon: Icons.description,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال وصف المشكلة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // قسم الصور
                  _buildCardSection(
                    title: 'الصور (اختياري)',
                    icon: Icons.photo,
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImages,
                          icon: const Icon(Icons.add_a_photo, color: Colors.white),
                          label: const Text('إضافة صور', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[400], // ✅ أخضر فاتح
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_selectedImages.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(_selectedImages.length, (index) {
                              return _buildImagePreview(index);
                            }),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // قسم المستندات
                  _buildCardSection(
                    title: 'المستندات (اختياري)',
                    icon: Icons.attach_file,
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickDocuments,
                          icon: const Icon(Icons.attach_file, color: Colors.white),
                          label: const Text('إضافة مستندات', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[400],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_selectedDocuments.isNotEmpty) ..._selectedDocuments.map(_buildDocumentItem).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر الإرسال
                  SizedBox(
                    width: double.infinity,
                    child: GoldButton(
                      label: _isSubmitting ? 'جاري الإرسال...' : 'إنشاء الشكوى',
                      onTap: _isSubmitting ? null : _submitComplaint,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white), // ✅ نص أبيض
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal[300]),
        // ✅ أخضر فاتح
        hintText: hint,
        hintStyle: TextStyle(color: Colors.teal[100]!.withOpacity(0.7)),
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
        prefixIcon: Icon(icon, color: Colors.teal[300]),
        filled: true,
        fillColor: Colors.teal[900]!.withOpacity(0.2), // ✅ خلفية خضراء داكنة شفافة
      ),
      validator: validator,
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: 4,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal[300]),
        hintText: hint,
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
        prefixIcon: Icon(icon, color: Colors.teal[300]),
        filled: true,
        fillColor: Colors.teal[900]!.withOpacity(0.2),
      ),
      validator: validator,
    );
  }

  Widget _buildCardSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      color: const Color(0xFF1A4A47), // ✅ أخضر أفتح
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal[300]!.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal[300], size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    final image = _selectedImages[index];
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.teal[300]!.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(image!.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem(FilePickerResult? doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal[300]!.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.teal[900]!.withOpacity(0.2),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file, size: 20, color: Colors.teal[300]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              doc?.files.first.name ?? 'مستند',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          IconButton(
            onPressed: () => _removeDocument(_selectedDocuments.indexOf(doc)),
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
