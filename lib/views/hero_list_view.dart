import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../viewmodels/hero_viewmodel.dart';
import 'hero_add_view.dart';
import 'hero_edit_view.dart';

class HeroListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HeroViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Heróis da Marvel',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red[400],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HeroAddView()),
        ),
        backgroundColor: Colors.red[600],
        child: Icon(Icons.add, size: 28, color: Colors.white),
        tooltip: 'Adicionar novo herói',
      ),
      body: RefreshIndicator(
        color: Colors.red[600],
        onRefresh: () => viewModel.fetchHeroes(),
        child: viewModel.state == ViewState.loading
            ? _buildLoadingState(theme)
            : viewModel.state == ViewState.error
                ? _buildErrorState(context, viewModel, theme)
                : _buildHeroList(context, viewModel, theme),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          SizedBox(height: 20),
          Text(
            'Carregando heróis da Marvel...',
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            semanticsLabel: 'Carregando lista de heróis',
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, HeroViewModel viewModel, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red[400],
            semanticLabel: 'Erro',
          ),
          SizedBox(height: 20),
          Text(
            viewModel.errorMessage ?? 'Erro ao carregar heróis',
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
            semanticsLabel: viewModel.errorMessage ?? 'Erro ao carregar heróis',
          ),
          SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => viewModel.fetchHeroes(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              side: BorderSide(color: Colors.red[600]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Tentar novamente',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroList(
      BuildContext context, HeroViewModel viewModel, ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: viewModel.heroes.length,
      itemBuilder: (context, index) {
        final hero = viewModel.heroes[index];
        return AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 300 + (index * 100)),
          child: Card(
            elevation: 3,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HeroEditView(hero: hero),
                ),
              ),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'hero-${hero.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: hero.thumbnail,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.primaryColor),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.red[400],
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hero.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                            semanticsLabel: 'Nome do herói: ${hero.name}',
                          ),
                          SizedBox(height: 6),
                          Text(
                            hero.description.isNotEmpty
                                ? hero.description
                                : 'Sem descrição disponível',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            semanticsLabel: hero.description.isNotEmpty
                                ? 'Descrição: ${hero.description}'
                                : 'Sem descrição disponível',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                        size: 28,
                      ),
                      tooltip: 'Excluir herói',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Excluir Herói'),
                            content: Text(
                                'Tem certeza que deseja excluir ${hero.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  viewModel.deleteHero(hero.id);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Excluir',
                                  style: TextStyle(color: Colors.red[600]),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
