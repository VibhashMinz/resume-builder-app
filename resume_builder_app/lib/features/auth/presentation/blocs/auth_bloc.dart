import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Signup signupUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final SignOut signOutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.googleSignInUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial()) {
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

    on<GoogleSignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await googleSignInUseCase();
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await signOutUseCase();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
