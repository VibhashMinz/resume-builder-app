import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/blocs/auth_bloc.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/blocs/auth_event.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/blocs/auth_state.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushNamed(context, '/home');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(
                      SignupEvent(emailController.text, passwordController.text),
                    );
                  },
                  child: state is AuthLoading ? const CircularProgressIndicator() : const Text('Sign Up'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to Login Page
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
