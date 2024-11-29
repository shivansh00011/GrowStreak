import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // List to hold messages
  final List<Map<String, String>> _messages = [
    {
      "sender": "AI",
      "text": "Hello! I am your AI habit assistant. You can ask me how to stay productive or build better habits!",
    },
  ];

  // Controller for the text input field
  final TextEditingController _textController = TextEditingController();

  // Replace with your API details
  final String apiUrl =
      "YOUR_API_URL";
  final String accessToken =
      "YOUR_ACCESS_TOKEN";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bgimage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: const Text(
            "Ask Here!",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
           iconTheme: const IconThemeData(
    color: Colors.white, // Back button icon in white
  ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image for the rest of the screen
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bgimage.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Black Overlay for better text visibility
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message["sender"] == "User";

                    return Container(
  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
  padding: const EdgeInsets.all(8),
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * (isUser ? 0.5 : 0.7), // Adjust width
    ),
    child: Container(
      decoration: BoxDecoration(
        color: isUser ? Colors.blueAccent : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isUser ? 10 : 0),
          topRight: Radius.circular(isUser ? 0 : 10),
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Text(
        message["text"] ?? "",
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    ),
  ),
);

                  },
                ),
              ),
              // User Input Field
            Padding(
  padding: const EdgeInsets.fromLTRB(16, 0, 16, 34), // Adjust the bottom padding to raise the input area
  child: Row(
    children: [
      // Text Field
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38), // Rounded corners for the input field
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: "Type your message...",
              filled: true,
              fillColor: Colors.white.withOpacity(0.7),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      const SizedBox(width: 8), // Space between TextField and Send Button
      // Send Button
      CircleAvatar(
        backgroundColor: Colors.blueAccent,
        radius: 24, // Circular button
        child: IconButton(
          icon: const Icon(Icons.send, color: Colors.white),
          onPressed: () {
            _sendMessage();
          },
        ),
      ),
    ],
  ),
),


            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.insert(0, {"sender": "User", "text": text});
      });

      final aiResponse = await geminiFineTuneMethod(text);

      setState(() {
        _messages.insert(0, {"sender": "AI", "text": aiResponse});
      });

      _textController.clear();
    }
  }

  Future<String> geminiFineTuneMethod(String userInput) async {
    // Define headers for the API request
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // Construct the payload based on the working Postman format
    final data = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": userInput,
            }
          ]
        }
      ]
    });

    // Debugging: Print headers and payload
    print('API URL: $apiUrl');
    print('Headers: $headers');
    print('Payload: $data');

    try {
      // Send POST request to the API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: data,
      );

      // Debugging: Print response details
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body if successful
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print('Parsed JSON Data: $jsonData'); // Debugging

        // Safely extract the response text
        if (jsonData.containsKey('candidates') && jsonData['candidates'] is List) {
          final List candidates = jsonData['candidates'];
          if (candidates.isNotEmpty && candidates[0] is Map) {
            final content = candidates[0]['content'];
            if (content is Map && content.containsKey('parts')) {
              final parts = content['parts'] as List;
              if (parts.isNotEmpty && parts[0] is Map && parts[0].containsKey('text')) {
                final text = parts[0]['text'];
                if (text is String) {
                  return text; // Return the extracted response text
                }
              }
            }
          }
        }

        // Default fallback if no valid content is found
        return "No response from the model.";
      } else {
        // Return error message for non-200 responses
        return "Error: ${response.body}";
      }
    } catch (e) {
      // Handle and print any exceptions during the request
      print('Error occurred: $e');
      return "An error occurred: $e";
    }
  }
}
