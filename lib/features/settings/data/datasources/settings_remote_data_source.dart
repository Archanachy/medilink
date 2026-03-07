import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/features/settings/data/models/settings_api_model.dart';

class SettingsRemoteDataSource {
  final ApiClient _apiClient;

  SettingsRemoteDataSource(this._apiClient);

  Future<SettingsApiModel> getSettings() async {
    final response = await _apiClient.get('/settings');

    return SettingsApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<SettingsApiModel> updateSettings(SettingsApiModel settings) async {
    final response = await _apiClient.put(
      '/settings',
      data: settings.toJson(),
    );

    return SettingsApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }
}
