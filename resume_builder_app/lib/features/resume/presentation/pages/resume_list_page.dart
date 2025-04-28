import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resume_builder_app/core/routes/routes.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_bloc.dart';
import 'package:resume_builder_app/features/resume/presentation/pages/resume_preview_page.dart';
import 'package:resume_builder_app/core/di/service_locator.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resumes.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/create_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/update_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/delete_resume.dart';

class ResumeListPage extends StatelessWidget {
  const ResumeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return BlocProvider(
      create: (context) => ResumeBloc(
        getResumes: sl<GetResumes>(),
        getResume: sl<GetResume>(),
        createResume: sl<CreateResume>(),
        updateResume: sl<UpdateResume>(),
        deleteResume: sl<DeleteResume>(),
      )..add(GetResumesEvent(userId ?? '')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Resumes'),
        ),
        body: BlocBuilder<ResumeBloc, ResumeState>(
          builder: (context, state) {
            if (state is ResumeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ResumeError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is ResumesLoaded) {
              final resumes = state.resumes;

              if (resumes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No resumes yet',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first resume to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.createResume);
                        },
                        child: const Text('Create Resume'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: resumes.length,
                itemBuilder: (context, index) {
                  final resume = resumes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(resume.title),
                      subtitle: Text(
                        'Last updated: ${_formatDate(resume.updatedAt)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.preview),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResumePreviewPage(resume: resume),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/edit_resume',
                                arguments: resume,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Resume'),
                                  content: Text('Are you sure you want to delete "${resume.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<ResumeBloc>().add(DeleteResumeEvent(resume.id));
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(child: Text('Please sign in to view your resumes'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.createResume);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
