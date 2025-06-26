import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/hero_viewmodel.dart';

class HeroAddView extends StatefulWidget {
  @override
  _HeroAddViewState createState() => _HeroAddViewState();
}

class _HeroAddViewState extends State<HeroAddView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HeroViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Herói', style: TextStyle(fontFamily: "arial", color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction, // Validação em tempo real
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crie um Novo Herói',
                  style: TextStyle(
                    fontFamily: "Arial",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome do Herói',
                    prefixIcon: Icon(Icons.person, color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do herói';
                    }
                    if (value.length < 2) {
                      return 'O nome deve ter pelo menos 2 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    prefixIcon: Icon(Icons.description, color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição';
                    }
                    if (value.length < 10) {
                      return 'A descrição deve ter pelo menos 10 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _thumbnailController,
                  decoration: InputDecoration(
                    labelText: 'URL da Miniatura (opcional)',
                    prefixIcon: Icon(Icons.image, color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!Uri.parse(value).isAbsolute || !value.contains(RegExp(r'\.(jpg|jpeg|png)$'))) {
                        return 'Insira uma URL válida para uma imagem (jpg, jpeg ou png)';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Center(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _isSubmitting ? 60 : double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _isSubmitting = true);
                                try {
                                  await viewModel.addHero(
                                    _nameController.text,
                                    _descriptionController.text,
                                    _thumbnailController.text,
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } finally {
                                  setState(() => _isSubmitting = false);
                                }
                              }
                            },
                      child: _isSubmitting
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              'Adicionar Herói',
                              style: TextStyle(fontSize: 18),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}