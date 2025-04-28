import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';

class CertificateForm extends StatefulWidget {
  final List<Certificate> certificates;

  const CertificateForm({super.key, required this.certificates});

  @override
  State<CertificateForm> createState() => _CertificateFormState();
}

class _CertificateFormState extends State<CertificateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issuerController = TextEditingController();
  final _urlController = TextEditingController();
  DateTime? _issueDate;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    if (widget.certificates.isNotEmpty) {
      final lastCertificate = widget.certificates.last;
      _nameController.text = lastCertificate.name;
      _issuerController.text = lastCertificate.issuer;
      _urlController.text = lastCertificate.url ?? '';
      _issueDate = lastCertificate.issueDate;
      _expiryDate = lastCertificate.expiryDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isIssueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isIssueDate ? (_issueDate ?? DateTime.now()) : (_expiryDate ?? DateTime.now()),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isIssueDate) {
          _issueDate = picked;
        } else {
          _expiryDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.certificates.isNotEmpty ? 'Edit Certificate' : 'Add Certificate'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && _issueDate != null) {
                final certificate = Certificate(
                  id: DateTime.now().toIso8601String(),
                  name: _nameController.text,
                  issuer: _issuerController.text,
                  issueDate: _issueDate!,
                  expiryDate: _expiryDate,
                  url: _urlController.text.isNotEmpty ? _urlController.text : null,
                );
                Navigator.pop(context, [...widget.certificates, certificate]);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Certificate Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter certificate name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _issuerController,
              decoration: const InputDecoration(
                labelText: 'Issuing Organization',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter issuing organization';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Issue Date'),
                    subtitle: Text(_issueDate == null ? 'Not set' : '${_issueDate!.month}/${_issueDate!.year}'),
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Expiry Date'),
                    subtitle: Text(_expiryDate == null ? 'Not set' : '${_expiryDate!.month}/${_expiryDate!.year}'),
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Certificate URL (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),
    );
  }
}
