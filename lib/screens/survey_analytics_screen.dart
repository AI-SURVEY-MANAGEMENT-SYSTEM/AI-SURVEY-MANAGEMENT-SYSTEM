import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/survey_provider.dart';
import '../models/survey_question.dart';

class SurveyAnalyticsScreen extends StatelessWidget {
  const SurveyAnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Analytics'),
      ),
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
        child: Consumer<SurveyProvider>(
          builder: (context, surveyProvider, child) {
            final total = surveyProvider.questions.length;
            final answered = surveyProvider.responses.length;
            final unanswered = total - answered;
            final completion = total > 0 ? answered / total : 0.0;

            final Map<QuestionType, int> byType = {
              QuestionType.text: 0,
              QuestionType.number: 0,
              QuestionType.multipleChoice: 0,
              QuestionType.checkbox: 0,
              QuestionType.date: 0,
              QuestionType.time: 0,
            };
            for (final q in surveyProvider.questions) {
              byType[q.type] = (byType[q.type] ?? 0) + 1;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _overviewCard(context, answered, unanswered, completion),
                  const SizedBox(height: 16),
                  _byTypeCard(context, byType, total),
                  const SizedBox(height: 16),
                  _answersPreviewCard(context, surveyProvider),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                      icon: const Icon(Icons.home),
                      label: const Text('Back to Home'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _overviewCard(BuildContext context, int answered, int unanswered, double completion) {
    final total = answered + unanswered;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                  child: Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Overview', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _metric(context, 'Total', total.toString(), Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _metric(context, 'Answered', answered.toString(), Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _metric(context, 'Unanswered', unanswered.toString(), Colors.orange)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: completion,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 6),
            Text('${(completion * 100).round()}% complete', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _metric(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _byTypeCard(BuildContext context, Map<QuestionType, int> byType, int total) {
    int count(QuestionType t) => byType[t] ?? 0;
    double pct(QuestionType t) => total > 0 ? (count(t) / total) : 0.0;

    Widget row(String label, QuestionType t, Color color) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(width: 100, child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: pct(t),
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('${count(t)}'),
          ],
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.category, color: Colors.purple, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Questions by type', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            row('Text', QuestionType.text, Colors.blue),
            row('Number', QuestionType.number, Colors.teal),
            row('Multiple', QuestionType.multipleChoice, Colors.orange),
            row('Checkbox', QuestionType.checkbox, Colors.indigo),
            row('Date', QuestionType.date, Colors.brown),
            row('Time', QuestionType.time, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _answersPreviewCard(BuildContext context, SurveyProvider surveyProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.preview, color: Colors.green, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Answers preview', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: surveyProvider.responses.length,
              itemBuilder: (context, index) {
                final r = surveyProvider.responses[index];
                final q = surveyProvider.questions.firstWhere(
                  (q) => q.id == r.questionId,
                  orElse: () => SurveyQuestion(
                    id: r.questionId,
                    text: 'Unknown question',
                    type: QuestionType.text,
                    isRequired: false,
                    translations: const {},
                  ),
                );
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(q.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(r.answer.toString(), maxLines: 2, overflow: TextOverflow.ellipsis),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}