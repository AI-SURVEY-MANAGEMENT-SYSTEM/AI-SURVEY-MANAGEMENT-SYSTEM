# AI Survey Assistant - Setup Guide

## Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Verify Gemini API Key
The app is configured with your Gemini API key: `AIzaSyDUmxOhRkjal-y5jP-4o3wCZ41r323VKMo`

The key is stored in `lib/config/api_config.dart` and used by `lib/services/gemini_service.dart`.

### 3. Run the App
```bash
flutter run
```

## Features with Gemini AI

### 🤖 AI-Powered Assistance
- **Smart Explanations**: Each survey question gets intelligent explanations in the user's preferred language
- **Contextual Help**: AI provides guidance based on question type (text, number, multiple choice, etc.)
- **Cultural Awareness**: Responses are culturally appropriate and respectful
- **Low Digital Literacy Support**: Simple, clear language for users with limited tech experience

### 🔄 Real-time AI Integration
- **Dynamic Explanations**: AI explanations load automatically for each question
- **Refresh Capability**: Users can refresh AI explanations if needed
- **Fallback Support**: Default explanations provided if AI service is unavailable
- **Multilingual AI**: AI responses in 12 Indian languages

## Testing the AI Integration

### 1. Run Tests
```bash
flutter test test/gemini_service_test.dart
```

### 2. Test AI Features
1. Start the app
2. Select a language (e.g., Hindi)
3. Start the survey
4. Notice the AI Assistant widget on each question
5. Tap to expand and see AI-generated explanations
6. Use the "Refresh AI Help" button to get new explanations

## API Usage

### Current Configuration
- **Model**: Gemini Pro
- **Temperature**: 0.7 (balanced creativity)
- **Max Tokens**: 1024 (sufficient for explanations)
- **Languages**: 12 Indian languages supported

### API Calls Made
1. **Question Explanations**: When user views a question
2. **Clarification Requests**: When user provides unclear answers
3. **Contextual Help**: Based on question type and user language

## Security Considerations

### For Development
- API key is stored in code for easy testing
- No sensitive data transmitted to AI service

### For Production
- Move API key to environment variables
- Implement rate limiting
- Add API key rotation
- Consider data privacy compliance

## Troubleshooting

### Common Issues

1. **API Key Error**
   - Verify the key in `lib/config/api_config.dart`
   - Check if the key has proper permissions

2. **Network Issues**
   - App gracefully falls back to default explanations
   - Check internet connectivity

3. **AI Service Unavailable**
   - App continues to work with default explanations
   - Users can still complete surveys

### Debug Mode
```bash
flutter run --debug
```

Check console for API response logs.

## Next Steps

1. **Customize Prompts**: Modify prompts in `GeminiService` for specific use cases
2. **Add More Languages**: Extend language support in `LanguageUtils`
3. **Enhance AI Features**: Add voice input, image analysis, etc.
4. **Production Deployment**: Implement proper security measures

---

**Note**: This app is part of a national initiative for inclusive data collection in India. The AI integration makes government surveys accessible to all citizens regardless of language or digital literacy. 