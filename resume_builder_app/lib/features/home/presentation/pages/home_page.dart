import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resume_builder_app/core/routes/routes.dart';
import 'package:resume_builder_app/core/theme/widgets/theme_toggle_button.dart';
import 'package:resume_builder_app/features/auth/domain/entities/user.dart' as app_user;
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_bloc.dart';
import 'package:resume_builder_app/core/di/service_locator.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resumes.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/create_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/update_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/delete_resume.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ResumeBloc(
              getResumes: sl<GetResumes>(),
              getResume: sl<GetResume>(),
              createResume: sl<CreateResume>(),
              updateResume: sl<UpdateResume>(),
              deleteResume: sl<DeleteResume>(),
            )..add(GetResumesEvent(userId)),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Resume Builder',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
              ),
            ),
            actions: [
              const ThemeToggleButton(),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(const SignOutEvent());
                },
              ),
            ],
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                final authUser = state.user;
                return BlocBuilder<ResumeBloc, ResumeState>(
                  builder: (context, resumeState) {
                    if (resumeState is ResumeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (resumeState is ResumeError) {
                      return Center(child: Text('Error: ${resumeState.message}'));
                    }

                    if (resumeState is ResumesLoaded) {
                      final resumes = resumeState.resumes;
                      final totalResumes = resumes.length;
                      final publicResumes = resumes.where((resume) => resume.isPublic).length;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Card
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                          backgroundImage: authUser.photoURL != null ? NetworkImage(authUser.photoURL!) : null,
                                          child: authUser.photoURL == null
                                              ? Text(
                                                  authUser.displayName?.isNotEmpty == true ? authUser.displayName![0].toUpperCase() : authUser.email[0].toUpperCase(),
                                                  style: theme.textTheme.headlineMedium?.copyWith(
                                                    color: theme.colorScheme.primary,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                authUser.displayName ?? 'User',
                                                style: theme.textTheme.titleLarge,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                authUser.email,
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                                ),
                                              ),
                                              if (authUser.isEmailVerified)
                                                Chip(
                                                  label: Text(
                                                    'Verified',
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      color: theme.colorScheme.onPrimary,
                                                    ),
                                                  ),
                                                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Account Settings',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    ListTile(
                                      leading: Icon(Icons.edit, color: theme.colorScheme.primary),
                                      title: const Text('Edit Profile'),
                                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                                      onTap: () {
                                        _showEditProfileDialog(context, authUser);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.lock, color: theme.colorScheme.primary),
                                      title: const Text('Change Password'),
                                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                                      onTap: () {
                                        _showChangePasswordDialog(context);
                                      },
                                    ),
                                    if (authUser.provider == 'email' && !authUser.isEmailVerified)
                                      ListTile(
                                        leading: Icon(Icons.verified_user, color: theme.colorScheme.primary),
                                        title: const Text('Verify Email'),
                                        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                                        onTap: () {
                                          context.read<AuthBloc>().add(const SendEmailVerificationEvent());
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Verification email sent. Please check your inbox.'),
                                              backgroundColor: theme.colorScheme.primary,
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Resume Stats
                            Text(
                              'Your Resumes',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    _buildStatTile(
                                      context,
                                      icon: Icons.description,
                                      title: 'Total Resumes',
                                      value: totalResumes.toString(),
                                    ),
                                    const Divider(),
                                    _buildStatTile(
                                      context,
                                      icon: Icons.visibility,
                                      title: 'Public Resumes',
                                      value: publicResumes.toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createResume);
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Resume'),
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        if (title == 'Total Resumes') {
          Navigator.pushNamed(context, AppRoutes.resumeList);
        }
      },
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        trailing: Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, app_user.User authUser) {
    final theme = Theme.of(context);
    final displayNameController = TextEditingController(text: authUser.displayName);
    final photoUrlController = TextEditingController(text: authUser.photoURL);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                hintText: 'Enter your display name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: photoUrlController,
              decoration: const InputDecoration(
                labelText: 'Photo URL',
                hintText: 'Enter your photo URL',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    UpdateUserProfileEvent(
                      displayName: displayNameController.text,
                      photoURL: photoUrlController.text.isNotEmpty ? photoUrlController.text : null,
                    ),
                  );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Profile updated successfully'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final theme = Theme.of(context);
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                hintText: 'Enter your current password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter your new password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm your new password',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Passwords do not match'),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
                return;
              }

              context.read<AuthBloc>().add(
                    UpdatePasswordEvent(newPasswordController.text),
                  );
              Navigator.pop(context);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}
