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

  const PreregisterMenu({
    super.key,
    required this.restaurante,
    required this.menuPres,
  });

  @override
  State<PreregisterMenu> createState() => _PreregisterMenuState();
}

class _PreregisterMenuState extends State<PreregisterMenu> implements MenuView {
  File? _imagenSeleccionada;
  final _formKey2 = GlobalKey<FormState>();
  final _dishNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Use a single mutable instance instead of recreating on every reset
  Menu _menuController = Menu(
    name: '', price: '', description: '', image: '', restaurant: '', category: '',
  );

  late MenuPresenter presenterMenu;
  bool _isLoading = false;

  String? _selectedCategory = 'Main Course';
  bool _isInStock = true;

  // Moved to const to avoid rebuilding on every frame
  static const List<String> _categories = [
    'Main Course',
    'Appetizer',
    'Dessert',
    'Beverage',
    'Soup',
    'Salad',
  ];

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

  void _resetForm() {
    _dishNameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _menuController = Menu(
      name: '', price: '', description: '', image: '', restaurant: '', category: '',
    );
    _selectedCategory = 'Main Course';
    _isInStock = true;
    _imagenSeleccionada = null;
  }

  void _addDishToMenu() {
    if (!_formKey2.currentState!.validate()) return;

    _menuController.restaurant = widget.restaurante;
    presenterMenu.agregarMenu(_menuController);

    setState(_resetForm);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dish added to menu!')),
    );

    Navigator.pop(context);
    presenterMenu.darMenu();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    setState(() => _isLoading = true);

    final file = File(image.path);
    final menu = await presenterMenu.onImageCaptured(file);

    if (!mounted) return;
    setState(() {
      _imagenSeleccionada = file;
      _menuController = menu;
      _dishNameController.text = menu.name;
      _priceController.text = menu.price;
      _descriptionController.text = menu.description;
      _selectedCategory = menu.category;
      _isLoading = false;
    });
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey2,
            child: _isLoading
                ? const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    ),
                  )
                : _FormContent(
                    imagenSeleccionada: _imagenSeleccionada,
                    dishNameController: _dishNameController,
                    priceController: _priceController,
                    descriptionController: _descriptionController,
                    selectedCategory: _selectedCategory,
                    isInStock: _isInStock,
                    categories: _categories,
                    onTapImage: _showImageSourceSheet,
                    onCategoryChanged: (value) =>
                        setState(() => _selectedCategory = value),
                    onStockChanged: (value) =>
                        setState(() => _isInStock = value),
                    onAddToMenu: _addDishToMenu,
                  ),
          ),
        ),
      ),
    );
  }

  // --- MenuView callbacks ---

  @override
  void estaCargando(bool mensaje) {
    if (mounted) setState(() => _isLoading = mensaje);
  }

  @override
  void mostrarError(String mensaje) {}

  @override
  void mostrarExito(String mensaje) {}

  @override
  void mostrarPlatos(List<Menu> platos) {}
}

// ---------------------------------------------------------------------------
// Extracted stateless form to avoid unnecessary rebuilds of the full tree
// ---------------------------------------------------------------------------
class _FormContent extends StatelessWidget {
  const _FormContent({
    required this.imagenSeleccionada,
    required this.dishNameController,
    required this.priceController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.isInStock,
    required this.categories,
    required this.onTapImage,
    required this.onCategoryChanged,
    required this.onStockChanged,
    required this.onAddToMenu,
  });

  final File? imagenSeleccionada;
  final TextEditingController dishNameController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final String? selectedCategory;
  final bool isInStock;
  final List<String> categories;
  final VoidCallback onTapImage;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<bool> onStockChanged;
  final VoidCallback onAddToMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Dish Information',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
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
          onTap: onTapImage,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFF6933),
                    width: 2,
                  ),
                  image: imagenSeleccionada != null
                      ? DecorationImage(
                          image: FileImage(imagenSeleccionada!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imagenSeleccionada == null
                    ? const Center(
                        child: Icon(Icons.add_a_photo_outlined,
                            color: Color(0xFFFF6933), size: 40),
                      )
                    : null,
              ),
              if (imagenSeleccionada != null)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(118, 255, 99, 71),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // --- DISH NAME ---
        CustomWidgets.buildTextField(
          controller: dishNameController,
          label: 'Dish Name',
          icon: Icons.local_pizza_outlined,
        ),
        const SizedBox(height: 24),

        // --- PRICE AND CATEGORY ---
        Row(
          children: [
            Expanded(
              child: CustomWidgets.buildTextField(
                controller: priceController,
                label: 'Price',
                icon: Icons.attach_money,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomWidgets.buildDropdownField(
                label: 'Category',
                value: selectedCategory,
                items: categories,
                icon: Icons.soup_kitchen_outlined,
                onChanged: onCategoryChanged,
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
          controller: descriptionController,
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
            Icon(Icons.shopping_cart_outlined,
                color: Colors.grey[400], size: 20),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'In Stock',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Switch(
              value: isInStock,
              onChanged: onStockChanged,
              activeColor: const Color(0xFFFF6933),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            'Make this dish visible on menu',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ),
        const SizedBox(height: 24),

        // --- ADD TO MENU BUTTON ---
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onAddToMenu,
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
      ],
    );
  }
}