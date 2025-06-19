import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/config.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final int workerId;

  const SubmissionHistoryScreen({required this.workerId, super.key});

  @override
  State<SubmissionHistoryScreen> createState() =>
      _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  List<dynamic> submissions = [];
  bool isLoading = true;
  Map<int, bool> expandedStates = {};
  Map<int, TextEditingController> editControllers = {};

  final Color _primaryColor = const Color.fromARGB(255, 38, 74, 38);

  @override
  void initState() {
    super.initState();
    fetchSubmissions();
  }

  @override
  void dispose() {
    editControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> fetchSubmissions() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("${MyConfig.myurl}/get_submission.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"worker_id": widget.workerId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            submissions = data['submissions'];
            for (var sub in submissions) {
              final id = sub['id'];
              editControllers[id] = TextEditingController(
                text: sub['submission_text'],
              );
              expandedStates[id] = false;
            }
          });
        } else {
          showSnackBar(data['message'] ?? 'Failed to load submissions');
        }
      } else {
        showSnackBar("Server error: ${response.statusCode}");
      }
    } catch (e) {
      showSnackBar("Error: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateSubmission(int submissionId) async {
    final controller = editControllers[submissionId];
    if (controller == null || controller.text.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm Update"),
            content: const Text(
              "Are you sure you want to update this submission?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final response = await http.post(
                    Uri.parse("${MyConfig.myurl}/edit_submission.php"),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({
                      "submission_id": submissionId,
                      "submission_text": controller.text,
                    }),
                  );

                  if (response.statusCode == 200) {
                    final data = jsonDecode(response.body);
                    if (data['status'] == 'success') {
                      showSnackBar("Submission updated successfully");
                      fetchSubmissions();
                    } else {
                      showSnackBar(data['message'] ?? 'Update failed');
                    }
                  } else {
                    showSnackBar("Server error: ${response.statusCode}");
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 170, 185, 187),
      appBar: AppBar(
        backgroundColor: _primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Submission History",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchSubmissions,
          ),
        ],
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
              )
              : submissions.isEmpty
              ? const Center(child: Text("No submissions found."))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: submissions.length,
                itemBuilder: (context, index) {
                  final sub = submissions[index];
                  final id = sub['id'];
                  final isExpanded = expandedStates[id] ?? false;

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      key: Key(id.toString()),
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() => expandedStates[id] = expanded);
                      },
                      title: Text(
                        sub['task_title'] ?? 'No title',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Submitted at: ${sub['submitted_at'] ?? 'N/A'}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.8,
                            ),
                          ),
                          if (!isExpanded)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                sub['submission_text']?.length > 60
                                    ? '${sub['submission_text'].substring(0, 60)}...'
                                    : sub['submission_text'] ??
                                        'No description',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                  height: 1.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextField(
                                controller: editControllers[id],
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: "Edit Submission",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.save),
                                    onPressed: () => updateSubmission(id),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.save_alt,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Save Changes",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onPressed: () => updateSubmission(id),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
