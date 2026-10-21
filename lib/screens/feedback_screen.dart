import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../state/app_language.dart';
import '../widgets/app_snack.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

/// Optional HTTP POST: sends feedback to the API as JSON.
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final ApiService _api = ApiService();
  bool _sending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      final reference = await _api.submitFeedback(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
      );
      if (!mounted) return;
      showAppSnack(context, 'Feedback submitted. Reference #$reference');
      _titleController.clear();
      _messageController.clear();
    } on ApiException catch (e) {
      if (mounted) showAppSnack(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'feedback'))),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Subject',
                icon: Icons.title_rounded,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Please enter a subject';
                  if (value.length < 3) return 'Subject must be at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _messageController,
                label: 'Your feedback',
                icon: Icons.chat_bubble_outline_rounded,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Please enter your feedback';
                  if (value.length < 10) return 'Feedback must be at least 10 characters';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: _sending ? 'Sending...' : 'Submit feedback',
                onPressed: _sending ? () {} : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
