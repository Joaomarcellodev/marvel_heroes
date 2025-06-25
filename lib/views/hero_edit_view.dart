import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/hero_model.dart';
import '../viewmodels/hero_viewmodel.dart';

class HeroEditView extends StatelessWidget {
  final HeroModel hero;
  HeroEditView({required this.hero});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HeroViewModel>(context);
    _nameController.text = hero.name;
    _descriptionController.text = hero.description;
    _thumbnailController.text = hero.thumbnail;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Hero')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _thumbnailController,
                decoration: InputDecoration(labelText: 'Thumbnail URL (optional)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedHero = HeroModel(
                      id: hero.id,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      thumbnail: _thumbnailController.text.isEmpty
                          ? 'https://via.placeholder.com/150'
                          : _thumbnailController.text,
                    );
                    viewModel
                        .updateHero(updatedHero)
                        .then((_) => Navigator.pop(context))
                        .catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    });
                  }
                },
                child: Text('Update Hero'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}