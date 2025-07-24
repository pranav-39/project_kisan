import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:project_kisan/services/voice_command_service.dart';
import 'package:go_router/go_router.dart';

class FloatingVoiceButton extends StatefulWidget {
  const FloatingVoiceButton({super.key});

  @override
  State<FloatingVoiceButton> createState() => _FloatingVoiceButtonState();
}

class _FloatingVoiceButtonState extends State<FloatingVoiceButton> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          _showToast(context, 'Voice Error: ${error.errorMsg}');
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: _onResult);
      } else {
        _showToast(context, 'Speech recognition not supported');
      }
    }
  }

  void _onResult(stt.SpeechRecognitionResult result) async {
    if (result.finalResult) {
      String transcript = result.recognizedWords;
      await _flutterTts.speak("I heard: $transcript");
      final command = processVoiceCommand(transcript);

      switch (command.intent) {
        case 'scan_disease':
          context.go('/scan');
          await _flutterTts.speak('Opening disease scanner');
          break;
        case 'market_price':
          context.go('/market');
          if (command.entity != null) {
            await _flutterTts.speak('Checking ${command.entity} prices');
          } else {
            await _flutterTts.speak('Opening market prices');
          }
          break;
        case 'government_scheme':
          context.go('/schemes');
          await _flutterTts.speak('Opening government schemes');
          break;
        case 'weather':
          context.go('/weather');
          await _flutterTts.speak('Checking weather information');
          break;
        default:
          await _flutterTts.speak(
              'I can help you with crop scanning, market prices, government schemes, or weather information. What would you like to know?');
      }
    }
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      right: 16,
      child: FloatingActionButton(
        onPressed: _toggleListening,
        backgroundColor: _isListening ? Colors.red : const Color(0xFFF97316),
        child: Icon(
          _isListening ? Icons.stop : Icons.mic,
          size: 28,
        ),
      ),
    );
  }
}
