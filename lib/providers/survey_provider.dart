import 'package:flutter/material.dart';
import '../models/survey_question.dart';
import '../models/survey_response.dart';
import '../services/gemini_service.dart';

class SurveyProvider extends ChangeNotifier {
  List<SurveyQuestion> _questions = [];
  List<SurveyResponse> _responses = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _error;

  List<SurveyQuestion> get questions => _questions;
  List<SurveyResponse> get responses => _responses;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  SurveyQuestion? get currentQuestion => 
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length 
          ? _questions[_currentQuestionIndex] 
          : null;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadAIGeneratedSurvey(String languageCode, {int count = 5, String? topic}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _questions = await GeminiService.generateSurveyQuestions(
        languageCode: languageCode,
        count: count,
        topic: topic,
      );
      _currentQuestionIndex = 0;
      _responses.clear();
    } catch (e) {
      _error = 'Failed to load survey questions. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  void addResponse(SurveyResponse response) {
    // Remove existing response for this question if any
    _responses.removeWhere((r) => r.questionId == response.questionId);
    _responses.add(response);
    notifyListeners();
  }

  SurveyResponse? getResponseForQuestion(String questionId) {
    try {
      return _responses.firstWhere((r) => r.questionId == questionId);
    } catch (e) {
      return null;
    }
  }

  bool isQuestionAnswered(String questionId) {
    return _responses.any((r) => r.questionId == questionId);
  }

  void resetSurvey() {
    _currentQuestionIndex = 0;
    _responses.clear();
    notifyListeners();
  }

  bool get isSurveyComplete {
    return _questions.every((question) => 
        !question.isRequired || isQuestionAnswered(question.id));
  }
} 