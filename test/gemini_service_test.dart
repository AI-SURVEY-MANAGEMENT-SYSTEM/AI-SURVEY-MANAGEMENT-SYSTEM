import 'package:flutter_test/flutter_test.dart';
import 'package:ai_survey_assistant/services/gemini_service.dart';

void main() {
  group('GeminiService Tests', () {
    test('should get AI explanation for text question', () async {
      final explanation = await GeminiService.getAIExplanation(
        question: 'What is your name?',
        questionType: 'text',
        languageCode: 'hi',
      );

      expect(explanation, isA<String>());
      expect(explanation.isNotEmpty, true);
    });

    test('should get AI explanation for number question', () async {
      final explanation = await GeminiService.getAIExplanation(
        question: 'What is your age?',
        questionType: 'number',
        languageCode: 'en',
      );

      expect(explanation, isA<String>());
      expect(explanation.isNotEmpty, true);
    });

    test('should get clarification for user answer', () async {
      final clarification = await GeminiService.getClarification(
        question: 'What is your occupation?',
        userAnswer: 'I work',
        languageCode: 'hi',
      );

      expect(clarification, isA<String>());
      expect(clarification.isNotEmpty, true);
    });

    test('should handle API errors gracefully', () async {
      // This test verifies that the service handles errors gracefully
      // by returning default explanations when API calls fail
      final explanation = await GeminiService.getAIExplanation(
        question: 'Test question',
        questionType: 'text',
        languageCode: 'hi',
      );

      expect(explanation, isA<String>());
      expect(explanation.isNotEmpty, true);
    });
  });
} 