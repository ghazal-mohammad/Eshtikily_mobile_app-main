import 'package:eshhtikiyl_app/features/complaints/complaint_api.dart';
import 'package:eshhtikiyl_app/features/complaints/complaint_model/complaint_model.dart';
import 'package:eshhtikiyl_app/features/complaints/complaint_model/location_model.dart';
import 'package:get/get.dart';

class ComplaintsController extends GetxController{
  RxBool loading = false.obs;
  ComplaintsModel? complaintsModel;
LocationModel ? locationModel;
  getComplaints()async{
    loading.value = true;
    complaintsModel = await ComplaintApi.getMyComplaints();
    print('kfdshkjdhgajsgggggggggggggggggggggggggggggggggggggggggg');
    loading.value = false;
  }

  addComlaint({
    required String departmentId,
    required String typeId,
    required String locationId,
    required String description,
    required String filePath,
  }) async {
    loading.value = true;
    bool getSuccess = await ComplaintApi.sendComplaintWithAttachment(departmentId: departmentId, typeId: typeId, locationId: locationId, description: description, filePath: filePath);
    loading.value = false;

  }
  @override
  void onInit() {
super.onInit();
getComplaints();
  }
}


class LocationsController extends GetxController {
  final locations = <LocationModel>[].obs;

  // ✅ هذا أهم سطر: متغير اختيار يسمح بـ null
  final Rxn<LocationModel> selected = Rxn<LocationModel>();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLocations();
  }

  Future<void> loadLocations() async {
    try {
      isLoading.value = true;
      final list = await ComplaintApi.getLocations(); // أو دالتك
      locations.assignAll(list);

      // اختياري: خليه أول عنصر مختار تلقائياً
      // if (locations.isNotEmpty) selected.value = locations.first;
    } finally {
      isLoading.value = false;
    }
  }
}
class DepartmentController extends GetxController {
  final departments = <DepartmentsModel>[].obs;

  // ✅ هذا أهم سطر: متغير اختيار يسمح بـ null
  final Rxn<DepartmentsModel> selected = Rxn<DepartmentsModel>();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDepartments();
  }

  Future<void> loadDepartments() async {
    try {
      isLoading.value = true;
      final list = await ComplaintApi.getDepartment(); // أو دالتك
      departments.assignAll(list);

      // اختياري: خليه أول عنصر مختار تلقائياً
      // if (locations.isNotEmpty) selected.value = locations.first;
    } finally {
      isLoading.value = false;
    }
  }
}
class TypesController extends GetxController {
  final types = <TypesModel>[].obs;

  // ✅ هذا أهم سطر: متغير اختيار يسمح بـ null
  final Rxn<TypesModel> selected = Rxn<TypesModel>();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDepartments();
  }

  Future<void> loadDepartments() async {
    try {
      isLoading.value = true;
      final list = await ComplaintApi.getTypes(); // أو دالتك
      types.assignAll(list);

      // اختياري: خليه أول عنصر مختار تلقائياً
      // if (locations.isNotEmpty) selected.value = locations.first;
    } finally {
      isLoading.value = false;
    }
  }
}
