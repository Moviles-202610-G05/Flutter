import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';
import 'package:foodgram/Model/MenuSugestionApiAdapter.dart';
import 'package:foodgram/Model/MenuSugestionApiService.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/UsuarioEntity.dart';
import 'package:foodgram/Presenter/MenuPresenter.dart';
import 'package:foodgram/View/register_restaurant1_screen.dart';
import 'package:foodgram/View/register_student_screen.dart';
import 'package:foodgram/View/regiter_restaurant2_screen.dart';
import 'package:foodgram/View/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class PreregisterMenu extends StatefulWidget {

  final String restaurante;
  final MenuPresenter menuPres;

  const PreregisterMenu({super.key, required this.restaurante, required this.menuPres});
  
  @override
  State<PreregisterMenu> createState() => _PreregisterMenu();
}

class _PreregisterMenu extends State<PreregisterMenu> implements MenuView {
  File? _imagenSeleccionada;
  final _formKey2 = GlobalKey<FormState>();
  final _dishNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  Menu _MenuContorller = Menu(name: '', price: '', description: '', image: '', restaurant: '', category: '');
  late MenuPresenter presenterMenu;
  bool _isLoading = false; 

  String? _selectedCategory = 'Main Course';
  bool _isInStock = true;

  @override
  void initState() {
    super.initState();
    presenterMenu = widget.menuPres;
  }


  @override
  void dispose() {
    _dishNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  
  void _addDishToMenu() {
    if (_formKey2.currentState!.validate()) {
        _MenuContorller.restaurant = widget.restaurante;
      setState(() {
        presenterMenu.agregarMenu(_MenuContorller);
      });
      _dishNameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _MenuContorller = Menu(name: '', price: '', description: '', image: '', restaurant: '', category: '');
      _selectedCategory = 'Main Course';
      _isInStock = true;
      _imagenSeleccionada = null;    

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dish added to menu!')),
      );

      Navigator.pop(context);
      presenterMenu.darMenu(); // 👈 vuelve a la anterior
                        
    }
  }

  
  final List<String> _categories = [
    'Main Course',
    'Appetizer',
    'Dessert',
    'Beverage',
    'Soup',
    'Salad',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6933)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Join Us',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
                  key: _formKey2,
                  child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center( child: _isLoading 
                          ? Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            ],
                          )
                         : Column( children: [
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
                            child: Stack( 
                                children: [
                        if (_imagenSeleccionada == null)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.camera_alt_outlined,
                                    size: 48, color: Color(0xFFFF6933)),
                                SizedBox(height: 8),
                                Text(
                                  'Upload Photo',
                                  style: TextStyle(
                                    color: Color(0xFFFF6933),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_imagenSeleccionada != null)
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(118, 255, 99, 71),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ),
                      ],)),
                          ),
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
                          onPressed: _addDishToMenu ,
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
                    ])),
                      const SizedBox(height: 32),
            ]))))
  );}
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() { _isLoading = true;});
      Menu menu= await presenterMenu.onImageCaptured(File(image.path));
      setState(() {
        _imagenSeleccionada = File(image.path) ;
        _MenuContorller = menu;
        _dishNameController.text = menu.name;
        _priceController.text = menu.price ;
        _descriptionController.text = menu.description;
        _selectedCategory = menu.category;
        _isLoading = false;


        });
    
  }
  
}
 @override
  void estaCargando(bool mensaje) {
    setState(() { _isLoading = mensaje;});
  }
  
  @override
  void mostrarError(String mensaje) {
    // TODO: implement mostrarError
  }
  
  @override
  void mostrarExito(String mensaje) {
    // TODO: implement mostrarExito
  }
  
  @override
  void mostrarPlatos(List<Menu> platos) {
    // TODO: implement mostrarPlatos
  }

  
}
