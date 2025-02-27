import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/core/usecase/login_usecase.dart';
import 'package:resume_builder_app/core/usecase/signup_usecase.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/blocs/auth_event.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/blocs/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Signup signupUseCase;

  AuthBloc({required this.loginUseCase, required this.signupUseCase}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase(LoginParams(event.email, event.password));
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signupUseCase(SignupParams(event.email, event.password));
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
