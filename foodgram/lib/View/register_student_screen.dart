
import 'package:flutter/material.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:foodgram/Presenter/UsarioPresenter.dart';
import 'package:foodgram/View/pagesInsideStudent.dart';
import 'package:foodgram/View/widgets/widgets.dart';

class StudentSignUpScreen extends StatefulWidget {
  const StudentSignUpScreen({Key? key}) : super(key: key);

  @override
  State<StudentSignUpScreen> createState() => _StudentSignUpScreenState();
}

class _StudentSignUpScreenState extends State<StudentSignUpScreen> implements UserView{
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _universityCodeController = TextEditingController();
  final _usernameController= TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _paswordController = TextEditingController();

  
  late UserPresenter presenter;

  
  
  String? _selectedCarrier;
  List<String> _selectedPreferences = [];
  
  @override
  void initState() {
    super.initState();
    presenter = UserPresenter(UserRepository(), this); // inicialización aquí
  }


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

  final List<String> _carriers = ['Carrier 1', 'Carrier 2', 'Carrier 3'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _universityCodeController.dispose();
    _paswordController.dispose();
    super.dispose();

  }

  @override
  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Pages()),
    );


  }
  @override
  void mostrarUsuarios(List<Ususario> usuarios) {
    // implementación
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child:Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  const SizedBox(height: 12),
                  // Subtitle
                  const Text(
                    'Create your student account to get started with exclusive campus deals and favorite meals.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),
                  // Full Name Field

                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField (controller: _fullNameController, label: "Full Name", icon: Icons.account_circle_outlined, validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter Name';
                          }
                          return null;
                        }, ),
                  
                  const SizedBox(height: 16),
                  // University Email Field
                  CustomWidgets.buildTextField (controller: _emailController, label: "University Email", icon: Icons.mail_outline, validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter email';
                          }
                          if (!value!.contains('@')) {
                            return 'Please enter a valid email';
                          }

                        }, ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField (controller: _usernameController, label: "Username", icon: Icons.alternate_email, validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a username';
                          }
                        }, ),
                  const SizedBox(height: 16),
                  CustomWidgets.buildTextField (controller: _paswordController, label: "Password", icon: Icons.lock,  ocultar: true ,validator: (value) {
                           if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                            }
                          else if (value.trim().length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                        }, ),
                  const SizedBox(height: 16),

                  // University Code and Carrier Row
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidgets.buildTextField(controller: _universityCodeController, label: "Univercity ID", icon: Icons.badge, validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter codde';
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
                             CustomWidgets.buildDropdownField(label: "Carrier", value: _selectedCarrier, items: _carriers, icon: Icons.school, onChanged: (value) {
                             setState(() {
                                  _selectedCarrier = value;
                                });
                              },)
            
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Food Preferences
                  const Text(
                    'Food Preferences',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                  // Terms and Privacy
                  const Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFFF6933),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'BY CLICKING REGISTER, YOU AGREE TO OUR\nTERMS OF SERVICE AND PRIVACY POLICY.',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Creating user...")),
                        );

                        
                          presenter.crearEstudiante(Ususario(
                          universityId: _universityCodeController.text,
                          name: _fullNameController.text,
                          email: _emailController.text,
                          carrier: _selectedCarrier ?? "",
                          password: _paswordController.text,
                          preferences: _selectedPreferences,
                          username: _usernameController.text,
                        ));
                        


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6347),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ]
      )
      )
      );
      
  }
  
  @override
  void mostrarPerfil(Ususario usuario) {
    // TODO: implement mostrarPerfil
  }
  
}