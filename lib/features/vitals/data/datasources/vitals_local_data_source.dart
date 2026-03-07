import 'package:hive/hive.dart';
import 'package:medilink/features/vitals/data/models/vitals_api_model.dart';

class VitalsLocalDataSource {
  static const String _boxName = 'vitals';
  static const String _cacheKey = 'cached_vitals';
  static const int _cacheDuration = 1; // 1 day

  Future<Box> get _box async => await Hive.openBox(_boxName);

  Future<List<VitalsApiModel>?> getCachedVitals() async {
    final box = await _box;
    final data = box.get(_cacheKey);

    if (data == null) return null;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int);
    final now = DateTime.now();

    if (now.difference(cachedTime).inDays > _cacheDuration) {
      await clearCache();
      return null;
    }

    return (data['vitals'] as List<dynamic>)
        .map((e) => VitalsApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheVitals(List<VitalsApiModel> vitals) async {
    final box = await _box;
    await box.put(_cacheKey, {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'vitals': vitals.map((v) => v.toJson()).toList(),
    });
  }

  Future<void> clearCache() async {
    final box = await _box;
    await box.delete(_cacheKey);
  }
}
