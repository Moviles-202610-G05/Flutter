import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodgram/Vistas/regiter_restaurant2_screen.dart';
import 'package:foodgram/widgets.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantRegisterScreen extends StatefulWidget {
  const RestaurantRegisterScreen({super.key});

  @override
  State<RestaurantRegisterScreen> createState() => _RestaurantRegisterScreenState();
}

class _RestaurantRegisterScreenState extends State<RestaurantRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imagenSeleccionada;

  // Controllers
  final _ownerNameController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  
  String? _selectedCuisine;
  final List<String> _cuisineTypes = [
    'Italian',
    'Mexican',
    'Japanese',
    'Chinese',
    'Indian',
    'Thai',
    'American',
    'Mediterranean',
  ];

  @override
  void dispose() {
    _ownerNameController.dispose();
    _restaurantNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _usernameController.dispose();
    super.dispose();
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
                  // --- TITULO Y PROGRESO ---
                  const Text(
                    'Create Account',
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
                          'Step 1 of 2 Basic Information',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '50%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6933),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // --- PROGRESS BAR ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 4,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6347),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- OWNER DETAILS SECTION ---
                  const Text(
                    'OWNER DETAILS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField(
                    controller: _ownerNameController,
                    label: 'Full Name of the owner',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter owner name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // --- RESTAURANT DETAILS SECTION ---
                  const Text(
                    'RESTAURANT DETAILS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField(
                    controller: _restaurantNameController,
                    label: 'Restaurant Name',
                    icon: Icons.restaurant,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter restaurant name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField(
                    controller: _emailController,
                    label: 'Business Email',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter email';
                      }
                      if (!value!.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField(
                    controller: _addressController,
                    label: 'Business Address',
                    icon: Icons.location_on_outlined,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.account_circle_outlined,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // --- CUISINE TYPE DROPDOWN ---
                  CustomWidgets.buildDropdownField(
                    label: 'Cuisine Type',
                    value: _selectedCuisine,
                    items: _cuisineTypes,
                    icon: Icons.soup_kitchen_outlined,
                    onChanged: (value) {
                      setState(() {
                        _selectedCuisine = value;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // --- RESTAURANT PHOTO SECTION ---
                  const Text(
                    'Restaurant Photo',
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

                  // --- LOGIN LINK ---
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        children: [
                          const TextSpan(
                              text:
                                  'Already have an account? '),
                          TextSpan(
                            text: 'Login',
                            style: const TextStyle(
                              color: Color(0xFFFF6933),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: null,
                          ),
                          const TextSpan(
                              text: '\nby clicking here or service TERMS OF SERVICE and PRIVACY POLICY'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- ADD MENU BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RestaurantRegisterScreen2()),
                          );
                        }
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
                            'Add menu',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
      ),
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


