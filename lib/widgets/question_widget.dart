import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/survey_question.dart';

class QuestionWidget extends StatelessWidget {
  final SurveyQuestion question;
  final String languageCode;
  final TextEditingController textController;
  final String? selectedOption;
  final List<String> selectedCheckboxes;
  final Function(String) onOptionSelected;
  final Function(String, bool) onCheckboxChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.languageCode,
    required this.textController,
    required this.selectedOption,
    required this.selectedCheckboxes,
    required this.onOptionSelected,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.text:
        return _buildTextInput(context);
      case QuestionType.number:
        return _buildNumberInput(context);
      case QuestionType.multipleChoice:
        return _buildMultipleChoice(context);
      case QuestionType.checkbox:
        return _buildCheckbox(context);
      case QuestionType.date:
        return _buildDateInput(context);
      case QuestionType.time:
        return _buildTimeInput(context);
      default:
        return _buildTextInput(context);
    }
  }

  Widget _buildTextInput(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Answer',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: question.getTranslatedPlaceholder(languageCode) ?? 
                         'Enter your answer here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Answer',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: question.getTranslatedPlaceholder(languageCode) ?? 
                         'Enter a number...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon: const Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleChoice(BuildContext context) {
    final options = question.getTranslatedOptions(languageCode);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select One Option',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: selectedOption,
              onChanged: (value) {
                if (value != null) {
                  onOptionSelected(value);
                }
              },
              activeColor: Theme.of(context).colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    final options = question.getTranslatedOptions(languageCode);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select All That Apply',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((option) => CheckboxListTile(
              title: Text(option),
              value: selectedCheckboxes.contains(option),
              onChanged: (isSelected) {
                onCheckboxChanged(option, isSelected ?? false);
              },
              activeColor: Theme.of(context).colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInput(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  textController.text = '${date.day}/${date.month}/${date.year}';
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      textController.text.isEmpty 
                          ? 'Tap to select date'
                          : textController.text,
                      style: TextStyle(
                        color: textController.text.isEmpty 
                            ? Colors.grey[500]
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInput(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  textController.text = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      textController.text.isEmpty 
                          ? 'Tap to select time'
                          : textController.text,
                      style: TextStyle(
                        color: textController.text.isEmpty 
                            ? Colors.grey[500]
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 