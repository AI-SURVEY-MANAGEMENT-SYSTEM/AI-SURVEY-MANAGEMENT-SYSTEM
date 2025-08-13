import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/survey_question.dart';

class GeminiService {

  static Future<String> getAIExplanation({
    required String question,
    required String questionType,
    required String languageCode,
    String? userContext,
  }) async {
    try {
      final prompt = _buildPrompt(question, questionType, languageCode, userContext);
      
      final response = await http.post(
        Uri.parse(ApiConfig.geminiGenerateContent),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': prompt,
                },
              ],
            },
          ],
          'generationConfig': ApiConfig.geminiConfig,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List;
          if (parts.isNotEmpty) {
            return parts[0]['text'] as String;
          }
        }
        return _getDefaultExplanation(questionType, languageCode);
      } else {
        print('Gemini API Error: ${response.statusCode} - ${response.body}');
        return _getDefaultExplanation(questionType, languageCode);
      }
    } catch (e) {
      print('Gemini Service Error: $e');
      return _getDefaultExplanation(questionType, languageCode);
    }
  }

  static String _buildPrompt(String question, String questionType, String languageCode, String? userContext) {
    final languageName = _getLanguageName(languageCode);
    
    return '''
You are an AI assistant helping users complete government surveys in India. The user is answering a survey question in $languageName.

Question: $question
Question Type: $questionType
User's Language: $languageName
${userContext != null ? 'User Context: $userContext' : ''}

Please provide a helpful explanation in $languageName that:
1. Explains what the question is asking in simple, clear terms
2. Provides guidance on how to answer based on the question type
3. Uses respectful, culturally appropriate language
4. Helps users with low digital literacy understand the question
5. Offers practical tips for providing accurate answers

Keep the explanation friendly, encouraging, and easy to understand. Focus on helping the user provide accurate and complete information.
''';
  }

  static String _getDefaultExplanation(String questionType, String languageCode) {
    final languageName = _getLanguageName(languageCode);
    
    switch (questionType) {
      case 'text':
        return 'यह एक पाठ प्रश्न है। कृपया $languageName में विस्तृत उत्तर दें। आप जितना चाहें उतना लिख सकते हैं।';
      case 'number':
        return 'इस प्रश्न के लिए केवल संख्या दर्ज करें। उदाहरण के लिए, उम्र के लिए "25" लिखें।';
      case 'multipleChoice':
        return 'यह एक बहुविकल्पी प्रश्न है। दिए गए विकल्पों में से केवल एक का चयन करें।';
      case 'checkbox':
        return 'इस प्रश्न में आप कई विकल्प चुन सकते हैं। अपनी स्थिति के अनुसार सभी लागू विकल्पों का चयन करें।';
      default:
        return 'कृपया इस प्रश्न का उत्तर देने में मदद के लिए AI सहायक का उपयोग करें।';
    }
  }

  static String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'Hindi';
      case 'bn':
        return 'Bengali';
      case 'ta':
        return 'Tamil';
      case 'te':
        return 'Telugu';
      case 'mr':
        return 'Marathi';
      case 'kn':
        return 'Kannada';
      case 'ml':
        return 'Malayalam';
      case 'gu':
        return 'Gujarati';
      case 'pa':
        return 'Punjabi';
      case 'or':
        return 'Odia';
      case 'as':
        return 'Assamese';
      default:
        return 'English';
    }
  }

  static Future<String> getClarification({
    required String question,
    required String userAnswer,
    required String languageCode,
  }) async {
    try {
      final prompt = '''
You are an AI assistant helping users complete government surveys in India. The user has provided an answer that might need clarification.

Question: $question
User's Answer: $userAnswer
Language: ${_getLanguageName(languageCode)}

Please provide a gentle, helpful clarification in ${_getLanguageName(languageCode)} that:
1. Acknowledges their effort
2. Politely asks for more specific information if needed
3. Provides examples of what kind of information would be helpful
4. Maintains a supportive and encouraging tone

Keep it brief, friendly, and helpful.
''';

      final response = await http.post(
        Uri.parse(ApiConfig.geminiGenerateContent),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': prompt,
                },
              ],
            },
          ],
          'generationConfig': {
            ...ApiConfig.geminiConfig,
            'maxOutputTokens': 512,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List;
          if (parts.isNotEmpty) {
            return parts[0]['text'] as String;
          }
        }
      }
      
      return 'धन्यवाद! क्या आप कुछ और विवरण दे सकते हैं?';
    } catch (e) {
      print('Gemini Clarification Error: $e');
      return 'धन्यवाद! क्या आप कुछ और विवरण दे सकते हैं?';
    }
  }

  static Future<List<SurveyQuestion>> generateSurveyQuestions({
    required String languageCode,
    int count = 5,
    String? topic,
  }) async {
    final prompt = '''
Generate a list of $count simple, official government survey questions${topic != null ? ' about $topic' : ''} suitable for rural Indian citizens. Each question should include:
- question text (in $languageCode)
- type (text, number, or multipleChoice)
- 3-4 options if it’s multiple choice
Respond ONLY with a valid JSON array, no explanation or extra text. Example:
[
  {"text": "What is your name?", "type": "text"},
  {"text": "What is your age?", "type": "number"},
  {"text": "What is your gender?", "type": "multipleChoice", "options": ["Male", "Female", "Other"]}
]
''';
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.geminiGenerateContent),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': ApiConfig.geminiConfig,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            final text = parts[0]['text'] as String;
            // Try to extract JSON array from the text (robust)
            final jsonArrayMatch = RegExp(r'(\[.*?\])', dotAll: true).firstMatch(text);
            if (jsonArrayMatch != null) {
              final jsonString = jsonArrayMatch.group(0)!;
              final List<dynamic> jsonList = jsonDecode(jsonString);
              return jsonList.map((q) => SurveyQuestion(
                id: DateTime.now().millisecondsSinceEpoch.toString() + (q['text'] ?? ''),
                text: q['text'] ?? '',
                type: _parseType(q['type']),
                options: q['options'] != null ? List<String>.from(q['options']) : null,
                isRequired: true,
                translations: {languageCode: q['text'] ?? ''},
              )).toList();
            } else {
              print('Gemini response did not contain a valid JSON array. Response text: $text');
            }
          } else {
            print('Gemini response parts missing or empty: $content');
          }
        } else {
          print('Gemini response candidates missing or empty: $data');
        }
      } else {
        print('Gemini API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Gemini generateSurveyQuestions error: $e');
    }
    // Fallback: return default questions
    return [
      SurveyQuestion(
        id: 'default1',
        text: 'What is your name?',
        type: QuestionType.text,
        isRequired: true,
        translations: {languageCode: 'What is your name?'},
      ),
      SurveyQuestion(
        id: 'default2',
        text: 'What is your age?',
        type: QuestionType.number,
        isRequired: true,
        translations: {languageCode: 'What is your age?'},
      ),
      SurveyQuestion(
        id: 'default3',
        text: 'What is your gender?',
        type: QuestionType.multipleChoice,
        options: ['Male', 'Female', 'Other'],
        isRequired: true,
        translations: {languageCode: 'What is your gender?'},
      ),
    ];
  }

  static QuestionType _parseType(String? type) {
    switch (type) {
      case 'text':
        return QuestionType.text;
      case 'number':
        return QuestionType.number;
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      default:
        return QuestionType.text;
    }
  }
} 