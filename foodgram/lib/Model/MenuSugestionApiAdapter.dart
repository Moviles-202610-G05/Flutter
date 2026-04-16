import 'dart:io';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuSugestionApiService.dart';

// Adapter - Finje ser Services pero en realidad es Adapter
class MenuSugestionApiAdapter {

  final MenuSugestionApiService service;
  MenuSugestionApiAdapter(this.service);

  @override
  // Extiende el contrato del Services para traducir
  Future<Menu> analyzeImage(File image) async {
    // Pide el JSON de la API
    final aiJson = await service.getRawAnalysis(image);
    // Traduce eso a un MealEntity
    return _adapt(aiJson);
  }

  // Adapta la info y devuelve un MealEntity
  Menu _adapt(Map<String, dynamic> aiJson) {
    return Menu.fromMap(aiJson);
  }

}
