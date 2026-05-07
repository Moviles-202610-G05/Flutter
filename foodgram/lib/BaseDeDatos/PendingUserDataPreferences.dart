import 'package:shared_preferences/shared_preferences.dart';

// Datos sin conexion — guarda perfil y metas nutricionales pendientes cuando no hay red
class PendingUserDataPreferences {

  static const String _profileKey = 'pending_profile';
  static const String _goalsKey = 'pending_nutrition_goals';

  // Datos sin conexion — sobreescribe el perfil pendiente con el JSON mas reciente
  Future<void> savePendingProfile(String userDataJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, userDataJson);
  }

  // Datos sin conexion — retorna el perfil pendiente o null si no hay ninguno guardado
  Future<String?> getPendingProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileKey);
  }

  // Datos sin conexion — elimina el perfil pendiente despues de sincronizar con Firebase
  Future<void> clearPendingProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }

  // Datos sin conexion — sobreescribe las metas nutricionales pendientes con el JSON mas reciente
  Future<void> savePendingGoals(String goalsJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalsKey, goalsJson);
  }

  // Datos sin conexion — retorna las metas pendientes o null si no hay ninguna guardada
  Future<String?> getPendingGoals() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_goalsKey);
  }

  // Datos sin conexion — elimina las metas pendientes despues de sincronizar con Firebase
  Future<void> clearPendingGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_goalsKey);
  }
}
