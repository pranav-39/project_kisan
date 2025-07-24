import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechSynthesisOptions {
  final String? voice;
  final double rate;
  final double pitch;
  final double volume;
  final String lang;

  const SpeechSynthesisOptions({
    this.voice,
    this.rate = 1.0,
    this.pitch = 1.0,
    this.volume = 1.0,
    this.lang = 'en-IN',
  });
}

class SpeechSynthesisController {
  final FlutterTts flutterTts = FlutterTts();
  bool _isSupported = false;
  bool _isSpeaking = false;
  List<dynamic> _voices = [];
  SpeechSynthesisOptions _options;

  bool get isSupported => _isSupported;
  bool get isSpeaking => _isSpeaking;
  List<dynamic> get voices => _voices;
  SpeechSynthesisOptions get options => _options;

  SpeechSynthesisController({SpeechSynthesisOptions? options})
      : _options = options ?? const SpeechSynthesisOptions();

  Future<void> init() async {
    // Check if TTS is available on the device
    _isSupported = await flutterTts.isLanguageAvailable(_options.lang);

    if (_isSupported) {
      // Get available voices
      _voices = await flutterTts.getVoices;

      // Set up listeners for speech events
      flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      flutterTts.setErrorHandler((message) {
        _isSpeaking = false;
        debugPrint('TTS Error: $message');
      });
    }
  }

  Future<void> speak(String text, {SpeechSynthesisOptions? customOptions}) async {
    if (!_isSupported) {
      debugPrint('Speech synthesis is not supported');
      return;
    }

    // Stop any ongoing speech
    await stop();

    // Merge options
    final effectiveOptions = customOptions != null
        ? SpeechSynthesisOptions(
      voice: customOptions.voice ?? _options.voice,
      rate: customOptions.rate ?? _options.rate,
      pitch: customOptions.pitch ?? _options.pitch,
      volume: customOptions.volume ?? _options.volume,
      lang: customOptions.lang ?? _options.lang,
    )
        : _options;

    // Apply options
    await flutterTts.setVoice({"name": effectiveOptions.voice});
    await flutterTts.setSpeechRate(effectiveOptions.rate);
    await flutterTts.setPitch(effectiveOptions.pitch);
    await flutterTts.setVolume(effectiveOptions.volume);
    await flutterTts.setLanguage(effectiveOptions.lang);

    // Speak the text
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    if (_isSupported) {
      await flutterTts.stop();
      _isSpeaking = false;
    }
  }

  Future<void> pause() async {
    if (_isSupported) {
      await flutterTts.pause();
    }
  }

  Future<void> resume() async {
    if (_isSupported) {
      await flutterTts.continueSpeaking();
    }
  }

  void dispose() {
    flutterTts.stop();
  }
}

// Usage example in a Flutter widget
class SpeechSynthesisExample extends StatefulWidget {
  const SpeechSynthesisExample({super.key});

  @override
  State<SpeechSynthesisExample> createState() => _SpeechSynthesisExampleState();
}

class _SpeechSynthesisExampleState extends State<SpeechSynthesisExample> {
  late final SpeechSynthesisController ttsController;
  final textController = TextEditingController(text: 'Hello Flutter!');

  @override
  void initState() {
    super.initState();
    ttsController = SpeechSynthesisController();
    ttsController.init();
  }

  @override
  void dispose() {
    ttsController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech Synthesis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Text to speak'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => ttsController.speak(textController.text),
                  child: const Text('Speak'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: ttsController.stop,
                  child: const Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Status: ${ttsController.isSpeaking ? 'Speaking' : 'Not speaking'}'),
            Text('Supported: ${ttsController.isSupported ? 'Yes' : 'No'}'),
          ],
        ),
      ),
    );
  }
}