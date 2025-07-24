import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  final List<FormFieldConfig> fields;
  final void Function(Map<String, String>) onSubmit;

  const AppForm({
    super.key,
    required this.fields,
    required this.onSubmit,
  });

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  void _handleChange(String name, String value) {
    _formData[name] = value;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ...widget.fields.map((field) => _FormItem(
            config: field,
            onChanged: _handleChange,
          )),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class FormFieldConfig {
  final String name;
  final String label;
  final String? description;
  final bool isPassword;
  final String? initialValue;
  final String? Function(String?)? validator;

  FormFieldConfig({
    required this.name,
    required this.label,
    this.description,
    this.initialValue,
    this.validator,
    this.isPassword = false,
  });
}

class _FormItem extends StatelessWidget {
  final FormFieldConfig config;
  final void Function(String name, String value) onChanged;

  const _FormItem({
    required this.config,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(config.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: config.initialValue,
          obscureText: config.isPassword,
          validator: config.validator,
          onChanged: (value) => onChanged(config.name, value),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: config.description,
            errorStyle: const TextStyle(color: Colors.redAccent),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
