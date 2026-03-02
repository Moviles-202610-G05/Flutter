  import 'package:flutter/material.dart';

class CustomWidgets {

  static Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color:  Color.fromARGB(199, 22, 18, 18)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  static Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
     
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        filled: true,
        
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,

              child: 
                  Text(
                    item,
                    
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(174, 22, 18, 18),
                    ),
                ),
    ),
  ).toList(),
    );
  }
}