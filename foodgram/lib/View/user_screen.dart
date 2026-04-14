import 'package:flutter/material.dart';
import 'nutrition_goals_screen.dart';
import 'package:foodgram/View/info_user_screen.dart';
import 'package:foodgram/View/post_privacity_screen.dart';
import 'package:foodgram/View/Login_screen.dart';
import 'package:foodgram/View/orders_user_screen.dart';
import 'package:foodgram/View/reviews_user_screen.dart';
import 'package:foodgram/View/saved_user_screen.dart';
import 'package:foodgram/Presenter/UserPresenter.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/MealRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> implements UserView {

  late UserPresenter _presenter;
  final MealRepository _mealRepo = MealRepository();
  bool _isLoading = true;
  double _caloriesGoal = 2000;
  double _proteinGoal  = 150;
  double _carbsGoal    = 200;
  double _fatGoal      = 67;
  String _name     = '';
  String _username = '';
  String _email    = '';
  String _location = '';
  List<String> _preferences = [];

  @override
  void initState() {
    super.initState();
    _presenter = UserPresenter(this);
    _presenter.cargarPerfilActual();
  }

  @override
  void mostrarPerfil(Usuario usuario) {
    setState(() {
      _name          = usuario.name;
      _username      = usuario.username;
      _email         = usuario.email;
      _location      = usuario.carrier;
      _preferences   = List<String>.from(usuario.preferences);
      _caloriesGoal  = usuario.caloriesGoal;
      _proteinGoal   = usuario.proteinGoal;
      _carbsGoal     = usuario.carbsGoal;
      _fatGoal       = usuario.fatGoal;
      _isLoading     = false;
    });
  }

  @override
  void onLoginSuccess() {
  }

  @override
  void mostrarError(String mensaje) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void mostrarUsuarios(List<Usuario> usuarios) {}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6347)))
        : NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowIndicator();
              return true;
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.5,
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  leadingWidth: 173, 
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.restaurant_menu, 
                          color: Color(0xFFFF6347), 
                          size: 28
                        ),
                        SizedBox(width: 4),
                        Text(
                          'FoodGram',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6347),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 28),

                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFF6347), width: 3),
                          ),
                          child: const CircleAvatar(
                            radius: 57,
                            backgroundColor: Color(0xFFF0F0F0),
                            child: Icon(Icons.person, size: 64, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Center(
                        child: Text(_name,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E))),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                          Text(' $_location', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => const OrdersUserScreen())),
                                child: _buildStatCard("42", "ORDERS"),
                              ),
                            ),
                            _buildDivider(),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => const ReviewsUserScreen())),
                                child: _buildStatCard("15", "REVIEWS"),
                              ),
                            ),
                            _buildDivider(),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => const SavedUserScreen())),
                                child: _buildStatCard("88", "SAVED"),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      _buildSectionHeader(
                        "Nutrition Goals",
                        "Details",
                        onAction: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NutritionGoalsScreen(
                                calories: _caloriesGoal,
                                protein:  _proteinGoal,
                                carbs:    _carbsGoal,
                                fat:      _fatGoal,
                              ),
                            ),
                          );
                          if (result != null) {
                            final map = result as Map<String, double>;
                            setState(() {
                              _caloriesGoal = map['calories']!;
                              _proteinGoal  = map['protein']!;
                              _carbsGoal    = map['carbs']!;
                              _fatGoal      = map['fat']!;
                            });
                            _presenter.guardarNutritionGoals(
                              calories: map['calories']!,
                              protein:  map['protein']!,
                              carbs:    map['carbs']!,
                              fat:      map['fat']!,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildNutritionCard(),
                      const SizedBox(height: 32),

                      _buildSectionHeader("Account Settings", ""),
                      const SizedBox(height: 12),
                      _buildSettingsItem(
                        Icons.person_outline,
                        "Personal Information",
                        null,
                        const Color(0xFFFF6347).withOpacity(0.1),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InfoUserScreen(
                                name:        _name,
                                username:    _username,
                                email:       _email,
                                preferences: _preferences,
                              ),
                            ),
                          );
                          if (result != null) {
                            final map = result as Map<String, dynamic>;
                            setState(() {
                              _name        = map['name'] as String;
                              _username    = map['username'] as String;
                              _email       = map['email'] as String;
                              _preferences = List<String>.from(map['preferences'] as List);
                            });
                          }
                        },
                      ),
                      _buildSettingsItem(
                        Icons.lock_outline,
                        "Post & Privacy Settings",
                        "Configure social publications",
                        const Color(0xFFFF6347).withOpacity(0.1),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const PostPrivacityScreen())),
                      ),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                        // Agregamos un BorderRadius al InkWell para que el efecto visual al tocarlo
                        // coincida con la forma del botón
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          // Espaciado interno para que el contenido no toque los bordes
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white, // Fondo blanco
                            borderRadius: BorderRadius.circular(12), // Bordes redondeados
                            border: Border.all(
                              color: const Color(0xFFFF6347), // Tu color naranja característico
                              width: 1.8, // Grosor del borde
                            ),
                            // Opcional: una sombra muy suave para dar profundidad
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min, // Hace que el botón se ajuste al contenido
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout, 
                                color: Color(0xFFFF6347), // Color unificado
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Log out",
                                style: TextStyle(
                                  color: Color(0xFFFF6347),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
          ),
  );
}

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6347))),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 36, color: Colors.grey.shade200);
  }

  Widget _buildSectionHeader(String title, String action, {VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onAction,
          child: Text(action,
              style: const TextStyle(color: Color(0xFFFF6347), fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildNutritionCard() {
    // Event consumer, el streamBuilder se reconstruye cada vez que el stream emite un nuevo valor
    return StreamBuilder<Map<String, double>>(
      stream: _mealRepo.getDailyStatsStream(_email), 
      builder: (context, snapshot) {
        final stats = snapshot.data ?? {'kcal': 0.0, 'protein': 0.0, 'carbs': 0.0, 'fat': 0.0};
        final double consumedKcal = stats['kcal']!;
        final double consumedProtein = stats['protein']!;
        final double consumedCarbs = stats['carbs']!;
        final double consumedFat = stats['fat']!;

        // Cálculos de progreso (validando no dividir por cero)
        final double calProgress = (consumedKcal / (_caloriesGoal > 0 ? _caloriesGoal : 2000)).clamp(0.0, 1.0);
        final int calPct = (calProgress * 100).round();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Daily Calorie Goal", style: TextStyle(color: Colors.grey)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text("${consumedKcal.round()}",
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(" / ${_caloriesGoal.round()} kcal",
                      style: const TextStyle(color: Colors.grey)),
                  const Spacer(),
                  Text("$calPct%",
                      style: const TextStyle(
                          color: Color(0xFFFF6347), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: calProgress,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFEEEEEE),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6347)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Macro Targets", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMacroItem("Protein", "${consumedProtein.round()}g",
                      "${_proteinGoal.round()}g", Colors.redAccent,
                      (consumedProtein / (_proteinGoal > 0 ? _proteinGoal : 1)).clamp(0.0, 1.0)),
                  _buildMacroItem("Carbs", "${consumedCarbs.round()}g",
                      "${_carbsGoal.round()}g", Colors.orange,
                      (consumedCarbs / (_carbsGoal > 0 ? _carbsGoal : 1)).clamp(0.0, 1.0)),
                  _buildMacroItem("Fat", "${consumedFat.round()}g",
                      "${_fatGoal.round()}g", Colors.amber,
                      (consumedFat / (_fatGoal > 0 ? _fatGoal : 1)).clamp(0.0, 1.0)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroItem(String label, String consumed, String goal, Color color, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              consumed,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              ' / $goal',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String? subtitle, Color bgColor,
      {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
            backgroundColor: bgColor,
            child: Icon(icon, color: const Color(0xFFFF6347))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey))
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}