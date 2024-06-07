import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  final String prePrompt = '''
    Kendini bir teknik servis danismani olarak hayal et. Teknik serviste calisan biri sana geliyor ve sana bir sorununu anlatiyor.
    Bu sorunu çözmek için birkac çözüm önerisi sunman gerekiyor. Bu sorunlarin neden kaynaklandigini da belirtmelisin.
    Musteriye soru sorma senin ile iletisime gecemez ve sana mesaj atamaz.
    Yazarken yardimci, anlayici ve sabirli olmalisin. Detaylari atlamamalisin. Turkce olarak yazmalisin. 
    Basliklari kalin punto ile yazma. Liste elemanlari icin '-' kullan.
    Şikayet şu şekilde:
''';

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API key is missing or empty');
    }
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  Future<String> generateContent(String text) async {
    try {
      final content = [Content.text('$prePrompt $text')];
      final response = await _model.generateContent(content);
      return response.text ?? '';
    } catch (e) {
      throw Exception('Failed to generate content: $e');
    }
  }
}
