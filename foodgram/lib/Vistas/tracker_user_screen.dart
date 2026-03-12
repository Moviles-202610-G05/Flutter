import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foodgram/Model/Tracker.dart';
import 'package:foodgram/Presenter/tracker_user.dart';

// ─────────────────────────────────────────────
// DATA  — datos del usuario (meta diaria)
// Más adelante esto vendrá de Firebase
// ─────────────────────────────────────────────
class UserNutrition {
  final String name;
  final int goalKcal;

  const UserNutrition({required this.name, required this.goalKcal});
}

const _user = UserNutrition(name: 'María', goalKcal: 2000);

// ─────────────────────────────────────────────
// MAIN PAGE
// ─────────────────────────────────────────────
class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen>
    with SingleTickerProviderStateMixin {

  // ── Estado ───────────────────────────────────
  final _picker       = ImagePicker();
  bool _scanning      = false;   // botón deshabilitado + spinner
  bool _analyzing     = false;   // analizando con la IA

  NutritionResult? _result;

  int    _displayKcal    = 0;
  double _displayProtein = 0;
  double _displayCarbs   = 0;
  double _displayFat     = 0;

  late final AnimationController _ringCtrl;
  late final Animation<double>   _ringAnim;
  late final TrackerPresenter    _presenter;

  static const _orange = Color(0xFFFF6B35);

  // ── Init ─────────────────────────────────────
  @override
  void initState() {
    super.initState();

    // Animación de la rueda
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOutCubic);
    _ringCtrl.forward();

    // Presenter — aquí se definen los 3 callbacks
    _presenter = TrackerPresenter(
      // 1. Empieza a analizar → muestra spinner sobre la rueda
      onLoadingStart: () {
        setState(() => _analyzing = true);
      },

      // 2. Llegó el resultado → actualiza la rueda con los nuevos datos
      onSuccess: (NutritionResult result) {
        setState(() {
          _analyzing     = false;
          _result        = result;
          _displayKcal    = result.totalCalories;
          _displayProtein = result.totalProteinG;
          _displayCarbs   = result.totalCarbsG;
          _displayFat     = result.totalFatG;
        });
        // Re-anima la rueda con los nuevos valores
        _ringCtrl
          ..reset()
          ..forward();

        // Cierra el bottom sheet si sigue abierto
        if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);

        // Muestra el resultado en un nuevo bottom sheet
        _showResultSheet(result);
      },

      // 3. Algo falló → muestra snackbar con el error
      onError: (String message) {
        setState(() => _analyzing = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  // ── Cámara ───────────────────────────────────
  Future<void> _openCamera() async {
    setState(() => _scanning = true);
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        _showConfirmSheet(photo.path);
      }
    } finally {
      setState(() => _scanning = false);
    }
  }

  // ── Galería ──────────────────────────────────
  Future<void> _openGallery() async {
    setState(() => _scanning = true);
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (photo != null) {
        _showConfirmSheet(photo.path);
      }
    } finally {
      setState(() => _scanning = false);
    }
  }

  // ── Bottom sheet: confirmación de foto ───────
  void _showConfirmSheet(String path) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ConfirmSheet(
        imagePath: path,
        onAnalyze: () {
          // El usuario confirma → le pasamos la foto al Presenter
          _presenter.onImageCaptured(File(path));
        },
      ),
    );
  }

  // ── Bottom sheet: resultado del análisis ─────
  void _showResultSheet(NutritionResult result) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ResultSheet(result: result),
    );
  }

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.restaurant_menu, color:  Color(0xFFFF6347), size: 28),
            const SizedBox(width: 8),
            const Text('FoodGram',
                style: TextStyle(color: Color(0xFFFF6347), fontWeight: FontWeight.bold)),
          ],
        ),
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
              const SizedBox(height: 20),
              _buildScanButton(),
              const SizedBox(height: 28),
              _buildProgressCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────
  Widget _buildHeader() => Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, ${_user.name} 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Track your nutrition today',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: 22,
            backgroundColor: _orange.withOpacity(0.15),
            child: const Icon(Icons.person_outline, color: _orange, size: 22),
          ),
        ],
      );

  // ── Botones escanear / galería ───────────────
  Widget _buildScanButton() {
    final bool blocked = _scanning || _analyzing;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: blocked ? null : _openCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _orange.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.camera_alt_outlined, size: 22),
              label: _analyzing
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Analyzing...'),
                      ],
                    )
                  : Text(
                      _scanning ? 'Opening...' : 'Scan meal',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 56,
          width: 56,
          child: ElevatedButton(
            onPressed: blocked ? null : _openGallery,
            style: ElevatedButton.styleFrom(
              backgroundColor: _orange.withOpacity(0.12),
              foregroundColor: _orange,
              disabledBackgroundColor: _orange.withOpacity(0.06),
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Icon(Icons.photo_library_outlined, size: 22),
          ),
        ),
      ],
    );
  }

  // ── Tarjeta de progreso ──────────────────────
  Widget _buildProgressCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Today\'s Progress',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const SizedBox(height: 28),
            _buildRing(),
            const SizedBox(height: 28),
            _buildMacroRow(),
          ],
        ),
      );

  // ── Rueda animada ────────────────────────────
  Widget _buildRing() {
    final progress = _user.goalKcal > 0
        ? (_displayKcal / _user.goalKcal).clamp(0.0, 1.0)
        : 0.0;

    return AnimatedBuilder(
      animation: _ringAnim,
      builder: (_, __) {
        // Si está analizando muestra un spinner en lugar de la rueda
        if (_analyzing) {
          return const SizedBox(
            width: 180,
            height: 180,
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B35),
                strokeWidth: 6,
              ),
            ),
          );
        }

        final sweep = _ringAnim.value * progress;
        return SizedBox(
          width: 180,
          height: 180,
          child: CustomPaint(
            painter: _RingPainter(
              progress:    sweep,
              trackColor:  const Color(0xFFF2F2F2),
              fillColor:   _orange,
              strokeWidth: 14,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(_displayKcal * _ringAnim.value).round()}',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'of ${_user.goalKcal} kcal',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Fila de macros ───────────────────────────
  Widget _buildMacroRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MacroBadge(label: 'PROTEIN', value: '${_displayProtein.toStringAsFixed(0)}g'),
          _MacroBadge(label: 'CARBS',   value: '${_displayCarbs.toStringAsFixed(0)}g'),
          _MacroBadge(label: 'FATS',   value: '${_displayFat.toStringAsFixed(0)}g'),
        ],
      );
}

