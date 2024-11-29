import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  String taskName = "New Task";
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();
  String selectedTime = "Anytime"; // Default selected time
  String selectedColor = ""; // Holds the selected color in hex format

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                // Editable Task Name Section
                Row(
                  children: [
                    if (!isEditing)
                      Text(
                        taskName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (isEditing)
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          onSubmitted: (value) {
                            setState(() {
                              taskName = value.isNotEmpty ? value : taskName;
                              isEditing = false;
                            });
                          },
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Task Name",
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        isEditing ? Icons.check : Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isEditing) {
                            taskName = _controller.text.isNotEmpty
                                ? _controller.text
                                : taskName;
                          } else {
                            _controller.text = taskName;
                          }
                          isEditing = !isEditing;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Regular Task',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 208, 208, 208),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Do it at',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                // Time Selection Buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildTimeButton("Anytime", Icons.access_time),
                        const SizedBox(width: 10),
                        buildTimeButton("Morning", Icons.wb_sunny_outlined),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildTimeButton("Afternoon", Icons.wb_sunny),
                        const SizedBox(width: 10),
                        buildTimeButton("Evening", Icons.nightlight_round),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Color",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                // Color Palette Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildColorPalette(const Color(0xFF001F54), '#001F54'), // Navy Blue
buildColorPalette(const Color(0xFF004225), '#004225'), // Dark Green
buildColorPalette(const Color(0xFF4A0072), '#4A0072'), // Deep Purple
buildColorPalette(const Color(0xFFFF5252), '#FF5252'), // Red Accent
                  ],
                ),
                const SizedBox(height: 70),
                GestureDetector(
                  onTap: saveTask,
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
                      border:
                          Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Save Task",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

  Widget buildTimeButton(String time, IconData icon) {
    final bool isSelected = time == selectedTime;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTime = time;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? null
                : Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1,
                  ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                time,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColorPalette(Color color, String colorHex) {
    bool isSelectedColor = selectedColor == colorHex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = colorHex; // Store the hex color directly
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelectedColor ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }

 Future<void> saveTask() async {
  final User? user = _auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You must be logged in to save tasks.')),
    );
    return;
  }

  // Ensure the latest text from the controller is used
  setState(() {
    if (_controller.text.isNotEmpty) {
      taskName = _controller.text;
    }
  });

  // Save task to Firestore
  try {
    await _firestore.collection('tasks').add({
      'uid': user.uid, // Associate task with user ID
      'taskName': taskName, // Use the updated task name
      'selectedTime': selectedTime,
      'selectedColor': selectedColor, // Save the hex color
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task saved successfully!')),
    );

    Navigator.pop(context);
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error saving task.')),
    );
  }
}

  }

