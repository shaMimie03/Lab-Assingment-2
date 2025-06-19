import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wtms/config.dart';
import 'loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _image;
  Uint8List? webImage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register Worker",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 74, 38),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 174, 182, 174),
            ),
            margin: const EdgeInsets.all(16.0),
            child: Card(
              color: const Color.fromARGB(255, 226, 254, 255),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showImageSelectionDialog,
                      child: Container(
                        height: 130,
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                _image == null
                                    ? const AssetImage(
                                      "assets/images/register.png",
                                    )
                                    : _getImageProvider(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(_usernameController, "Username"),
                    _buildTextField(_nameController, "Full Name"),
                    _buildTextField(
                      _emailController,
                      "Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      _passwordController,
                      "Password",
                      isPassword: true,
                    ),
                    _buildTextField(
                      _confirmPasswordController,
                      "Confirm Password",
                      isPassword: true,
                    ),
                    _buildTextField(
                      _phoneController,
                      "Phone",
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextField(_addressController, "Address", maxLines: 2),
                    const SizedBox(height: 3),
                    SizedBox(
                      width: double.infinity,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    61,
                                    117,
                                    61,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _confirmDialog,
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _confirmDialog() {
    if (_usernameController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      _showSnackBar("Please fill all fields.");
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar("Password must be at least 6 characters.");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar("Passwords do not match.");
      return;
    }

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Register this account?"),
            content: const Text("Are you sure you want to proceed?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _registerWorker();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
    );
  }

  void _registerWorker() async {
    setState(() => _isLoading = true);

    final response = await http.post(
      Uri.parse("${MyConfig.myurl}/register_worker.php"),
      body: {
        "username": _usernameController.text,
        "full_name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "phone": _phoneController.text,
        "address": _addressController.text,
      },
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        _showSnackBar("Registration successful!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        _showSnackBar(jsonData['message']);
      }
    } else {
      _showSnackBar("Server error. Please try again later.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showImageSelectionDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Select Image"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                  child: const Text("From Camera"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text("From Gallery"),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      if (kIsWeb) webImage = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  ImageProvider _getImageProvider() {
    if (_image != null) {
      if (kIsWeb && webImage != null) {
        return MemoryImage(webImage!);
      } else {
        return FileImage(_image!);
      }
    }
    return const AssetImage("assets/images/profile.png");
  }
}
