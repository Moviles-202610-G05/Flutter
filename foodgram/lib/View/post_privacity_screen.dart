import 'package:flutter/material.dart';

class PostPrivacityScreen extends StatefulWidget {
  const PostPrivacityScreen({super.key});

  @override
  State<PostPrivacityScreen> createState() => _PostPrivacityScreenState();
}

class _PostPrivacityScreenState extends State<PostPrivacityScreen> {
  bool _privateProfile       = false;
  bool _showCalorieProgress  = true;
  bool _allowRestaurantTagging = true;
  String _reviewVisibility   = 'friends'; // 'everyone' o 'friends'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Post & Privacy',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // --- TOGGLES ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildToggleItem(
                    icon: Icons.lock_outline,
                    title: 'Private Profile',
                    subtitle: 'Only approved followers can see your posts',
                    value: _privateProfile,
                    onChanged: (val) =>
                        setState(() => _privateProfile = val),
                    showDivider: true,
                  ),
                  _buildToggleItem(
                    icon: Icons.local_fire_department_outlined,
                    title: 'Show Calorie Progress',
                    subtitle: 'Display daily goal progress on posts',
                    value: _showCalorieProgress,
                    onChanged: (val) =>
                        setState(() => _showCalorieProgress = val),
                    showDivider: true,
                  ),
                  _buildToggleItem(
                    icon: Icons.storefront_outlined,
                    title: 'Allow Restaurant Tagging',
                    subtitle: 'Let others tag restaurants in your photos',
                    value: _allowRestaurantTagging,
                    onChanged: (val) =>
                        setState(() => _allowRestaurantTagging = val),
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- REVIEW VISIBILITY ---
            const Text(
              'Review Visibility',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Who can see my reviews',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  _buildRadioItem(
                    icon: Icons.language,
                    label: 'Everyone',
                    value: 'everyone',
                    showDivider: true,
                  ),
                  _buildRadioItem(
                    icon: Icons.people_outline,
                    label: 'Friends',
                    value: 'friends',
                    showDivider: false,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6347).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFFFF6347), size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFFFF6347),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }
// funciona
  Widget _buildRadioItem({
    required IconData icon,
    required String label,
    required String value,
    required bool showDivider,
  }) {
    final bool selected = _reviewVisibility == value;
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _reviewVisibility = value),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFFF6347).withOpacity(0.07)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 22,
                    color: selected ? const Color(0xFFFF6347) : Colors.grey),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: selected ? Colors.black : Colors.black87,
                    ),
                  ),
                ),
                Radio<String>(
                  value: value,
                  groupValue: _reviewVisibility,
                  onChanged: (val) =>
                      setState(() => _reviewVisibility = val!),
                  activeColor: const Color(0xFFFF6347),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }
}