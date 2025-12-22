import 'dart:convert';

import 'package:eshhtikiyl_app/features/complaints/complaint_model/complaint_model.dart';
import 'package:eshhtikiyl_app/features/complaints/complaint_model/location_model.dart';
import 'package:eshhtikiyl_app/features/complaints/create_complaint.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/utils/auth_storage.dart';

class ComplaintApi{
  static Future<ComplaintsModel?>getMyComplaints()async{
    var token  = await AuthStorage.getAuthToken();
    print('token is : $token');

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('GET', Uri.parse('${ApiConstants.baseUrl}/citizen/myComplaints'));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
var data = (await response.stream.bytesToString());
    print('Data is : $data');

    if (response.statusCode == 200) {
      return ComplaintsModel.fromJson(json.decode(data));
    }
    else {
      print(response.reasonPhrase);
    }

  }
  static Future<List<LocationModel>> getLocations() async {
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await AuthStorage.getAuthToken()}',
    };

    final url = Uri.parse('${ApiConstants.baseUrl}/general/locations');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      final List list = decoded['data'];

      return list
          .map((e) => LocationModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load locations: ${response.statusCode}');
    }
  }
  static Future<List<DepartmentsModel>> getDepartment() async {
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await AuthStorage.getAuthToken()}',
    };

    final url = Uri.parse('${ApiConstants.baseUrl}/general/departments');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      final List list = decoded['data'];

      return list
          .map((e) => DepartmentsModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load departments: ${response.statusCode}');
    }
  }
  static Future<List<TypesModel>> getTypes() async {
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await AuthStorage.getAuthToken()}',
    };

    final url = Uri.parse('${ApiConstants.baseUrl}/general/types');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      final List list = decoded['data'];

      return list
          .map((e) => TypesModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load departments: ${response.statusCode}');
    }
  }


  static Future<bool> sendComplaintWithAttachment({
    required String departmentId,
    required String typeId,
    required String locationId,
    required String description,
    required String filePath,
  }) async {

    if (filePath == null) {
      print('File path is null');
      return false;
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}/citizen/complaint/store');

    final request = http.MultipartRequest('POST', uri);
var token = await AuthStorage.getAuthToken();
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields.addAll({
      'department_id': departmentId,
      'type_id': typeId,
      'location_id': locationId,
      'description': description,
    });

    for (final file in selectedAttachments) {
      if (file.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachments[]',
            file.path!,
            filename: file.name,
          ),
        );
      }
    }
    final response = await request.send();
    final body = await response.stream.bytesToString();
    print('STATUS: ${response.statusCode}');
    print('BODY: $body');

    if(response.statusCode == 200 || response.statusCode == 201){
      return true;
    }
    else {
      return false;
    }
  }

}