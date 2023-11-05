// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:http/http.dart' as http;

// class QueryPage extends StatefulWidget {
//   QueryPage({Key? key}) : super(key: key);

//   @override
//   _QueryPageState createState() => _QueryPageState();
// }

// class _QueryPageState extends State<QueryPage> {
//   SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   String _query = '';
//   TextEditingController _controller = TextEditingController();
//   List<ChatMessage> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   void _initSpeech() async {
//     _speechEnabled = await _speechToText.initialize();
//     setState(() {});
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }

//   void _startListening() async {
//     await _speechToText.listen(onResult: _onSpeechResult);
//     setState(() {});
//   }

//   void _onSpeechResult(SpeechRecognitionResult result) {
//     _controller.text = result.recognizedWords;
//     setState(() {
//       _query = result.recognizedWords;
//     });
//   }

//   Future<void> _sendMessage(String message) async {
//     final query = message;
//     final serverUrl = 'https://geobot-backend.onrender.com/api/categorize'; // Replace with your server's URL

//     final response = await http.post(
//       Uri.parse(serverUrl),
//       headers: {'Content-Type': 'application/json',},
//       body: {'text': query},
      
//     );

//     if (response.statusCode == 200) {
//       final serverResponse = response.body;
//       // Add the user's message and the server's response to the chat
//       setState(() {
//         _messages.add(ChatMessage(text: _query, isUserMessage: true));
//         _messages.add(ChatMessage(text: serverResponse, isUserMessage: false));
//       });
//     } else {
//       // Handle server errors or other cases
//       print('Failed to send the query to the server. Status code: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Geobot Query!"),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _messages.length,
//                 itemBuilder: (context, index) {
//                   final message = _messages[index];
//                  return ListTile(
//                    title: Align(
//                     alignment: message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
//                     child: Text(message.text),
//                   ),
//                 );

//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: TextField(
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter your Query here',
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   onPressed: _speechToText.isListening ? _stopListening : _startListening,
//                   icon: Icon(_speechToText.isListening ? Icons.mic_off : Icons.mic),
//                   iconSize: 30,
//                   color: const Color.fromRGBO(226, 152, 5, 1),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final userMessage = _controller.text;
//                     _controller.clear();
//                     _sendMessage(userMessage);
//                   },
//                   child: Text('Send'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatMessage {
//   final String text;
//   final bool isUserMessage;

//   ChatMessage({required this.text, required this.isUserMessage});
// }



import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class QueryPage extends StatefulWidget {
  QueryPage({Key? key}) : super(key: key);

  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _words = '';
  TextEditingController _controller = TextEditingController();

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
      _words = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Geobot Qwery!"),
        ),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // Align content at the bottom
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffix: IconButton(
                      onPressed:
                          _speechToText.isListening ? _stopListening : _startListening,
                      icon: Icon(
                        _speechToText.isListening ? Icons.mic_off : Icons.mic,
                      ),
                      iconSize: 30,
                      color: const Color.fromRGBO(226, 152, 5, 1),
                    ),
                    hintText: 'Enter your Query here',
                  ),
                ),
              ),
              // Text(
              //       _speechToText.isListening
              //         ? _words
              //         : '',
              //     ),
            ],
          ),
        ),
      ),
    );
  }
}
