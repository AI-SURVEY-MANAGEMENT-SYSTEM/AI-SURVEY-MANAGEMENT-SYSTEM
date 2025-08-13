# AI Survey Assistant

A multilingual Flutter application designed to help users complete official government surveys in India. The app provides intelligent assistance in multiple Indian languages, making data collection inclusive and accessible for every citizen.

## Features

### 🌐 Multilingual Support
- **12 Indian Languages**: English, Hindi, Bengali, Tamil, Telugu, Marathi, Kannada, Malayalam, Gujarati, Punjabi, Odia, and Assamese
- **Dynamic Language Switching**: Users can change language preferences anytime during the survey
- **Localized Content**: All questions, help text, and UI elements are translated

### 🤖 AI Assistant
- **Smart Question Explanation**: Provides clear, simple explanations for each survey question using Google Gemini AI
- **Contextual Help**: Offers tips and guidance based on question type
- **User-Friendly Interface**: Designed for users with low digital literacy
- **Cultural Awareness**: Respectful and culturally appropriate language
- **Real-time AI Support**: Dynamic explanations in user's preferred language

### 📱 User Experience
- **Intuitive Navigation**: Simple, step-by-step survey completion
- **Progress Tracking**: Visual progress indicators and completion status
- **Response Review**: Ability to review and edit answers before submission
- **Offline Capability**: Works without internet connection for basic functionality

### 🔒 Privacy & Security
- **Local Data Storage**: Responses stored securely on device
- **No Personal Data Collection**: Focus on survey responses only
- **Secure Submission**: Encrypted data transmission when submitting

## Supported Question Types

- **Text Input**: Free-form text responses
- **Number Input**: Numerical data with validation
- **Multiple Choice**: Single selection from options
- **Checkbox**: Multiple selections allowed
- **Date Picker**: Calendar-based date selection
- **Time Picker**: Time selection interface

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android SDK (API level 21 or higher)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/ai-survey-assistant.git
   cd ai-survey-assistant
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── survey_question.dart
│   └── survey_response.dart
├── providers/               # State management
│   ├── language_provider.dart
│   └── survey_provider.dart
├── screens/                 # UI screens
│   ├── home_screen.dart
│   ├── language_selection_screen.dart
│   ├── survey_screen.dart
│   └── survey_completion_screen.dart
├── services/                # API services
│   └── gemini_service.dart
├── config/                  # Configuration
│   └── api_config.dart
├── utils/                   # Utility functions
│   └── language_utils.dart
└── widgets/                 # Reusable widgets
    ├── question_widget.dart
    └── ai_assistant_widget.dart
```

## Dependencies

### Core Dependencies
- `flutter`: UI framework
- `provider`: State management
- `shared_preferences`: Local data storage
- `sqflite`: Database operations
- `http`: Network requests
- `flutter_localizations`: Internationalization

### UI & UX
- `flutter_svg`: SVG image support
- `cached_network_image`: Image caching
- `flutter_tts`: Text-to-speech functionality
- `speech_to_text`: Voice input support

### Utilities
- `uuid`: Unique identifier generation
- `path`: File path operations
- `permission_handler`: Permission management
- `connectivity_plus`: Network connectivity
- `flutter_secure_storage`: Secure data storage

## Configuration

### API Configuration
The app uses Google Gemini AI for intelligent assistance. The API key is configured in `lib/config/api_config.dart`.

**Important**: For production deployment, consider:
- Moving the API key to environment variables
- Implementing rate limiting
- Adding API key rotation mechanisms

### Language Support
The app supports 12 Indian languages. To add a new language:

1. Add the language code to `LanguageUtils.supportedLocales`
2. Add language names to `LanguageUtils.languageNames`
3. Provide translations for survey questions

### Survey Questions
To add new survey questions, modify the `loadSampleSurvey()` method in `SurveyProvider`:

```dart
SurveyQuestion(
  id: 'unique_id',
  text: 'Question text in English',
  type: QuestionType.text,
  isRequired: true,
  translations: {
    'hi': 'हिंदी में प्रश्न',
    'bn': 'বাংলায় প্রশ্ন',
    // Add more translations
  },
)
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## National Initiative

This application is part of a national initiative to make data collection:
- **Inclusive**: Accessible to all citizens regardless of language or digital literacy
- **Intelligent**: AI-powered assistance for better understanding
- **Accessible**: User-friendly interface for rural and semi-urban areas

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:
- Create an issue in the GitHub repository
- Contact the development team
- Check the documentation for common questions

## Acknowledgments

- Government of India for the initiative
- Flutter team for the excellent framework
- Contributors and translators
- Users who provide feedback and suggestions

---

**Made with ❤️ for India's Digital Transformation** 