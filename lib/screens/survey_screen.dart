import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/survey_question.dart';
import '../models/survey_response.dart';
import '../providers/language_provider.dart';
import '../providers/survey_provider.dart';
import '../utils/language_utils.dart';
import '../widgets/question_widget.dart';
import '../widgets/ai_assistant_widget.dart';
import 'survey_completion_screen.dart';
import '../widgets/app_drawer.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  TextEditingController _textController = TextEditingController();
  String? _selectedOption;
  List<String> _selectedCheckboxes = [];

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    
    _fadeController.forward();
    _slideController.forward();
    
    _textController.addListener(() {
      setState(() {});
    });
    
    // Load current answer when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentAnswer();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _loadCurrentAnswer() {
    final surveyProvider = context.read<SurveyProvider>();
    final currentQuestion = surveyProvider.currentQuestion;
    if (currentQuestion != null) {
      final existingResponse = surveyProvider.getResponseForQuestion(currentQuestion.id);
      if (existingResponse != null) {
        setState(() {
          switch (currentQuestion.type) {
            case QuestionType.text:
            case QuestionType.number:
              _textController.text = existingResponse.answer.toString();
              break;
            case QuestionType.multipleChoice:
              _selectedOption = existingResponse.answer.toString();
              break;
            case QuestionType.checkbox:
              if (existingResponse.answer is List) {
                _selectedCheckboxes = List<String>.from(existingResponse.answer);
              }
              break;
            default:
              break;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Consumer2<LanguageProvider, SurveyProvider>(
          builder: (context, languageProvider, surveyProvider, child) {
            final currentQuestion = surveyProvider.currentQuestion;
            
            if (currentQuestion == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Progress Header
                      _buildProgressHeader(context, surveyProvider),
                      
                      const SizedBox(height: 24),
                      
                      // Question Section
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Question Card
                              _buildQuestionCard(context, currentQuestion, languageProvider),
                              
                              const SizedBox(height: 20),
                              
                              // AI Assistant
                              AIAssistantWidget(
                                question: currentQuestion,
                                languageCode: languageProvider.currentLanguageCode,
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Answer Input
                              QuestionWidget(
                                question: currentQuestion,
                                languageCode: languageProvider.currentLanguageCode,
                                textController: _textController,
                                selectedOption: _selectedOption,
                                selectedCheckboxes: _selectedCheckboxes,
                                onOptionSelected: (option) {
                                  setState(() {
                                    _selectedOption = option;
                                  });
                                },
                                onCheckboxChanged: (option, isSelected) {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedCheckboxes.add(option);
                                    } else {
                                      _selectedCheckboxes.remove(option);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Navigation Buttons
                      _buildNavigationButtons(context, surveyProvider),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Survey'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Consumer<SurveyProvider>(
          builder: (context, surveyProvider, child) {
            return IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _showExitDialog(context, surveyProvider),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressHeader(BuildContext context, SurveyProvider surveyProvider) {
    final currentIndex = surveyProvider.currentQuestionIndex;
    final totalQuestions = surveyProvider.questions.length;
    final progress = (currentIndex + 1) / totalQuestions;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.quiz,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${currentIndex + 1} of $totalQuestions',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Survey Progress',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).round()}% Complete',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, SurveyQuestion question, LanguageProvider languageProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.question_mark,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Question',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              question.getTranslatedText(languageProvider.currentLanguageCode),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            if (question.isRequired) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.red[400],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Required',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red[400],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, SurveyProvider surveyProvider) {
    final currentQuestion = surveyProvider.currentQuestion;
    if (currentQuestion == null) return const SizedBox.shrink();

    final isFirstQuestion = surveyProvider.currentQuestionIndex == 0;
    final isLastQuestion = surveyProvider.currentQuestionIndex == surveyProvider.questions.length - 1;
    final hasAnswer = _hasValidAnswer(currentQuestion);

    return Row(
      children: [
        // Previous Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isFirstQuestion ? null : () => _previousQuestion(surveyProvider),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Next/Complete Button
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: hasAnswer ? () => _nextQuestion(surveyProvider) : null,
            icon: Icon(isLastQuestion ? Icons.check : Icons.arrow_forward),
            label: Text(isLastQuestion ? 'Complete' : 'Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  bool _hasValidAnswer(SurveyQuestion question) {
    switch (question.type) {
      case QuestionType.text:
        return _textController.text.trim().isNotEmpty;
      case QuestionType.number:
        return _textController.text.trim().isNotEmpty;
      case QuestionType.multipleChoice:
        return _selectedOption != null;
      case QuestionType.checkbox:
        return _selectedCheckboxes.isNotEmpty;
      case QuestionType.date:
      case QuestionType.time:
        return _textController.text.trim().isNotEmpty;
      default:
        return true;
    }
  }

  void _saveAnswer(SurveyProvider surveyProvider) {
    final currentQuestion = surveyProvider.currentQuestion;
    if (currentQuestion == null) return;

    dynamic answer;
    switch (currentQuestion.type) {
      case QuestionType.text:
      case QuestionType.number:
        answer = _textController.text.trim();
        break;
      case QuestionType.multipleChoice:
        answer = _selectedOption;
        break;
      case QuestionType.checkbox:
        answer = _selectedCheckboxes;
        break;
      case QuestionType.date:
      case QuestionType.time:
        answer = _textController.text.trim();
        break;
      default:
        answer = _textController.text.trim();
    }

    if (answer != null && answer.toString().isNotEmpty) {
      final response = SurveyResponse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        questionId: currentQuestion.id,
        answer: answer,
        timestamp: DateTime.now(),
        languageCode: context.read<LanguageProvider>().currentLanguageCode,
      );
      
      surveyProvider.addResponse(response);
    }
  }

  void _nextQuestion(SurveyProvider surveyProvider) {
    _saveAnswer(surveyProvider);
    
    if (surveyProvider.currentQuestionIndex < surveyProvider.questions.length - 1) {
      surveyProvider.nextQuestion();
      _resetInputs();
      _loadCurrentAnswer();
    } else {
      // Survey completed
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SurveyCompletionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  void _previousQuestion(SurveyProvider surveyProvider) {
    _saveAnswer(surveyProvider);
    
    if (surveyProvider.currentQuestionIndex > 0) {
      surveyProvider.previousQuestion();
      _resetInputs();
      _loadCurrentAnswer();
    }
  }

  void _resetInputs() {
    _textController.clear();
    _selectedOption = null;
    _selectedCheckboxes.clear();
  }

  void _showExitDialog(BuildContext context, SurveyProvider surveyProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Exit Survey?'),
          content: const Text(
            'Your progress will be saved. You can continue later from where you left off.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveAnswer(surveyProvider);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }
} 