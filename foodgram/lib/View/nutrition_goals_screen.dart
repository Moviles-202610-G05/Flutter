import 'package:flutter/material.dart';

class NutritionGoalsScreen extends StatefulWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const NutritionGoalsScreen({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  State<NutritionGoalsScreen> createState() => _NutritionGoalsScreenState();
}

class _NutritionGoalsScreenState extends State<NutritionGoalsScreen> {
  late double _calories;
  late double _protein;
  late double _carbs;
  late double _fat;

  late TextEditingController _caloriesCtrl;
  late TextEditingController _proteinCtrl;
  late TextEditingController _carbsCtrl;
  late TextEditingController _fatCtrl;

  static const double _proteinPct = 0.30;
  static const double _carbsPct   = 0.40;
  static const double _fatPct     = 0.30;

  static const double _maxProtein = 300;
  static const double _maxCarbs   = 500;
  static const double _maxFat     = 200;

  @override
  void initState() {
    super.initState();
    _calories = widget.calories;
    _protein  = widget.protein;
    _carbs    = widget.carbs;
    _fat      = widget.fat;

    _caloriesCtrl = TextEditingController(text: _calories.round().toString());
    _proteinCtrl  = TextEditingController(text: _protein.round().toString());
    _carbsCtrl    = TextEditingController(text: _carbs.round().toString());
    _fatCtrl      = TextEditingController(text: _fat.round().toString());
  }

  @override
  void dispose() {
    _caloriesCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  // Usuario cambia calorías → recalcula macros con distribución fija
  void _onCaloriesChanged(String val) {
    final parsed = double.tryParse(val);
    if (parsed == null || parsed <= 0) return;
    setState(() {
      _calories = parsed;
      _protein  = (parsed * _proteinPct) / 4;
      _carbs    = (parsed * _carbsPct)   / 4;
      _fat      = (parsed * _fatPct)     / 9;
      _proteinCtrl.text = _protein.round().toString();
      _carbsCtrl.text   = _carbs.round().toString();
      _fatCtrl.text     = _fat.round().toString();
    });
  }

  // Usuario mueve slider o edita campo de texto de un macro → recalcula calorías
  void _onMacroChanged({double? protein, double? carbs, double? fat}) {
    setState(() {
      if (protein != null) {
        _protein = protein;
        _proteinCtrl.text = protein.round().toString();
      }
      if (carbs != null) {
        _carbs = carbs;
        _carbsCtrl.text = carbs.round().toString();
      }
      if (fat != null) {
        _fat = fat;
        _fatCtrl.text = fat.round().toString();
      }
      _calories = (_protein * 4) + (_carbs * 4) + (_fat * 9);
      _caloriesCtrl.text = _calories.round().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9F9F9),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFF6347), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit Nutrition Goals',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text('Calorie Targets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildCalorieCard(),
                const SizedBox(height: 32),
                const Text('Macronutrient Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildMacroCard(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildSaveButton(context),
      ),
    );
  }

  Widget _buildCalorieCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daily Calorie Goal', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6347).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Active Goal',
                  style: TextStyle(color: Color(0xFFFF6347), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _caloriesCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: '0',
                    hintStyle: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  onChanged: _onCaloriesChanged,
                ),
              ),
              const Text('KCAL', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPctChip('Protein 30%', Colors.redAccent),
              const SizedBox(width: 8),
              _buildPctChip('Carbs 40%', Colors.orange),
              const SizedBox(width: 8),
              _buildPctChip('Fat 30%', Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPctChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildMacroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildMacroRow(
            label: 'Protein',
            value: _protein,
            max: _maxProtein,
            color: Colors.redAccent,
            controller: _proteinCtrl,
            onSliderChanged: (v) => _onMacroChanged(protein: v),
            onTextChanged: (val) {
              final parsed = double.tryParse(val);
              if (parsed != null && parsed >= 0 && parsed <= _maxProtein) {
                _onMacroChanged(protein: parsed);
              }
            },
          ),
          const SizedBox(height: 24),
          _buildMacroRow(
            label: 'Carbs',
            value: _carbs,
            max: _maxCarbs,
            color: Colors.orange,
            controller: _carbsCtrl,
            onSliderChanged: (v) => _onMacroChanged(carbs: v),
            onTextChanged: (val) {
              final parsed = double.tryParse(val);
              if (parsed != null && parsed >= 0 && parsed <= _maxCarbs) {
                _onMacroChanged(carbs: parsed);
              }
            },
          ),
          const SizedBox(height: 24),
          _buildMacroRow(
            label: 'Fat',
            value: _fat,
            max: _maxFat,
            color: Colors.amber,
            controller: _fatCtrl,
            onSliderChanged: (v) => _onMacroChanged(fat: v),
            onTextChanged: (val) {
              final parsed = double.tryParse(val);
              if (parsed != null && parsed >= 0 && parsed <= _maxFat) {
                _onMacroChanged(fat: parsed);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow({
    required String label,
    required double value,
    required double max,
    required Color color,
    required TextEditingController controller,
    required ValueChanged<double> onSliderChanged,
    required ValueChanged<String> onTextChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(radius: 6, backgroundColor: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
            // Cajita editable con teclado
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: onTextChanged,
                    ),
                  ),
                  Text('g', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: const Color(0xFFEEEEEE),
            thumbColor: color,
            overlayColor: color.withOpacity(0.15),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            trackHeight: 5,
          ),
          child: Slider(
            value: value.clamp(0, max),
            min: 0,
            max: max,
            onChanged: onSliderChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      color: const Color(0xFFF9F9F9),
      child: ElevatedButton.icon(
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context, {
            'calories': _calories,
            'protein': _protein,
            'carbs': _carbs,
            'fat': _fat,
          });
        },
        icon: const Icon(Icons.check, color: Colors.white),
        label: const Text(
          'Save Changes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6347),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
      ),
    );
  }
}