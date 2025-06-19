import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/config.dart';
import 'package:wtms/model/work.dart';

class SubmissionScreen extends StatefulWidget {
  final Work work;
  final int workerId;

  const SubmissionScreen({required this.work, required this.workerId});

  @override
  _SubmissionScreenState createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  final _controller = TextEditingController();
  bool _submitting = false;

  final Color _primaryColor = const Color.fromARGB(255, 38, 74, 38);
  final Color _backgroundColor = Colors.grey[50]!;

  Future<void> submitWork() async {
    final submissionText = _controller.text.trim();
    if (submissionText.isEmpty) {
      _showSnackBar('Please enter your submission details', Colors.red);
      return;
    }

    final confirmed = await _confirmSubmission();
    if (confirmed != true) return;

    setState(() => _submitting = true);

    try {
      final response = await http.post(
        Uri.parse("${MyConfig.myurl}/submit_work.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'work_id': widget.work.id.toString(),
          'worker_id': widget.workerId.toString(),
          'submission_text': submissionText,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        _showSnackBar(data['message'], _primaryColor);
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pop(context, true);
      } else {
        _showSnackBar(data['message'] ?? 'Submission failed', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Failed to submit: ${e.toString()}', Colors.red);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<bool?> _confirmSubmission() async {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Submission'),
            content: Text('Are you sure you want to submit this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('Submit Completion', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskCard(),
            SizedBox(height: 24),
            Text(
              'Your Submission',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 8,
              minLines: 5,
              decoration: InputDecoration(
                labelText: 'What did you complete?',
                hintText: 'Provide details about the work you performed...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _submitting ? null : submitWork,
                child:
                    _submitting
                        ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                        : Text(
                          'SUBMIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 12),
            Text(
              widget.work.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            if (widget.work.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  widget.work.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  'Due: ${widget.work.dueDate}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
