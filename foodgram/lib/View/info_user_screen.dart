import 'package:flutter/material.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Presenter/UserPresenter.dart';
import 'package:foodgram/View/widgets/widgets.dart';

class InfoUserScreen extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final List<String> preferences;

  const InfoUserScreen({
    super.key,
    required this.name,
    required this.username,
    required this.email,
    required this.preferences,
  });

  @override
  State<InfoUserScreen> createState() => _InfoUserScreenState();
}

class _InfoUserScreenState extends State<InfoUserScreen> implements UserView {
  late TextEditingController _nameCtrl;
  late TextEditingController _usernameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late UserPresenter _presenter;
  late List<String> _selectedPreferences;

  bool _isEditing = false;
  bool _isSaving  = false;

  static const List<String> _allPreferences = [
    'Vegan', 'Vegetarian', 'Gluten-Free', 'Halal',
    'Fast Food', 'Healthy', 'Keto', 'Dairy-Free',
  ];

  static const Color _primary = Color(0xFFFF6347);

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController(text: widget.name);
    _usernameCtrl = TextEditingController(text: widget.username);
    _emailCtrl    = TextEditingController(text: widget.email);
    _passwordCtrl = TextEditingController();
    _selectedPreferences = List<String>.from(widget.preferences);
    _presenter = UserPresenter(this);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override void onLoginSuccess() {}
  @override void mostrarUsuarios(List<Usuario> usuarios) {}
  @override void mostrarPerfil(Usuario usuario) {}

  @override
  void mostrarError(String mensaje) {
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void mostrarExito(String mensaje) {
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
    Navigator.pop(context, {
      'name':        _nameCtrl.text,
      'username':    _usernameCtrl.text,
      'email':       _emailCtrl.text,
      'preferences': _selectedPreferences,
    });
  }

  void _onOfflineSaved() {
    // Datos sin conexion — Retorna los nuevos datos para actualizar la interfaz
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile update saved. It will sync when connection is restored"),
      ),
    );
    Navigator.pop(context, {
      'name':        _nameCtrl.text,
      'username':    _usernameCtrl.text,
      'email':       _emailCtrl.text,
      'preferences': _selectedPreferences,
    });
  }

  void _save() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isEditing = false;
      _isSaving  = true;
    });
    _presenter.actualizarPerfil(
      currentEmail: widget.email,
      name: _nameCtrl.text,
      username: _usernameCtrl.text,
      preferences: _selectedPreferences,
      newEmail: _emailCtrl.text,
      password: _passwordCtrl.text,
      onOfflineSaved: _onOfflineSaved,
    );
  }

  void _cancelEdit() {
    FocusScope.of(context).unfocus();
    setState(() {
      _nameCtrl.text = widget.name;
      _usernameCtrl.text = widget.username;
      _emailCtrl.text = widget.email;
      _passwordCtrl.clear();
      _selectedPreferences = List<String>.from(widget.preferences);
      _isEditing = false;
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
            icon: const Icon(Icons.arrow_back_ios_new, color: _primary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Personal Info',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: _primary),
                ),
              )
            else
              IconButton(
                icon: Icon(_isEditing ? Icons.close : Icons.edit, color: _primary),
                onPressed: _isEditing ? _cancelEdit : () => setState(() => _isEditing = true),
              ),
          ],
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (o) { o.disallowIndicator(); return true; },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // Avatar
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 110, height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _primary, width: 3),
                        ),
                        child: const CircleAvatar(
                          radius: 52,
                          backgroundColor: Color(0xFFF0F0F0),
                          child: Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 2, right: 2,
                          child: Container(
                            width: 30, height: 30,
                            decoration: const BoxDecoration(color: _primary, shape: BoxShape.circle),
                            child: const Icon(Icons.edit, color: Colors.white, size: 16),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _buildField(label: 'NAME',     controller: _nameCtrl,     icon: Icons.person_outline),
                const SizedBox(height: 12),
                _buildField(label: 'USERNAME', controller: _usernameCtrl, icon: Icons.alternate_email),
                const SizedBox(height: 12),
                _buildField(label: 'EMAIL',    controller: _emailCtrl,    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                if (_isEditing) ...[
                  _buildField(label: 'PASSWORD', controller: _passwordCtrl, icon: Icons.lock_outline,
                      obscure: true),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 12),

                _buildPreferencesSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _isEditing ? _buildUpdateButton() : null,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _isEditing
          ? CustomWidgets.buildTextField(
              controller: controller,
              label: label,
              icon: icon,
              ocultar: obscure,
              keyboardType: keyboardType,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700,
                        color: Colors.grey, letterSpacing: 0.8)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(icon, size: 18, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        obscure ? '••••••••' : controller.text,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildPreferencesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PREFERENCES',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: Colors.grey, letterSpacing: 0.8)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (_isEditing ? _allPreferences : _selectedPreferences).map((pref) {
              final selected = _selectedPreferences.contains(pref);
              return GestureDetector(
                onTap: _isEditing
                    ? () => setState(() {
                          if (selected) {
                            _selectedPreferences.remove(pref);
                          } else {
                            _selectedPreferences.add(pref);
                          }
                        })
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? _primary : Colors.white,
                    border: Border.all(
                      color: selected ? _primary : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pref,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (!_isEditing && _selectedPreferences.isEmpty)
            Text('No preferences selected',
                style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      color: const Color(0xFFF9F9F9),
      child: ElevatedButton.icon(
        onPressed: _save,
        icon: const Icon(Icons.save_outlined, color: Colors.white),
        label: const Text('Update Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
      ),
    );
  }
}
