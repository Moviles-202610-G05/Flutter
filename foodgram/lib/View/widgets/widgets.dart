  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class CustomWidgets {

 static Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  bool ocultar = false, // por defecto false
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validator,
    obscureText: ocultar, // aquí decides si se oculta o no
    inputFormatters: [
      LengthLimitingTextInputFormatter(50),
      FilteringTextInputFormatter.deny(
      RegExp(r'[\u{1F600}-\u{1F64F}'
          r'\u{1F300}-\u{1F5FF}'
          r'\u{1F680}-\u{1F6FF}'
          r'\u{1F1E0}-\u{1F1FF}'
          r'\u{2600}-\u{26FF}'
          r'\u{2700}-\u{27BF}]',
          unicode: true),
        ),
    ],
    style: const TextStyle(color: Color.fromARGB(199, 22, 18, 18)),
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
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      isExpanded: true,
      alignment: AlignmentDirectional.centerStart,
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

class AddressField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String address, double lat, double lng)? onSelected;

  const AddressField({
    super.key,
    required this.controller,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return 
      GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: "AIzaSyDxzMLWUCmAQqm2dpmpDzkC3L8r09rEri4",
      inputDecoration: InputDecoration(
        labelText: 'Restaurant adress',
        prefixIcon: Icon(Icons.location_on_outlined),
        filled: true,
        
        fillColor: Colors.grey[100],

        border: OutlineInputBorder(
          
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      debounceTime: 400,        // ms de espera al escribir
      countries: const ["co"],  // solo Colombia
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        onSelected?.call(
          prediction.description ?? '',
          double.parse(prediction.lat ?? '0'),
          double.parse(prediction.lng ?? '0'),
        );
      },
      itemClick: (Prediction prediction) {
        controller.text = prediction.description ?? '';
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
    );
  }}

