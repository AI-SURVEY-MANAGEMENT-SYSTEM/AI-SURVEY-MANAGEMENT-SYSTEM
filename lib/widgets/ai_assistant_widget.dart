import 'package:flutter/material.dart';
import '../models/survey_question.dart';
import '../utils/language_utils.dart';
import '../services/gemini_service.dart';
import 'package:shimmer/shimmer.dart';

class AIAssistantWidget extends StatefulWidget {
  final SurveyQuestion question;
  final String languageCode;

  const AIAssistantWidget({
    super.key,
    required this.question,
    required this.languageCode,
  });

  @override
  State<AIAssistantWidget> createState() => _AIAssistantWidgetState();
}

class _AIAssistantWidgetState extends State<AIAssistantWidget> {
  bool _isExpanded = false;
  String? _aiExplanation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAIExplanation();
  }

  Future<void> _loadAIExplanation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final explanation = await GeminiService.getAIExplanation(
        question: widget.question.getTranslatedText(widget.languageCode),
        questionType: widget.question.type.toString().split('.').last,
        languageCode: widget.languageCode,
      );

      if (mounted) {
        setState(() {
          _aiExplanation = explanation;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getExplanation() {
    final questionText = widget.question.getTranslatedText(widget.languageCode);
    final languageName = LanguageUtils.getLanguageName(widget.languageCode);
    
    switch (widget.question.type) {
      case QuestionType.text:
        return _getTextExplanation(questionText, languageName);
      case QuestionType.number:
        return _getNumberExplanation(questionText, languageName);
      case QuestionType.multipleChoice:
        return _getMultipleChoiceExplanation(questionText, languageName);
      case QuestionType.checkbox:
        return _getCheckboxExplanation(questionText, languageName);
      case QuestionType.date:
        return _getDateExplanation(questionText, languageName);
      case QuestionType.time:
        return _getTimeExplanation(questionText, languageName);
      default:
        return _getGeneralExplanation(questionText, languageName);
    }
  }

  String _getTextExplanation(String questionText, String languageName) {
    return 'This is a text question. Please provide a detailed answer in $languageName. '
           'You can write as much as you need to explain your response clearly. '
           'If you are unsure about anything, feel free to ask for clarification.';
  }

  String _getNumberExplanation(String questionText, String languageName) {
    return 'This question requires a numerical answer. Please enter only numbers (no letters or symbols). '
           'For example, if asked for age, enter just the number like "25". '
           'If you are not sure about the exact number, provide your best estimate.';
  }

  String _getMultipleChoiceExplanation(String questionText, String languageName) {
    return 'This is a multiple choice question. You can select only one option from the given choices. '
           'Read all options carefully before making your selection. '
           'If none of the options seem exactly right, choose the one that comes closest to your situation.';
  }

  String _getCheckboxExplanation(String questionText, String languageName) {
    return 'This question allows you to select multiple options. You can choose one, several, or all options that apply to you. '
           'Select all the options that are relevant to your situation. '
           'If none of the options apply, you can leave all unchecked.';
  }

  String _getDateExplanation(String questionText, String languageName) {
    return 'This question asks for a specific date. Tap on the date field to open a calendar where you can select the exact date. '
           'If you are not sure about the exact date, provide your best estimate. '
           'The date format will be automatically handled by the app.';
  }

  String _getTimeExplanation(String questionText, String languageName) {
    return 'This question asks for a specific time. Tap on the time field to open a time picker where you can select the exact time. '
           'You can choose hours and minutes as needed. '
           'If you are not sure about the exact time, provide your best estimate.';
  }

  String _getGeneralExplanation(String questionText, String languageName) {
    return 'This question is part of an official government survey. Please answer honestly and to the best of your knowledge. '
           'Your responses help the government understand the needs of citizens like you. '
           'If you need any clarification, the AI assistant is here to help you understand the question better.';
  }

  String _getTips() {
    switch (widget.question.type) {
      case QuestionType.text:
        return '• Write clearly and provide specific details\n'
               '• If the question is about your experience, describe it thoroughly\n'
               '• You can write in ${LanguageUtils.getLanguageName(widget.languageCode)} or English, whichever you prefer';
      case QuestionType.number:
        return '• Enter only numbers (no text or symbols)\n'
               '• If you don\'t know the exact number, provide your best estimate\n'
               '• For age, enter your current age in years';
      case QuestionType.multipleChoice:
        return '• Read all options before making your choice\n'
               '• Select the option that best describes your situation\n'
               '• If unsure, choose the option that seems most appropriate';
      case QuestionType.checkbox:
        return '• You can select multiple options\n'
               '• Choose all options that apply to your situation\n'
               '• If none apply, you can leave all unchecked';
      case QuestionType.date:
        return '• Use the calendar to select the exact date\n'
               '• If you don\'t remember the exact date, choose your best estimate\n'
               '• The date will be automatically formatted';
      case QuestionType.time:
        return '• Use the time picker to select hours and minutes\n'
               '• If you don\'t remember the exact time, choose your best estimate\n'
               '• The time will be automatically formatted';
      default:
        return '• Answer honestly and to the best of your knowledge\n'
               '• If you need help understanding the question, ask for clarification\n'
               '• Your responses help improve government services';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        leading: Icon(
          Icons.smart_toy,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          'AI Assistant Help',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        subtitle: Text(
          'Tap to get help understanding this question',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Explanation
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Question Explanation',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_isLoading)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                      else
                        Text(
                          _aiExplanation ?? _getExplanation(),
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Refresh AI Explanation Button
                if (!_isLoading)
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _loadAIExplanation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.refresh, size: 16),
                            const SizedBox(width: 4),
                            Text('Refresh AI Help', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Tips
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tips_and_updates,
                            color: Colors.green[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Helpful Tips',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getTips(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Language Note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: Colors.orange[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'You can answer in ${LanguageUtils.getLanguageName(widget.languageCode)} or English. '
                          'The AI assistant will help you understand the question in your preferred language.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 