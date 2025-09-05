import 'package:flutter_tts/flutter_tts.dart';

class TTSHelper {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speak(String text, {String lang = "en-IN"}) async {
    await _tts.setLanguage(lang);
    await _tts.setSpeechRate(0.9); // slower for rural users
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }
}
