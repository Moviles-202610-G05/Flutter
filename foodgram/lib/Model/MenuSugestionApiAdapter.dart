import 'dart:io';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuSugestionApiService.dart';
class MenuSugestionApiAdapter {

  final MenuSugestionApiService service;
  MenuSugestionApiAdapter(this.service);

  @override
  Future<Menu> analyzeImage(File image) async {
    final aiJson = await service.getRawAnalysis(image);
    print(aiJson);
    return _adapt(aiJson);
  }

  // Adapta la info y devuelve un MealEntity
  Menu _adapt(Map<String, dynamic> aiJson) {
    return Menu.fromMap(aiJson);
  }

}
