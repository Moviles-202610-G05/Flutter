import 'package:flutter/material.dart';
import 'nutrition_goals_screen.dart';
import 'package:foodgram/View/info_user_screen.dart';
import 'package:foodgram/View/post_privacity_screen.dart';
import 'package:foodgram/View/Login_screen.dart';
import 'package:foodgram/View/orders_user_screen.dart';
import 'package:foodgram/View/reviews_user_screen.dart';
import 'package:foodgram/View/saved_user_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  // Metas del usuario
  double _caloriesGoal = 2000;
  double _proteinGoal  = 150;
  double _carbsGoal    = 200;
  double _fatGoal      = 67;

  // Consumido hoy
  double _caloriesConsumed = 1200;
  double _proteinConsumed  = 80;
  double _carbsConsumed    = 140;
  double _fatConsumed      = 35;    

  // Datos de perfil
  String _name     = 'Alex Johnson';
  String _username = '@alex_j';
  String _email    = 'alex.j@email.com';
  String _location = 'London, UK';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        leadingWidth: 173,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: const [
              Icon(Icons.restaurant_menu, color: Color(0xFFFF6347), size: 28),
              SizedBox(width: 4),
              Text(
                'FoodGram',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6347),
                ),
              ),
            ],
          ),
        ),
        title: null,
        titleSpacing: 0,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 28),

              // --- FOTO DE PERFIL ---
              Container(
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

              const SizedBox(height: 14),

              // Nombre y ubicación
              Text(_name,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E))),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  Text(' $_location', style: const TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 28),

              // --- ESTADÍSTICAS ---
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OrdersUserScreen()),
                        ),
                        child: _buildStatCard("42", "ORDERS"),
                      ),
                    ),
                    _buildDivider(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ReviewsUserScreen()),
                        ),
                        child: _buildStatCard("15", "REVIEWS"),
                      ),
                    ),
                    _buildDivider(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SavedUserScreen()),
                        ),
                        child: _buildStatCard("88", "SAVED"),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- NUTRITION GOALS ---
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
                    setState(() {
                      _caloriesGoal = result['calories'];
                      _proteinGoal  = result['protein'];
                      _carbsGoal    = result['carbs'];
                      _fatGoal      = result['fat'];
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildNutritionCard(),
              const SizedBox(height: 32),

              // --- ACCOUNT SETTINGS ---
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
                        name:     _name,
                        username: _username,
                        email:    _email,
                        location: _location,
                      ),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _name     = result['name'];
                      _username = result['username'];
                      _email    = result['email'];
                      _location = result['location'];
                    });
                  }
                },
              ),
              _buildSettingsItem(
                Icons.lock_outline,
                "Post & Privacy Settings",
                "Configure social publications",
                const Color(0xFFFF6347).withOpacity(0.1),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PostPrivacityScreen()),
                ),
              ),
              const SizedBox(height: 24),

              // --- LOGOUT ---
              OutlinedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Color.fromARGB(255, 255, 38, 0)),
                    SizedBox(width: 8),
                    Text("Logout",
                        style: TextStyle(
                            color: Color(0xFFFF6347),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── WIDGETS ──────────────────────────────────────────────────────────────────

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
    return Container(
      width: 1,
      height: 36,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildSectionHeader(String title, String action,
      {VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onAction,
          child: Text(action,
              style: const TextStyle(
                  color: Color(0xFFFF6347), fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildNutritionCard() {
    final double calProgress =
        (_caloriesConsumed / _caloriesGoal).clamp(0.0, 1.0);
    final int calPct = (calProgress * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Daily Calorie Goal",
              style: TextStyle(color: Colors.grey)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("${_caloriesConsumed.round()}",
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              Text(" / ${_caloriesGoal.round()} kcal",
                  style: const TextStyle(color: Colors.grey)),
              const Spacer(),
              Text("$calPct%",
                  style: const TextStyle(
                      color: Color(0xFFFF6347),
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: calProgress,
              minHeight: 10,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFFF6347)),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Macro Targets",
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroItem(
                "Protein",
                "${_proteinConsumed.round()}g",
                "${_proteinGoal.round()}g",
                Colors.redAccent,
                (_proteinConsumed / _proteinGoal).clamp(0.0, 1.0),
              ),
              _buildMacroItem(
                "Carbs",
                "${_carbsConsumed.round()}g",
                "${_carbsGoal.round()}g",
                Colors.orange,
                (_carbsConsumed / _carbsGoal).clamp(0.0, 1.0),
              ),
              _buildMacroItem(
                "Fat",
                "${_fatConsumed.round()}g",
                "${_fatGoal.round()}g",
                Colors.amber,
                (_fatConsumed / _fatGoal).clamp(0.0, 1.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(
      String label, String consumed, String goal, Color color, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 12)),
            const SizedBox(width: 4),
            Text(consumed,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
      IconData icon, String title, String? subtitle, Color bgColor,
      {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
            backgroundColor: bgColor,
            child: Icon(icon, color: const Color(0xFFFF6347))),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey))
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}