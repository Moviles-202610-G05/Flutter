import 'dart:io';
import 'package:foodgram/Model/Smart_feature_API.dart';
import 'package:foodgram/Model/Tracker.dart';

class TrackerPresenter {
  final NutritionModel _model = NutritionModel();
  final void Function() onLoadingStart;
  final void Function(NutritionResult result) onSuccess;
  final void Function(String errorMessage) onError;

  TrackerPresenter({
    required this.onLoadingStart,
    required this.onSuccess,
    required this.onError,
  });

  Future<void> onImageCaptured(File imageFile) async {
    onLoadingStart();

    try {
      final result = await _model.analyzeImage(imageFile);
      onSuccess(result);
    } catch (e) {
      onError('No se pudo analizar la imagen: $e');
    }
  }
}