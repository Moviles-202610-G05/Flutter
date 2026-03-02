import 'package:flutter/material.dart';
import 'package:foodgram/Vistas/register_restaurant1_screen.dart';
import 'package:foodgram/Vistas/register_student_screen.dart';

class PreregisterScreen extends StatefulWidget {
  const PreregisterScreen({Key? key}) : super(key: key);

  @override
  State<PreregisterScreen> createState() => _PreRegisterScreenState();
}

class _PreRegisterScreenState extends State<PreregisterScreen> {
  String? _selectedAccountType;

  @override
  void initState() {
    super.initState();
    
    _selectedAccountType = null;
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
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Title
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text: 'Join Our ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Community',
                      style: TextStyle(color: Color(0xFFFF6933)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              const Text(
                'Choose your account type to get started.\nYou can always change this later in\nsettings.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              // Student Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAccountType = 'student';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _selectedAccountType == 'student'
                        ? const Color(0xFFFFE8E4)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedAccountType == 'student'
                          ? const Color(0xFFFF6933)
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedAccountType == 'student'
                              ? Colors.white
                              : const Color(0xFFFFE8E4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          color: Color(0xFFFF6347),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "I'm a Student",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Discover exclusive deals, track your\nmeals, and save on campus dining.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Restaurant Owner Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAccountType = 'restaurant';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _selectedAccountType == 'restaurant'
                        ? const Color(0xFFFFE8E4)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedAccountType == 'restaurant'
                          ? const Color(0xFFFF6933)
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedAccountType == 'restaurant'
                              ? Colors.white
                              : const Color(0xFFFFE8E4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant_outlined,
                          color: Color(0xFFFF6347),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "I'm a Restaurant Owner",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manage your digital menu, reach\nhungry foodies, and grow your local\nbusiness.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () { 
                    if (_selectedAccountType != null) {
                      if (_selectedAccountType == "student"){
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StudentSignUpScreen()),
                        );}
                      else 
                        if (_selectedAccountType == "restaurant"){
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RestaurantRegisterScreen()),
                        );}
                      }
                      },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAccountType != null
                      ? const Color(0xFFFF6933) // tomate
                      : Colors.grey[300],       // gris cuando es null
                    disabledBackgroundColor: Colors.grey[300],
        
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue to Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20, color: Color.fromARGB(255, 255, 255, 255)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Already have account
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to login
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Color(0xFFFF6933),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}