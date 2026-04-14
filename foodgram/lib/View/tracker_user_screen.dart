import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foodgram/Model/MealEntity.dart';
import 'package:foodgram/Presenter/TrackerPresenter.dart';

class TrackerScreen extends StatefulWidget {

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  bool _scanning = false;
  bool _analyzing = false;
  int _displayKcal = 0;
  double _displayProtein = 0;
  double _displayCarbs = 0;
  double _displayFat = 0;

  late final AnimationController _ringCtrl;
  late final Animation<double> _ringAnim;
  late final TrackerPresenter _presenter;

  static const _orange = Color(0xFFFF6B35);
  static const _foodGramRed = Color(0xFFFF6347);

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOutCubic);
    _ringCtrl.forward();

    _presenter = TrackerPresenter(
      onLoadingStart: () => setState(() => _analyzing = true),
      onSuccess: (result) {
        setState(() {
          _analyzing = false;
          _displayKcal = result.totalCalories;
          _displayProtein = result.totalProteinG;
          _displayCarbs = result.totalCarbsG;
          _displayFat = result.totalFatG;
        });
        _ringCtrl.reset();
        _ringCtrl.forward();
        if (mounted) {
          _showResultSheet(result);
        }
      },
      onError: (msg) {
        setState(() => _analyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
        );
      },
    );
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  void _showResultSheet(MealEntity result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _ResultSheet(result: result),
    );
  }

  void _showMealDetail(MealEntity meal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MealDetailSheet(meal: meal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              Text('FoodGram', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6347))),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildScanButton(),
            const SizedBox(height: 28),
            const SizedBox(height: 28),
            StreamBuilder<double>(
              stream: _presenter.caloriesGoalStream,
              builder: (context, goalSnapshot) {
                final double currentGoal = goalSnapshot.data ?? 2000.0;

                return StreamBuilder<Map<String, double>>(
                  stream: _presenter.dailyStatsStream,
                  builder: (context, statsSnapshot) {
                    if (statsSnapshot.hasData) {
                      final stats = statsSnapshot.data!;
                      _displayKcal = stats['kcal']!.toInt();
                      _displayProtein = stats['protein']!;
                      _displayCarbs = stats['carbs']!;
                      _displayFat = stats['fat']!;
                    }

                    return _buildProgressCard(currentGoal); 
                  },
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Text(
                "Logged Meals",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3428)),
              ),
            ),
            StreamBuilder<List<MealEntity>>(
              stream: _presenter.loggedMealsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No meals logged today."),
                    ),
                  );
                }
                final meals = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return LoggedMealCard(
                      meal: meals[index],
                      onTap: () => _showMealDetail(meals[index]),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    final bool blocked = _scanning || _analyzing;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: blocked ? null : () => _pickImage(ImageSource.camera),
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              icon: const Icon(Icons.camera_alt_outlined, size: 22),
              label: Text(_analyzing ? 'Analyzing...' : 'Scan meal'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 56,
          width: 56,
          child: ElevatedButton(
            onPressed: blocked ? null : () => _pickImage(ImageSource.gallery),
            style: ElevatedButton.styleFrom(
              backgroundColor: _orange.withOpacity(0.12),
              foregroundColor: _orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.photo_library_outlined, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(double currentGoal) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration( 
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Today\'s Progress', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 28),
            _buildRing(currentGoal), 
            const SizedBox(height: 28),
            _buildMacroRow(),
          ],
        ),
      );

  Widget _buildRing(double goal) { 
    return AnimatedBuilder(
      animation: _ringAnim,
      builder: (_, __) {
        if (_analyzing) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator(color: _orange)),
          );
        }

        final double safeGoal = goal > 0 ? goal : 2000.0;
        final double progressValue = (_displayKcal / safeGoal).clamp(0, 1);

        return SizedBox(
          width: 180,
          height: 180,
          child: CustomPaint(
            painter: _RingPainter(
              progress: _ringAnim.value * progressValue,
              fillColor: _orange,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(_displayKcal * _ringAnim.value).round()}',
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'of ${safeGoal.round()} kcal',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMacroRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MacroBadge(label: 'PROTEIN', value: '${_displayProtein.toStringAsFixed(0)}g'),
          _MacroBadge(label: 'CARBS',   value: '${_displayCarbs.toStringAsFixed(0)}g'),
          _MacroBadge(label: 'FATS',    value: '${_displayFat.toStringAsFixed(0)}g'),
        ],
      );

  Future<void> _pickImage(ImageSource source) async {
    final XFile? photo = await _picker.pickImage(source: source, imageQuality: 85);
    if (photo != null) {
      showModalBottomSheet(
        context: context,
        builder: (_) => _ConfirmSheet(
          path: photo.path,
          // El usuario confirma la accion y dispara el evento en el Presenter
          onConfirm: () => _presenter.onImageCaptured(File(photo.path)),
        ),
      );
    }
  }
} 

