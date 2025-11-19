import 'package:flutter/material.dart';
import 'package:materim06/M07/auth.dart';
import 'package:materim06/M07/home.dart';
import 'package:materim06/M07/signup_screen.dart';
import 'package:materim06/M07/login_phone_screen.dart';
import 'package:materim06/M07/login_google_screen.dart'; // ✅ tambahkan ini

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  String message = '';
  late Auth auth;

  @override
  void initState() {
    auth = Auth();
    super.initState();
  }

  Future<void> submit() async {
    setState(() => message = '');
    try {
      final userID = await auth.logIn(txtEmail.text, txtPassword.text);
      if (userID != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userID)),
        );
      }
    } catch (e) {
      setState(() => message = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.lock_outline, size: 80, color: Colors.blue.shade700),
                const SizedBox(height: 16),
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration('Email', Icons.mail_outline),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: txtPassword,
                  obscureText: true,
                  decoration: inputDecoration('Password', Icons.lock_outline),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 16),

                // Tombol login dengan nomor HP
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.phone_android_outlined),
                    label: const Text(
                      'Login with Phone Number',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPhoneScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // ✅ Tombol login dengan Google → buka halaman baru
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.account_circle_outlined),
                    label: const Text(
                      'Login with Google',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      setState(() => message = '');
                      try {
                        setState(() => message = 'Signing in with Google...');
                        final user = await LoginGoogleHelper.signInWithGoogle();
                        if (user != null && mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(user.uid),
                            ),
                          );
                        } else {
                          setState(() => message = 'Login dibatalkan.');
                        }
                      } catch (e) {
                        setState(() => message = e.toString());
                      }
                    },
                  ),
                ),

                if (message.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
    );
  }
}
