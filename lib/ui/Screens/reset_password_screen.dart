import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holy_quran/colors.dart';
import 'package:holy_quran/data/models/reset_password_model.dart';
import 'package:holy_quran/data/services/network_caller.dart';
import 'package:holy_quran/data/utils/urls.dart';
import 'package:holy_quran/ui/Screens/SignInScreen.dart';
import 'package:holy_quran/ui/Widgets/centered_circular_progress_indicator.dart';
import 'package:holy_quran/ui/Widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  static const String name = '/forgot-password/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _resetPasswordInProgress = false;
  ResetPassword? resetPassword;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Text(
                  'Set Password',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Minimum length of password should be more than 8 letters.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _newPasswordTEController,
                  decoration: const InputDecoration(hintText: 'New Password'),
                  validator: (String? value) {
                    if (value!.isEmpty && int.parse(value) < 6) {
                      return 'Enter a new password more than 6 letter';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _confirmPasswordTEController,
                  decoration:
                      const InputDecoration(hintText: 'Confirm new Password'),
                  validator: (String? value) {
                    if (value!.isEmpty && int.parse(value) < 6) {
                      return 'Enter password again';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Visibility(
                  visible: _resetPasswordInProgress == false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: () {
                      _onTapResetPasswordButton();
                    },
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                Center(
                  child: _buildSignInSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: "Have an account?  ",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: 'Sign in',
            style: TextStyle(
              color: violet,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (value) => false);
              },
          ),
        ],
      ),
    );
  }

  void _onTapResetPasswordButton() {
    if (_newPasswordTEController.text == _confirmPasswordTEController.text) {
      _postResetPassword();
    } else {
      showSnackBarMessage(context, "Password didn't match");
    }
  }

  Future<void> _postResetPassword() async {
    _resetPasswordInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _confirmPasswordTEController.text,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.resetPasswordUrl, body: requestBody);
    _resetPasswordInProgress = false;
    if (response.isSuccess) {
      // Navigator.pushReplacementNamed(context, SignInScreen.name);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
      showSnackBarMessage(context, 'Password Changed Successfully');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
  }
}
