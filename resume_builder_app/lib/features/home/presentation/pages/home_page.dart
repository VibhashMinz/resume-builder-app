import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/core/routes/routes.dart';
import 'package:resume_builder_app/core/theme/widgets/theme_toggle_button.dart';
//import 'package:resume_builder_app/features/auth/domain/entities/user.dart' as auth;
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
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
              final user = state.user;
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
                                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                                  backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                                  child: user.photoURL == null
                                      ? Text(
                                          user.displayName?.isNotEmpty == true ? user.displayName![0].toUpperCase() : user.email[0].toUpperCase(),
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
                                        user.displayName ?? 'User',
                                        style: theme.textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user.email,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                        ),
                                      ),
                                      if (user.isEmailVerified)
                                        Chip(
                                          label: Text(
                                            'Verified',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                          backgroundColor: theme.colorScheme.primary,
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
                              trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                              onTap: () {
                                // TODO: Navigate to edit profile page
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.lock, color: theme.colorScheme.primary),
                              title: const Text('Change Password'),
                              trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                              onTap: () {
                                // TODO: Navigate to change password page
                              },
                            ),
                            if (user.provider == 'email' && !user.isEmailVerified)
                              ListTile(
                                leading: Icon(Icons.verified_user, color: theme.colorScheme.primary),
                                title: const Text('Verify Email'),
                                trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                                onTap: () {
                                  // TODO: Send email verification
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
                              value: '0',
                            ),
                            const Divider(),
                            _buildStatTile(
                              context,
                              icon: Icons.visibility,
                              title: 'Public Resumes',
                              value: '0',
                            ),
                            const Divider(),
                            _buildStatTile(
                              context,
                              icon: Icons.share,
                              title: 'Shared Resumes',
                              value: '0',
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Navigate to create resume page
          },
          icon: const Icon(Icons.add),
          label: const Text('Create Resume'),
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
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      trailing: Text(
        value,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
