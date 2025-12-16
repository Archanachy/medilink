import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
   const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: LayoutBuilder(
        builder: (context, c) {
          bool isTablet = c.maxWidth > 600;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 80 : 20,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create Your Account",
                    style: TextStyle(
                      fontSize: isTablet ? 30 : 24,
                      fontWeight: FontWeight.bold,
                    )),

                SizedBox(height: isTablet ? 30 : 20),

                TextField(
                  decoration : InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: isTablet ? 30 : 20),

                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: isTablet ? 30 : 20),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: isTablet ? 40 : 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 14),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: isTablet ? 22 : 16),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Already have an account? Login"),
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
