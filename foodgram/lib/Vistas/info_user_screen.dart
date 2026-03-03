import 'package:flutter/material.dart';

class InfoUserScreen extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final String location;

  const InfoUserScreen({
    super.key,
    required this.name,
    required this.username,
    required this.email,
    required this.location,
  });

  @override
  State<InfoUserScreen> createState() => _InfoUserScreenState();
}

class _InfoUserScreenState extends State<InfoUserScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _usernameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _locationCtrl;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController(text: widget.name);
    _usernameCtrl = TextEditingController(text: widget.username);
    _emailCtrl    = TextEditingController(text: widget.email);
    _locationCtrl = TextEditingController(text: widget.location);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    FocusScope.of(context).unfocus();
    setState(() => _isEditing = false);
    Navigator.pop(context, {
      'name':     _nameCtrl.text,
      'username': _usernameCtrl.text,
      'email':    _emailCtrl.text,
      'location': _locationCtrl.text,
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
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Color(0xFFFF6347), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Personal Info',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                _isEditing ? Icons.close : Icons.edit,
                color: const Color(0xFFFF6347),
              ),
              onPressed: () {
                if (_isEditing) {
                  // Cancelar: restaurar valores originales y salir del modo edición
                  setState(() {
                    _nameCtrl.text     = widget.name;
                    _usernameCtrl.text = widget.username;
                    _emailCtrl.text    = widget.email;
                    _locationCtrl.text = widget.location;
                    _isEditing = false;
                  });
                  FocusScope.of(context).unfocus();
                } else {
                  setState(() => _isEditing = true);
                }
              },
            ),
          ],
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
                const SizedBox(height: 32),

                // --- FOTO DE PERFIL ---
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFF6347),
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 52,
                          backgroundColor: Color(0xFFF0F0F0),
                          child: Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: agregar image_picker cuando esté disponible
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6347),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_isEditing) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Change Photo',
                    style: TextStyle(
                      color: Color(0xFFFF6347),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                _buildField(
                  label: 'OWNER NAME',
                  controller: _nameCtrl,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _buildField(
                  label: 'USERNAME',
                  controller: _usernameCtrl,
                  icon: Icons.alternate_email,
                ),
                const SizedBox(height: 12),
                _buildField(
                  label: 'EMAIL',
                  controller: _emailCtrl,
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildField(
                  label: 'LOCATION',
                  controller: _locationCtrl,
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _isEditing ? _buildUpdateButton(context) : null,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: _isEditing
                    ? TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                    : Text(
                        controller.text,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      color: const Color(0xFFF9F9F9),
      child: ElevatedButton.icon(
        onPressed: () => _save(context),
        icon: const Icon(Icons.save_outlined, color: Colors.white),
        label: const Text(
          'Update Profile',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6347),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
      ),
    );
  }
}