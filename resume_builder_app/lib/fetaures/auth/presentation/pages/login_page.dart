import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/blocs/auth_bloc.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/blocs/auth_event.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/blocs/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamed(context, '/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Email')),
              TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(LoginEvent('test@example.com', 'password123'));
                },
                child: state is AuthLoading ? CircularProgressIndicator() : Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: state is AuthLoading ? CircularProgressIndicator() : Text('Sign Up'),
              ),
            ],
          );
        },
      ),
    );
  }
}
