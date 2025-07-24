// speech_config.dart
class SpeechConfig {
  final String language;
  final double rate;
  final double pitch;
  final double volume;

  const SpeechConfig({
    this.language = 'en-IN',
    this.rate = 1.0,
    this.pitch = 1.0,
    this.volume = 1.0,
  });

  static const SpeechConfig defaultConfig = SpeechConfig();
}

const Map<String, String> languageVoiceMap = {
  'en': 'en-IN',
  'hi': 'hi-IN',
  'kn': 'kn-IN',
  'te': 'te-IN',
};

String getVoiceForLanguage(String language) {
  return languageVoiceMap[language] ?? 'en-IN';
}

// voice_command.dart
class VoiceCommandResult {
  final String intent;
  final String? entity;
  final double confidence;

  const VoiceCommandResult({
    required this.intent,
    this.entity,
    this.confidence = 1.0,
  });
}

VoiceCommandResult processVoiceCommand(String transcript) {
  final lowerTranscript = transcript.toLowerCase();

  // Disease scanning intents
  if (lowerTranscript.contains('scan') ||
      lowerTranscript.contains('disease') ||
      lowerTranscript.contains('crop')) {
    return VoiceCommandResult(
      intent: 'scan_disease',
      confidence: 0.9,
    );
  }

  // Market price intents
  if (lowerTranscript.contains('price') ||
      lowerTranscript.contains('market') ||
      lowerTranscript.contains('rate')) {
    const crops = ['tomato', 'onion', 'rice', 'wheat', 'maize'];
    final foundCrop = crops.firstWhere(
          (crop) => lowerTranscript.contains(crop),
      orElse: () => '',
    );

    return VoiceCommandResult(
      intent: 'market_price',
      entity: foundCrop.isNotEmpty ? foundCrop : null,
      confidence: foundCrop.isNotEmpty ? 0.9 : 0.7,
    );
  }

  // Scheme intents
  if (lowerTranscript.contains('scheme') ||
      lowerTranscript.contains('subsidy') ||
      lowerTranscript.contains('government')) {
    return VoiceCommandResult(
      intent: 'government_scheme',
      confidence: 0.8,
    );
  }

  // Weather intents
  if (lowerTranscript.contains('weather') ||
      lowerTranscript.contains('rain') ||
      lowerTranscript.contains('temperature')) {
    return VoiceCommandResult(
      intent: 'weather',
      confidence: 0.8,
    );
  }

  // General query
  return VoiceCommandResult(
    intent: 'general_query',
    confidence: 0.5,
  );
}