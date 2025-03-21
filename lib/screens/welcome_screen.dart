import 'package:flutter/material.dart';
import 'package:mindlabryinth/providers/auth_provider.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFormValid = false;

  void validateForm() {
    setState(() {
      isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Swiper Section
            SizedBox(
              height: 200,
              child: Swiper(
                itemCount: 3,
                autoplay: true,
                pagination: const SwiperPagination(),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Center(
                      child: Text(
                        "Carousel Slide ${index + 1}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  onChanged: validateForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Welcome Text
                      const Text(
                        "Welcome to Mindlabyrinth",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Email Field
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "UserName",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "User Name is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Password Field
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password (Right Aligned)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/forgotPassword');
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Display error message if any
                      if (authProvider.errorMessage.isNotEmpty)
                        Text(
                          authProvider.errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),

                      // Login Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: isFormValid && !authProvider.isLoading
                            ? () async {
                                await authProvider.login(
                                  nameController.text,
                                  passwordController.text,
                                );
                                if (authProvider.errorMessage.isEmpty) {
                                  Navigator.pushNamed(context, '/dashboard');
                                }
                              }
                            : null,
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 15),

                      const Text(
                        "OR",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 15),

                      // Register Buttons
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/familyRegistration');
                        },
                        child: const Text("Register as Family", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/staffRegistration');
                        },
                        child: const Text("Register as Staff", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 100),

                      // Footer
                      const Text("Powered by Techlapse", style: TextStyle(fontSize: 14, color: Colors.grey)),
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
}