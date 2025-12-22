import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_client.dart';
import '../models/show_profile.dart';
import '../models/update_profile/request_model_update_profile.dart';
import '../models/update_profile/response_model_update_profile.dart';

class ProfileRemoteDataSource {
  final HttpClient httpClient;

  ProfileRemoteDataSource({required this.httpClient});

  Future<UserProfileResponse> getProfile() async {
    final response = await httpClient.get(
      endpoint: ApiEndpoints.showProfile,
      requiresAuth: true,
    );
    print('ppproooooofffile $response');
    return UserProfileResponse.fromJson(response);
  }

  Future<UpdateProfileResponse> updateProfile(UpdateProfileRequest request) async {
    final response = await httpClient.post(
      endpoint: ApiEndpoints.updateProfile,
      data: request.toJson(),
      requiresAuth: true,
    );
    return UpdateProfileResponse.fromJson(response);
  }

  Future<String> deleteProfile({required String password}) async {
    final response = await httpClient.post(
      endpoint: ApiEndpoints.deleteProfile,
      data: {
        'password': password,
        'password': password,
      },
      requiresAuth: true,
    );

    return response['data'] ?? 'تم حذف الحساب بنجاح';
  }

}
