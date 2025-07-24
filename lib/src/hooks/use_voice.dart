import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceOptions {
  final void Function(String)? onResult;
  final void Function(String)? onError;
  final String language;

  const VoiceOptions({
    this.onResult,
    this.onError,
    this.language = 'en_IN',
  });
}

class VoiceController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isSupported = false;
  final VoiceOptions options;

  bool get isListening => _isListening;
  bool get isSupported => _isSupported;

  VoiceController({required this.options});

  Future<void> initialize() async {
    _isSupported = await _speech.initialize(
      onError: (error) {
        options.onError?.call(error.errorMsg);
        _isListening = false;
      },
      onStatus: (status) {
        if (status == 'done') {
          _isListening = false;
        }
      },
    );

    if (!_isSupported) {
      options.onError?.call('Speech recognition is not supported on this device');
    }
  }

  Future<void> startListening() async {
    if (_isSupported && !_isListening) {
      _isListening = await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            options.onResult?.call(result.recognizedWords);
          }
        },
        localeId: options.language,
      );
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  Future<void> toggleListening() async {
    if (_isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  void dispose() {
    _speech.cancel();
  }
}

// Usage example
class VoiceExample extends StatefulWidget {
  const VoiceExample({super.key});

  @override
  State<VoiceExample> createState() => _VoiceExampleState();
}

class _VoiceExampleState extends State<VoiceExample> {
  late final VoiceController _voiceController;
  String _transcript = '';

  @override
  void initState() {
    super.initState();
    _voiceController = VoiceController(
      options: VoiceOptions(
        onResult: (transcript) {
          setState(() => _transcript = transcript);
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
        language: 'en_IN',
      ),
    );
    _voiceController.initialize();
  }

  @override
  void dispose() {
    _voiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Recognition')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _voiceController.isListening
                  ? 'Listening...'
                  : 'Press the button to start',
            ),
            const SizedBox(height: 20),
            Text('Transcript: $_transcript'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _voiceController.isSupported
                      ? _voiceController.toggleListening
                      : null,
                  child: Text(
                    _voiceController.isListening ? 'Stop' : 'Start',
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  _voiceController.isSupported
                      ? 'Supported'
                      : 'Not supported',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Hook-like alternative using Provider
class VoiceProvider extends InheritedWidget {
  final VoiceController controller;

  const VoiceProvider({
    super.key,
    required super.child,
    required this.controller,
  });

  static VoiceProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VoiceProvider>();
  }

  @override
  bool updateShouldNotify(VoiceProvider oldWidget) =>
      controller != oldWidget.controller;
}

// Usage with provider
void startVoiceRecognition(BuildContext context) {
  VoiceProvider.of(context)?.controller.startListening();
}