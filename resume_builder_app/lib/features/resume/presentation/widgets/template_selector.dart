import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';

class TemplateSelector extends StatelessWidget {
  final ResumeTemplate currentTemplate;
  final Function(ResumeTemplate) onTemplateSelected;

  const TemplateSelector({
    super.key,
    required this.currentTemplate,
    required this.onTemplateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Template',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: ResumeTemplate.values.length,
                itemBuilder: (context, index) {
                  final template = ResumeTemplate.values[index];
                  return _buildTemplateCard(context, template);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, ResumeTemplate template) {
    final isSelected = currentTemplate == template;
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: () {
          onTemplateSelected(template);
          Navigator.pop(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: _buildTemplatePreview(template),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    template.name[0].toUpperCase() + template.name.substring(1),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplatePreview(ResumeTemplate template) {
    switch (template) {
      case ResumeTemplate.modern:
        return _buildModernPreview();
      case ResumeTemplate.classic:
        return _buildClassicPreview();
      case ResumeTemplate.professional:
        return _buildProfessionalPreview();
      case ResumeTemplate.creative:
        return _buildCreativePreview();
      case ResumeTemplate.minimal:
        return _buildMinimalPreview();
      case ResumeTemplate.elegant:
        return _buildElegantPreview();
    }
  }

  Widget _buildModernPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 28,
            width: double.infinity,
            color: Colors.blue,
            child: const Center(
              child: Text(
                'JOHN DOE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.blue, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 120,
                      color: Colors.blue.withOpacity(0.7),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 8,
                      width: 100,
                      color: Colors.blue.withOpacity(0.5),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 8,
                      width: 80,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: double.infinity,
            color: Colors.blue.withOpacity(0.2),
            child: const Center(
              child: Text(
                'EXPERIENCE',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: 150,
            color: Colors.blue.withOpacity(0.3),
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: 120,
            color: Colors.blue.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildClassicPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                'JOHN DOE',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 10,
            width: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: 150,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[400]!,
                  width: 1,
                ),
              ),
            ),
            child: const Center(
              child: Text(
                'PROFESSIONAL EXPERIENCE',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: 100,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.indigo, size: 25),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: 100,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 8,
                      width: 80,
                      color: Colors.indigo.withOpacity(0.7),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 8,
                      width: 60,
                      color: Colors.indigo.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: double.infinity,
            color: Colors.indigo.withOpacity(0.2),
            child: const Center(
              child: Text(
                'CAREER SUMMARY',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: 150,
            color: Colors.indigo.withOpacity(0.3),
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: 120,
            color: Colors.indigo.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildCreativePreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 28,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'JOHN DOE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.purple.withOpacity(0.7),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 8,
                      width: 80,
                      color: Colors.purple.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'SKILLS & EXPERTISE',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              _buildSkillChip(Colors.purple),
              _buildSkillChip(Colors.purple),
              _buildSkillChip(Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(Color color) {
    return Container(
      height: 16,
      width: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildMinimalPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16,
            width: 100,
            color: Colors.teal,
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            width: 80,
            color: Colors.teal.withOpacity(0.7),
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: 120,
            color: Colors.teal.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.teal.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: const Center(
              child: Text(
                'EXPERIENCE',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: 150,
            color: Colors.teal.withOpacity(0.3),
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: 100,
            color: Colors.teal.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.brown.withOpacity(0.5),
                  width: 2,
                ),
              ),
            ),
            child: const Center(
              child: Text(
                'JOHN DOE',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 10,
            width: 100,
            color: Colors.brown.withOpacity(0.7),
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: 150,
            color: Colors.brown.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.brown.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: const Center(
              child: Text(
                'PROFESSIONAL EXPERIENCE',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: 120,
            color: Colors.brown.withOpacity(0.3),
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: 100,
            color: Colors.brown.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
