import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/hero_viewmodel.dart';
import 'hero_add_view.dart';
import 'hero_edit_view.dart';

class HeroListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HeroViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Heróis da Marvel'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HeroAddView()),
            ),
          ),
        ],
      ),
      body: viewModel.state == ViewState.loading
          ? Center(child: CircularProgressIndicator())
          : viewModel.state == ViewState.error
              ? Center(child: Text(viewModel.errorMessage ?? 'Erro'))
              : ListView.builder(
                  itemCount: viewModel.heroes.length,
                  itemBuilder: (context, index) {
                    final hero = viewModel.heroes[index];
                    return ListTile(
                      leading: Image.network(
                        hero.thumbnail,
                        width: 50,
                        height: 50,
                        errorBuilder: (_, __, ___) => Icon(Icons.error),
                      ),
                      title: Text(hero.name),
                      subtitle: Text(hero.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HeroEditView(hero: hero),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => viewModel.deleteHero(hero.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}