import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/View/regiter_restaurant2_screen.dart';
import 'package:foodgram/View/widgets/widgets.dart';
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
  final _paswordController = TextEditingController();
  final _spotsController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<String> _selectedPreferences = [];

  double? _lat, _lng;
  String? _address;
  String? _selectedBiginning;
  String? _selectedEnd;
  final List<String> _foodPreferences = [
    'Vegan',
    'Vegetarian',
    'Gluten-Free',
    'Halal',
    'Fast Food',
    'Healthy',
    'Keto',
    'Dairy-Free',
  ];
  final List<String> _time = [
    "00:00","00:30",
    "01:00","01:30",
    "02:00","02:30",
    "03:00","03:30",
    "04:00","04:30",
    "05:00","05:30",
    "06:00","06:30",
    "07:00","07:30",
    "08:00","08:30",
    "09:00","09:30",
    "10:00","10:30",
    "11:00","11:30",
    "12:00","12:30",
    "13:00","13:30",
    "14:00","14:30",
    "15:00","15:30",
    "16:00","16:30",
    "17:00","17:30",
    "18:00","18:30",
    "19:00","19:30",
    "20:00","20:30",
    "21:00","21:30",
    "22:00","22:30",
    "23:00","23:30"
  ];

  String? _selectedPrice;
final List<String> _prices = [
    'less 10k',
    '10k-25k',
    '25k-50k',
    'more 50k'
  ];
final  Map<String, String> _prices2 = {
  'less 10k': "\$",
  '10k-25k': "\$\$",
  '25k-50k': "\$\$\$",
  'more 50k': "\$\$\$\$"
};


  
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
    _paswordController.dispose();
    _spotsController.dispose();
    _descriptionController.dispose();
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
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.alternate_email,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField (controller: _paswordController, label: "Password", icon: Icons.lock,  ocultar: true ,validator: (value) {
                           if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                            }
                          else if (value.trim().length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                        }, ),

                 
                 
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
                  SizedBox(
                          width: double.infinity,
                          child: AddressField(
                          controller: _addressController,
                          onSelected: (address, lat, lng) {
                            setState(() {
                              _address = address;
                              _lat = lat;
                              _lng = lng;
                            });
                          },
                        )),

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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                               CustomWidgets.buildTextField (controller: _spotsController, keyboardType: TextInputType.number,label: "Spots", icon: Icons.lock,validator: (value) {
                           if (value == null || value.isEmpty) {
                            return 'Please enter a number of spots';
                            }

                          },)
                          ],
                        ),
                      ),
                    
            



                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             CustomWidgets.buildDropdownField(label: "Price", value: _selectedPrice, items: _prices, icon: Icons.attach_money, onChanged: (value) {
                             setState(() {
                                  _selectedPrice = value;
                                });
                              },)
            
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           CustomWidgets.buildDropdownField(label: "Bigining", value: _selectedBiginning, items: _time, icon: Icons.access_time, onChanged: (value) {
                             setState(() {
                                  _selectedBiginning = value;
                                });
                              },)
            
    
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             CustomWidgets.buildDropdownField(label: "End", value: _selectedEnd, items: _time, icon: Icons.access_time, onChanged: (value) {
                             setState(() {
                                  _selectedEnd = value;
                                });
                              },)
            
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

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
                  const SizedBox(height: 24),
                  const Text(
                    'Restaurant Tags',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _foodPreferences.map((preference) {
                      final isSelected = _selectedPreferences.contains(preference);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedPreferences.remove(preference);
                            } else {
                              _selectedPreferences.add(preference);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFF6933)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFF6933)
                                  : Colors.grey[300]!,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            preference,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
                          var _pricer = _prices2[_selectedPrice] ?? "\$" ;
                          var _Biginig = _selectedBiginning ?? "00:00";
                          var _End = _selectedEnd ?? "00:00";
                          var _time = _Biginig + " - " + _End;
                          var restaurante = Restaurant(id: '',name: _restaurantNameController.text, 
                          image: '', 
                          rating: 5, 
                          price: _pricer, 
                          cuisine: _selectedCuisine ?? "", 
                          time: _time, 
                          distance: '0 km', 
                          long: _lng ?? 0, 
                          lat: _lat ?? 0, 
                          badge: '', 
                          badge2: '', 
                          numberReviews: 0, 
                          description: _descriptionController.text, 
                          direction: _addressController.text, 
                          spots: int.tryParse(_spotsController.text) ?? 0, 
                          spotsA: int.tryParse(_spotsController.text) ?? 0, 
                          tags: _selectedPreferences,
                          imagenFiel: _imagenSeleccionada);
                          var user = Usuario(universityId: '', name: _ownerNameController.text, email: _emailController.text, carrier: _restaurantNameController.text, password: _paswordController.text, preferences: [], username: _usernameController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RestaurantRegisterScreen2(restaurante: restaurante, user: user,)),
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


