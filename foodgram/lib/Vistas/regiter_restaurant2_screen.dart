import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodgram/widgets.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantRegisterScreen2 extends StatefulWidget {
  const RestaurantRegisterScreen2({super.key});

  @override
  State<RestaurantRegisterScreen2> createState() => _RestaurantRegisterScreen2State();
}

class _RestaurantRegisterScreen2State extends State<RestaurantRegisterScreen2> {
  final _formKey = GlobalKey<FormState>();
  File? _imagenSeleccionada;
  
  final _dishNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedCategory = 'Main Course';
  bool _isInStock = true;
  
  final List<String> _categories = [
    'Main Course',
    'Appetizer',
    'Dessert',
    'Beverage',
    'Soup',
    'Salad',
  ];

  List<Map<String, String>> menuItems = [
    {
      'name': 'Pepperoni Feast',
      'price': '14.99',
      'category': 'Main Course',
    }
  ];

  @override
  void dispose() {
    _dishNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addDishToMenu() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        menuItems.add({
          'name': _dishNameController.text,
          'price': _priceController.text,
          'category': _selectedCategory ?? 'Main Course',
        });
      });
      _dishNameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _selectedCategory = 'Main Course';
      _isInStock = true;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dish added to menu!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6933)),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Partner with Us',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- PROGRESS ---
                      const Text(
                              'Create your Menu',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Step 2 of 2',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const Text(
                            '100%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6347),
                            ),
                          ),
                        ],
                      ),
                     
                      
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 1.0,
                          minHeight: 4,
                          backgroundColor: Color.fromARGB(255, 230, 230, 230),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF6347),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Dish Infromation',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                        ),
                      ),
                       const SizedBox(height: 16),
                      // --- DISH PHOTO ---
                      const Text(
                        'Dish Photo',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                    
                  const SizedBox(height: 16),
                  InkWell(
                      onTap: () async {
                        // Mostrar un diálogo para elegir cámara o galería
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text("Abrir cámara"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text("Abrir galería"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    child: Container(

                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFFF6933),
                        width: 2,
                        style: BorderStyle.solid,

                      ),
                      image: _imagenSeleccionada != null
                        ? DecorationImage(
                            image: FileImage(_imagenSeleccionada!),
                            fit: BoxFit.cover,
                        )
                      : null,
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFFFEAE6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _imagenSeleccionada != null
                      ?[Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(118, 255, 99, 71),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),]
                      : [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: const Color(0xFFFF6933),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Upload Photo',
                          style: TextStyle(
                            color: Color(0xFFFF6933),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),),
                  const SizedBox(height: 32),

                      // --- DISH NAME ---
                      CustomWidgets.buildTextField(controller: _dishNameController, label: "Dish Name", icon: Icons.local_pizza_outlined),
                      
                      const SizedBox(height: 24),

                      // --- PRICE AND CATEGORY ROW ---
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomWidgets.buildTextField(controller: _priceController, label: "Price", icon: Icons.attach_money),
                              ],
                            ),
                          ),
                          const SizedBox(width:2),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomWidgets.buildDropdownField(label: "Category", value: _selectedCategory, items: _categories, icon: Icons.soup_kitchen_outlined, onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- DESCRIPTION ---
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Describe the ingredients, taste, and preparation method...',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- IN STOCK TOGGLE ---
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: const Text(
                              'In Stock',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Switch(
                            value: _isInStock,
                            onChanged: (value) {
                              setState(() {
                                _isInStock = value;
                              });
                            },
                            activeColor: const Color(0xFFFF6933),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Text(
                          'Make this dish visible on menu',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- ADD TO MENU BUTTON ---
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _addDishToMenu,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6933),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Add to Menu',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- MENU SECTION ---
                      const Text(
                        'MENU',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...menuItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey[200],
                                child: Icon(
                                  Icons.restaurant_menu,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '\$${item['price']} • ${item['category']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.grey[300],
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    bottomNavigationBar: Container(
      color: const Color.fromARGB(0, 33, 149, 243),
      padding: EdgeInsets.all(16),
      child:  
        // --- FINISH REGISTRATION BUTTON ---
        Container(
          width: double.infinity,
          color: const Color.fromARGB(0, 33, 149, 243),
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration completed!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6933),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Finish Registration ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.check, color: Colors.white),
              ],
            ),
          ),
        ),
      )
    );
  }
  Future<void> _pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);

  if (image != null) {
      setState(() {
        _imagenSeleccionada = File(image.path);
      });

  }
}
  
}