class _RingPainter extends CustomPainter {
  final double progress;
  final Color fillColor;
  _RingPainter({required this.progress, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width - 14) / 2,
      paint..color = const Color(0xFFF2F2F2),
    );
    canvas.drawArc(
      Rect.fromLTWH(7, 7, size.width - 14, size.height - 14),
      -1.57, 6.28 * progress, false,
      paint..color = fillColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _MacroBadge extends StatelessWidget {
  final String label, value;
  const _MacroBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
    Text(value,  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  ]);
}

class _ConfirmSheet extends StatelessWidget {
  final String path;
  final VoidCallback onConfirm;
  const _ConfirmSheet({required this.path, required this.onConfirm});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Image.file(File(path), height: 200, fit: BoxFit.cover),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () { Navigator.pop(context); onConfirm(); },
        child: const Text('Analyze'),
      ),
    ]),
  );
}

class _ResultSheet extends StatelessWidget {
  final MealEntity result;
  const _ResultSheet({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            result.dishName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Energy', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('${result.totalCalories} kcal',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroInfo(label: 'Protein', value: '${result.totalProteinG.toStringAsFixed(1)}g', color: Colors.blue),
              _MacroInfo(label: 'Carbs',   value: '${result.totalCarbsG.toStringAsFixed(1)}g',   color: Colors.orange),
              _MacroInfo(label: 'Fats',    value: '${result.totalFatG.toStringAsFixed(1)}g',    color: Colors.redAccent),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Got it!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroInfo extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MacroInfo({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    const SizedBox(height: 4),
    Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
  ]);
}

class LoggedMealCard extends StatelessWidget {
  final MealEntity meal;
  final VoidCallback onTap;
  const LoggedMealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: meal.imagePath != null
                  ? Image.file(
                      File(meal.imagePath!),
                      width: 60, height: 60, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _mealLabel(meal.timestamp),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF6B35),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meal.dishName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 2,           
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,       
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "${meal.totalCalories} kcal",
                style: const TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 60, height: 60,
        color: const Color(0xFFF0F0F0),
        child: const Icon(Icons.fastfood, color: Color(0xFFFF6B35)),
      );

  String _mealLabel(DateTime time) {
    final h = time.hour;
    if (h < 11) return 'Breakfast';
    if (h < 15) return 'Lunch';
    if (h < 19) return 'Snack';
    return 'Dinner';
  }
}

class _MealDetailSheet extends StatelessWidget {
  final MealEntity meal;
  const _MealDetailSheet({required this.meal});

  Color _confidenceColor(ConfidenceLevel confidence) {
    switch (confidence.name) { 
      case 'high':   return Colors.green;
      case 'medium': return Colors.orange;
      case 'low':    return Colors.redAccent;
      default:       return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.45,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (meal.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(meal.imagePath!),
                  height: 180, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            const SizedBox(height: 16),
            Text(meal.dishName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Confidence: ',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
                Text(
                  meal.confidence.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _confidenceColor(meal.confidence),
                  ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Row(
                        children: [
                          Icon(Icons.analytics_outlined, color: Color(0xFFFF6B35)),
                          SizedBox(width: 8),
                          Text('Confidence Levels', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ConfidenceRow(
                            level: 'High',
                            color: Colors.green,
                            description: 'The AI clearly identified the dish. Nutritional values are reliable.',
                          ),
                          SizedBox(height: 12),
                          _ConfidenceRow(
                            level: 'Medium',
                            color: Colors.orange,
                            description: 'The dish was identified with some uncertainty. Values are approximate.',
                          ),
                          SizedBox(height: 12),
                          _ConfidenceRow(
                            level: 'Low',
                            color: Colors.redAccent,
                            description: 'The AI could not clearly identify the dish. Values may be inaccurate.',
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it', style: TextStyle(color: Color(0xFFFF6B35))),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(Icons.info_outline, size: 16, color: Colors.grey),
              ),
            ],
          ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total calories',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text('${meal.totalCalories} kcal',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFFF6B35))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MacroCircle(label: 'Protein', value: meal.totalProteinG, color: Colors.redAccent),
                _MacroCircle(label: 'Carbs',   value: meal.totalCarbsG,   color: Colors.orange),
                _MacroCircle(label: 'Fats',    value: meal.totalFatG,     color: Colors.amber),
              ],
            ),
            const Divider(height: 32),
            const Text('Detected ingredients',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...meal.components.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${c.food} (${c.estimatedPortion})',
                          style: const TextStyle(fontSize: 13)),
                    ),
                    Text('${c.calories} kcal',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MacroCircle extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _MacroCircle({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.1)),
            child: Center(
              child: Text(
                '${value.toStringAsFixed(0)}g',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
        ],
      );
  }

class _ConfidenceRow extends StatelessWidget {
    final String level;
    final Color color;
    final String description;
    const _ConfidenceRow({
      required this.level,
      required this.color,
      required this.description,
    });

    @override
    Widget build(BuildContext context) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 3),
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(level,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13, color: color)),
                const SizedBox(height: 2),
                Text(description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      );
    }
  }