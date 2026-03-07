import 'package:hive_flutter/hive_flutter.dart';
import 'package:medilink/features/specializations/data/models/specialization_api_model.dart';

class SpecializationLocalDataSource {
  static const String _boxName = 'specializations_cache';
  static const String _specializationsKey = 'cached_specializations';
  static const String _timestampKey = 'cache_timestamp';
  static const Duration _cacheValidity = Duration(days: 7);

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  Future<void> cacheSpecializations(List<SpecializationApiModel> specializations) async {
    final box = await _getBox();
    final specializationsJson = specializations.map((s) => s.toJson()).toList();
    await box.put(_specializationsKey, specializationsJson);
    await box.put(_timestampKey, DateTime.now().toIso8601String());
  }

  Future<List<SpecializationApiModel>?> getCachedSpecializations() async {
    final box = await _getBox();
    final timestamp = box.get(_timestampKey) as String?;
    
    if (timestamp != null) {
      final cachedTime = DateTime.parse(timestamp);
      if (DateTime.now().difference(cachedTime) < _cacheValidity) {
        final specializationsJson = box.get(_specializationsKey) as List?;
        if (specializationsJson != null) {
          return specializationsJson
              .map((json) => SpecializationApiModel.fromJson(
                  json as Map<String, dynamic>))
              .toList();
        }
      }
    }
    
    return null;
  }

  Future<void> cacheSpecialization(SpecializationApiModel specialization) async {
    final box = await _getBox();
    await box.put('specialization_${specialization.id}', specialization.toJson());
  }

  Future<SpecializationApiModel?> getCachedSpecialization(String id) async {
    final box = await _getBox();
    final specializationJson = box.get('specialization_$id') as Map?;
    
    if (specializationJson != null) {
      return SpecializationApiModel.fromJson(
          Map<String, dynamic>.from(specializationJson));
    }
    
    return null;
  }

  Future<void> clearCache() async {
    final box = await _getBox();
    await box.clear();
  }
}
