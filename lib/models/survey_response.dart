class SurveyResponse {
  final String id;
  final String questionId;
  final dynamic answer;
  final DateTime timestamp;
  final String? languageCode;
  final Map<String, dynamic>? metadata;

  SurveyResponse({
    required this.id,
    required this.questionId,
    required this.answer,
    required this.timestamp,
    this.languageCode,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'answer': answer,
      'timestamp': timestamp.toIso8601String(),
      'languageCode': languageCode,
      'metadata': metadata,
    };
  }

  factory SurveyResponse.fromJson(Map<String, dynamic> json) {
    return SurveyResponse(
      id: json['id'],
      questionId: json['questionId'],
      answer: json['answer'],
      timestamp: DateTime.parse(json['timestamp']),
      languageCode: json['languageCode'],
      metadata: json['metadata'] != null 
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  SurveyResponse copyWith({
    String? id,
    String? questionId,
    dynamic answer,
    DateTime? timestamp,
    String? languageCode,
    Map<String, dynamic>? metadata,
  }) {
    return SurveyResponse(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
      timestamp: timestamp ?? this.timestamp,
      languageCode: languageCode ?? this.languageCode,
      metadata: metadata ?? this.metadata,
    );
  }
} 