// ─────────────────────────────────────────────
// RING PAINTER
// ─────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final Color  trackColor;
  final Color  fillColor;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center     = Offset(size.width / 2, size.height / 2);
    final radius     = (size.shortestSide - strokeWidth) / 2;
    const startAngle = -1.5707963267948966;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0, 6.283185307179586, false,
      Paint()
        ..color       = trackColor
        ..style       = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap   = StrokeCap.round,
    );

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle, 6.283185307179586 * progress, false,
        Paint()
          ..color       = fillColor
          ..style       = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap   = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.fillColor != fillColor ||
      old.trackColor != trackColor;
}

// ─────────────────────────────────────────────
// MACRO BADGE
// ─────────────────────────────────────────────
class _MacroBadge extends StatelessWidget {
  final String label;
  final String value;

  const _MacroBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      );
}

// ─────────────────────────────────────────────
// BOTTOM SHEET: confirmación de foto
// ─────────────────────────────────────────────
class _ConfirmSheet extends StatelessWidget {
  final String    imagePath;
  final VoidCallback onAnalyze;

  const _ConfirmSheet({required this.imagePath, required this.onAnalyze});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(imagePath),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Photo captured',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Analyze the macros of this meal?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // cierra este sheet
                  onAnalyze();            // llama al Presenter
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Analyze meal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────
// BOTTOM SHEET: resultado del análisis
// ─────────────────────────────────────────────
class _ResultSheet extends StatelessWidget {
  final NutritionResult result;

  const _ResultSheet({required this.result});

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            controller: scrollCtrl,
            children: [
              const SizedBox(height: 12),
              // Handle
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
              Text(
                result.dishName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Confidence: ${result.confidence.name}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),
              // Totales
              _ResultRow('Total calories', '${result.totalCalories} kcal', bold: true),
              _ResultRow('Protein',  '${result.totalProteinG.toStringAsFixed(1)}g'),
              _ResultRow('Carbohydrates', '${result.totalCarbsG.toStringAsFixed(1)}g'),
              _ResultRow('Fats',    '${result.totalFatG.toStringAsFixed(1)}g'),
              const Divider(height: 32),
              // Ingredientes
              const Text(
                'Detected ingredients',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...result.components.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${c.food} (${c.estimatedPortion})',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Text(
                        '${c.calories} kcal',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
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

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool   bold;

  const _ResultRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                color: bold ? const Color(0xFFFF6B35) : null,
              ),
            ),
          ],
        ),
      );
}