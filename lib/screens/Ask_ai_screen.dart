import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growstreak/screens/chat_screen.dart';

class AskAiScreen extends StatefulWidget {
  const AskAiScreen({super.key});

  @override
  State<AskAiScreen> createState() => _AskAiScreenState();
}

class _AskAiScreenState extends State<AskAiScreen> {
  final List<String> _texts = [
    "Tell your profession and...",
    "Get answers how to stay productive...",
    "How can i be more productive in the days?",
    "What activities i can do if i am free?",
    "What task i can try as a Software engineer?"
  ];

  int _currentIndex = 0;
  String _displayText = "";
  bool _showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startCursorBlinking();
    _startTypingAnimation();
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    super.dispose();
  }

  /// Blinking cursor effect
  void _startCursorBlinking() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
  }

  /// Typing and deleting animation
  Future<void> _startTypingAnimation() async {
    while (true) {
      final text = _texts[_currentIndex];
      // Typing animation
      for (int i = 0; i <= text.length; i++) {
        if (!mounted) return; // Check if widget is still mounted before calling setState
        setState(() {
          _displayText = text.substring(0, i);
        });
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await Future.delayed(const Duration(seconds: 1));

      // Deleting animation
      for (int i = text.length; i >= 0; i--) {
        if (!mounted) return; // Check if widget is still mounted before calling setState
        setState(() {
          _displayText = text.substring(0, i);
        });
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return; // Check if widget is still mounted before calling setState
      setState(() {
        _currentIndex = (_currentIndex + 1) % _texts.length;
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
                image: AssetImage('assets/bgimage.jpg'),
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
          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top-left
              children: [
                const SizedBox(height: 100), // Add vertical spacing from the top
                Text(
                  "Ask ✨",
                  style: GoogleFonts.montserrat(
                    fontSize: 35, // Use fontSize for text size
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Feeling stuck? I'm here to help. Let’s find ways to stay consistent and make every day productive..",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 218, 217, 217),
                  ),
                ),
                const SizedBox(height: 30), // Add space between quote and the animated hint text field
                // Animated Hint Typing Text Field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Border color
                    borderRadius: BorderRadius.circular(40), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      Text(
                        _displayText,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      AnimatedOpacity(
                        opacity: _showCursor ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: const Text(
                          "|",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25,),

                 GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChatScreen()));
                          
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromRGBO(118, 122, 118, 1).withOpacity(0.6),
                                const Color.fromRGBO(95, 99, 95, 1).withOpacity(0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Get Started',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
