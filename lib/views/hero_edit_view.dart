import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/hero_model.dart';
import '../viewmodels/hero_viewmodel.dart';

class HeroEditView extends StatefulWidget {
  final HeroModel hero;
  const HeroEditView({Key? key, required this.hero}) : super(key: key);

  @override
  _HeroEditViewState createState() => _HeroEditViewState();
}

class _HeroEditViewState extends State<HeroEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _thumbnailController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.hero.name);
    _descriptionController = TextEditingController(text: widget.hero.description);
    _thumbnailController = TextEditingController(text: widget.hero.thumbnail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HeroViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Herói',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Arial",
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar ${widget.hero.name}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Herói',
                  prefixIcon: const Icon(Icons.person, color: Colors.red),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira o nome do herói';
                  }
                  if (value.trim().length < 2) {
                    return 'O nome deve ter pelo menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: const Icon(Icons.description, color: Colors.red),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  if (value.trim().length < 10) {
                    return 'A descrição deve ter pelo menos 10 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _thumbnailController,
                decoration: InputDecoration(
                  labelText: 'URL da Miniatura (opcional)',
                  prefixIcon: const Icon(Icons.image, color: Colors.red),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final uri = Uri.tryParse(value.trim());
                    if (uri == null || !uri.isAbsolute) {
                      return 'Insira uma URL válida';
                    }
                    if (!value.toLowerCase().endsWith('.jpg') &&
                        !value.toLowerCase().endsWith('.jpeg') &&
                        !value.toLowerCase().endsWith('.png')) {
                      return 'A URL deve terminar com jpg, jpeg ou png';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isSubmitting ? 60 : double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isSubmitting = true);
                              try {
                                final updatedHero = HeroModel(
                                  id: widget.hero.id,
                                  name: _nameController.text.trim(),
                                  description: _descriptionController.text.trim(),
                                  thumbnail: _thumbnailController.text.trim().isEmpty
                                      ? 'https://via.placeholder.com/150'
                                      : _thumbnailController.text.trim(),
                                );
                                await viewModel.updateHero(updatedHero);
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao atualizar: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                if (mounted) setState(() => _isSubmitting = false);
                              }
                            }
                          },
                    child: _isSubmitting
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text(
                            'Atualizar Herói',
                            style: TextStyle(fontSize: 18),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
