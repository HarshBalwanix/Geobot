import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const QueryPage());
}

class QueryPage extends StatefulWidget {
  const QueryPage({Key? key}) : super(key: key);

  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _query = '';
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _controller.text = result.recognizedWords;
    setState(() {
      _query = result.recognizedWords;
    });
  }

  String formatServerResponse(Map<String, dynamic> response) {
    List<String> formattedEntities = [];

    if (response['city_entities'] != null && response['city_entities'].isNotEmpty) {
      formattedEntities.add("Cities:\n ${response['city_entities'].join(', ')}");
    }

    if (response['country_entities'] != null && response['country_entities'].isNotEmpty) {
      formattedEntities.add("Countries:\n ${response['country_entities'].join(', ')}");
    }

    if (response['state_entities'] != null && response['state_entities'].isNotEmpty) {
      formattedEntities.add("States:\n ${response['state_entities'].join(', ')}");
    }

    return formattedEntities.join('\n');
  }

  Future<void> _sendMessage(String message) async {
    final query = message.trim();
    if(query.isNotEmpty)
    {
    const serverUrl = 'https://geobot-backend.onrender.com/api/categorize'; // Replace with your server's URL

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'text': query}),
      );

      if (response.statusCode == 200) {
        final serverResponse = json.decode(response.body);
        final formattedResponse = formatServerResponse(serverResponse);

        if (formattedResponse.isNotEmpty) {
          setState(() {
            _messages.add(ChatMessage(text: ' $query', isUserMessage: true));
            _messages.add(ChatMessage(text: ' $formattedResponse', isUserMessage: false));
          });
        } else {
          // If the response is empty, add a message saying that no place name was found
          setState(() {
            _messages.add(ChatMessage(text: ' $query', isUserMessage: true));
            _messages.add(ChatMessage(text: 'Sorry, we can\'t find any place name', isUserMessage: false));
          });
        }
      } else {
        print('Failed to send the query to the server. Status code: ${response.statusCode}');
        // Add a message indicating that the server is not responding
        setState(() {
          _messages.add(ChatMessage(text: 'Server is not responding. Try again later.', isUserMessage: false));
        });
      }
    } catch (e) {
      print('Error sending request: $e');
      // Add a message indicating that the request failed
      setState(() {
        _messages.add(ChatMessage(text: 'Failed to send the query. Try again later.', isUserMessage: false));
      });
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Geobot Query!"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ListTile(
                    title: Align(
                      alignment: message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: message.isUserMessage ? Colors.orange : Colors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: message.isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.isUserMessage ? 'You' : 'Geobot',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              message.text,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter your Query here',
                          prefixIcon: IconButton(
                            onPressed: _speechToText.isListening ? _stopListening : _startListening,
                            icon: Icon(_speechToText.isListening ? Icons.mic_off : Icons.mic),
                            color: const Color.fromRGBO(226, 152, 5, 1),
                          ),
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Material(
                        color: const Color.fromRGBO(226, 152, 5, 1),
                        child: IconButton(
                          onPressed: () {
                            final userMessage = _controller.text;
                            _controller.clear();
                            _sendMessage(userMessage);
                          },
                          icon: const Icon(Icons.send),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});
}