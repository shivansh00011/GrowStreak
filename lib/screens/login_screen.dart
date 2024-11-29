import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growstreak/screens/forgotpassword_screen.dart';
import 'package:growstreak/screens/home_screen.dart';
import 'package:growstreak/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = "", password = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
    bool isLoading = false;

  // Firebase Authentication Method for Sign In
  Future<void> loginUser() async {
    setState(() {
      isLoading = true; // Start loading spinner
    });

    try {
      // Firebase authentication for signing in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to HomePage on successful login
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));

    } catch (e) {
      // Display an error message if sign in fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid credentials. Please try again."),
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading spinner
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/one.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Black Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Login Heading
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Text(
                    'Login',
                    style: GoogleFonts.montserrat(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 212, 211, 211),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Welcome Back Subheading
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 130),
                // Email Label
                Text(
                  'Email',
                  style: GoogleFonts.montserrat(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 21),
                // Email Input Field
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child:  Center(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15, // Centers the text vertically
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        hintText: "Enter Your E-mail",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  'Password',
                  style: GoogleFonts.montserrat(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 21),
                // Password Input Field
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child:  Center(
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15, // Centers the text vertically
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: "Enter Your Password",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 19,),
                Padding(
                  padding: const EdgeInsets.only(left: 250),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPasswordScreen()));
                    },
                    child: Text('Forgot Password?', style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey),)),
                ),
                const SizedBox(height: 34),
                // Login Button
              Center(
  child: isLoading? const Center(child: CircularProgressIndicator()) : Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Semi-transparent color
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextButton(
              onPressed: () {
                loginUser();
              },
              child: Text(
                "Login",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 30), // Reduce spacing
      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpScreen() ));
        },
        child: Text(
          "Don't have an account?",
          style: GoogleFonts.montserrat(
            fontSize: 15, // Adjust font size if needed
            color: Colors.grey,
          ),
        ),
      ),
    ],
  ),
),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
