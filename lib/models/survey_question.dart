enum QuestionType {
  text,
  number,
  multipleChoice,
  checkbox,
  date,
  time,
  location,
  image,
  audio,
  video,
}

class SurveyQuestion {
  final String id;
  final String text;
  final QuestionType type;
  final bool isRequired;
  final List<String>? options;
  final Map<String, String> translations;
  final Map<String, Map<String, String>>? optionTranslations;
  final String? helpText;
  final Map<String, String>? helpTextTranslations;
  final String? validationRule;
  final String? placeholder;
  final Map<String, String>? placeholderTranslations;

  SurveyQuestion({
    required this.id,
    required this.text,
    required this.type,
    this.isRequired = false,
    this.options,
    required this.translations,
    this.optionTranslations,
    this.helpText,
    this.helpTextTranslations,
    this.validationRule,
    this.placeholder,
    this.placeholderTranslations,
  });

  String getTranslatedText(String languageCode) {
    return translations[languageCode] ?? text;
  }

  String? getTranslatedHelpText(String languageCode) {
    return helpTextTranslations?[languageCode] ?? helpText;
  }

  String? getTranslatedPlaceholder(String languageCode) {
    return placeholderTranslations?[languageCode] ?? placeholder;
  }

  String getTranslatedOption(String option, String languageCode) {
    if (optionTranslations != null && 
        optionTranslations!.containsKey(option) &&
        optionTranslations![option]!.containsKey(languageCode)) {
      return optionTranslations![option]![languageCode]!;
    }
    return option;
  }

  List<String> getTranslatedOptions(String languageCode) {
    if (options == null) return [];
    
    return options!.map((option) => getTranslatedOption(option, languageCode)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString(),
      'isRequired': isRequired,
      'options': options,
      'translations': translations,
      'optionTranslations': optionTranslations,
      'helpText': helpText,
      'helpTextTranslations': helpTextTranslations,
      'validationRule': validationRule,
      'placeholder': placeholder,
      'placeholderTranslations': placeholderTranslations,
    };
  }

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SurveyQuestion(
      id: json['id'],
      text: json['text'],
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => QuestionType.text,
      ),
      isRequired: json['isRequired'] ?? false,
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      translations: Map<String, String>.from(json['translations'] ?? {}),
      optionTranslations: json['optionTranslations'] != null 
          ? Map<String, Map<String, String>>.from(json['optionTranslations'])
          : null,
      helpText: json['helpText'],
      helpTextTranslations: json['helpTextTranslations'] != null 
          ? Map<String, String>.from(json['helpTextTranslations'])
          : null,
      validationRule: json['validationRule'],
      placeholder: json['placeholder'],
      placeholderTranslations: json['placeholderTranslations'] != null 
          ? Map<String, String>.from(json['placeholderTranslations'])
          : null,
    );
  }
} 