import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceController  extends StatefulWidget {
  final Function(String) onComando; // Callback para enviar el comando a HomeScreen

  const VoiceController({Key? key, required this.onComando}) : super(key: key);

  @override
  _VoiceControllerState createState() => _VoiceControllerState();
}

class _VoiceControllerState extends State<VoiceController> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _speech.initialize();
  }

  Future<void> _startListening() async {
    bool disponible = await _speech.initialize();
    if (disponible) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() => _recognizedText = result.recognizedWords);
          widget.onComando(result.recognizedWords); // Manda el texto a HomeScreen
        },
      );
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _recognizedText.isEmpty ? 'Di un comando...' : _recognizedText,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: _isListening ? _stopListening : _startListening,
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            size: 40,
            color: _isListening ? Colors.red : Colors.blue,
          ),
        ),
      ],
    );
  }
}