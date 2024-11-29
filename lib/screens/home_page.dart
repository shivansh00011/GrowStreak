import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:growstreak/screens/create_task.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String greetingMessage = "";
  String? userName;

  @override
  void initState() {
    super.initState();
    updateGreetingMessage();
    fetchUserName();
  }

  void updateGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      greetingMessage = "Good Morning!";
    } else if (hour >= 12 && hour < 17) {
      greetingMessage = "Good Afternoon!";
    } else if (hour >= 17 && hour < 20) {
      greetingMessage = "Good Evening!";
    } else {
      greetingMessage = "Good Night!";
    }
  }

  Future<void> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        setState(() {
          userName = userDoc.data()?['name'] ?? 'Guest';
        });
      } else {
        setState(() {
          userName = 'Guest';
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
      setState(() {
        userName = 'Guest';
      });
    }
  }

  Color parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
      } else {
        return Colors.primaries.firstWhere(
          (color) => color.toString().toLowerCase().contains(colorString.toLowerCase()),
          orElse: () => Colors.grey,
        );
      }
    } catch (e) {
      print("Error parsing color: $e");
      return Colors.grey;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd MMM yyyy').format(currentDate);
    final dayOfWeek = DateFormat('EEEE').format(currentDate);

    final user = FirebaseAuth.instance.currentUser;

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
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        greetingMessage,
                        style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (userName != null)
                        Text(
                          'Welcome, $userName',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/sparkle.jpg'),
                            fit: BoxFit.cover,
                            opacity: 0.6,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromRGBO(118, 122, 118, 1).withOpacity(0.8),
                              const Color.fromRGBO(95, 99, 95, 1).withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 38, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              Text(
                                'We are what we repeatedly do.\nExcellence, then, is not an act,\nbut a habit.',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 235, 234, 234),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.only(left: 190),
                                child: Text(
                                  '~ Aristotle',
                                  style: GoogleFonts.theNautigal(
                                    color: const Color.fromARGB(255, 235, 234, 234),
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            dayOfWeek,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Today's Task",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Displaying tasks from Firestore
                      user != null
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('tasks')
                                  .where('uid', isEqualTo: user.uid)
                                  .orderBy('createdAt', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  print("Firestore error: ${snapshot.error}");
                                  return const Text(
                                    'Error fetching tasks.',
                                    style: TextStyle(color: Colors.white),
                                  );
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return const Text(
                                    'No tasks found.',
                                    style: TextStyle(color: Colors.white),
                                  );
                                }

                                final tasks = snapshot.data!.docs;
                                return Column(
                                  children: tasks.map((task) {
                                    final data = task.data() as Map<String, dynamic>;
                                    final taskId = task.id;

                                    if (!data.containsKey('taskName') || !data.containsKey('selectedColor')) {
                                      return const Text(
                                        'Invalid task data.',
                                        style: TextStyle(color: Colors.red),
                                      );
                                    }
                                    final taskColor = parseColor(data['selectedColor']);
                                    return Container(
                                      height: 90,
                                      width: double.maxFinite,
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: taskColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['taskName'],
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8,),
                                              Text(data['selectedTime'],
                                              style: GoogleFonts.montserrat(
                                                  color: const Color.fromARGB(255, 216, 216, 216),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),)
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.white),
                                            onPressed: () {
                                              deleteTask(taskId);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            )
                          : const Text(
                              'Please log in to see your tasks.',
                              style: TextStyle(color: Colors.white),
                            ),
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreateTask()),
                          );
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
                            'Create New Task',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 200),
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
