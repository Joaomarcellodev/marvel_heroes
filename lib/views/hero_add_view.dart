import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/hero_viewmodel.dart';

class HeroAddView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HeroViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Herói')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _thumbnailController,
                decoration: InputDecoration(labelText: 'URL da Miniatura (opcional)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    viewModel
                        .addHero(
                          _nameController.text,
                          _descriptionController.text,
                          _thumbnailController.text,
                        )
                        .then((_) => Navigator.pop(context))
                        .catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro: $e')),
                      );
                    });
                  }
                },
                child: Text('Adicionar Herói'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}