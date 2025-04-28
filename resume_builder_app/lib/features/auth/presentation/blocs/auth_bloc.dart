import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Signup signupUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final SignOut signOutUseCase;
  final UpdateUserProfile updateUserProfileUseCase;
  final UpdatePassword updatePasswordUseCase;
  final SendEmailVerification sendEmailVerificationUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.googleSignInUseCase,
    required this.signOutUseCase,
    required this.updateUserProfileUseCase,
    required this.updatePasswordUseCase,
    required this.sendEmailVerificationUseCase,
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

    on<UpdateUserProfileEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await updateUserProfileUseCase(
          displayName: event.displayName,
          photoURL: event.photoURL,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<UpdatePasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await updatePasswordUseCase(event.newPassword);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SendEmailVerificationEvent>((event, emit) async {
      try {
        await sendEmailVerificationUseCase();
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
