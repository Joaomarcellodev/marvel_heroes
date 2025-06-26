import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repository/hero_repository.dart';
import 'data/services/api_service.dart';
import 'viewmodels/hero_viewmodel.dart';
import 'views/hero_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (context) => HeroRepository(context.read<ApiService>())),
        ChangeNotifierProvider(
          create: (context) => HeroViewModel(context.read<HeroRepository>())..fetchHeroes(),
        ),
      ],
      child: MaterialApp(
        title: 'Marvel Heroes',
        theme: ThemeData(primarySwatch: Colors.red),
        debugShowCheckedModeBanner: false,
        home: HeroListView(),
      ),
    );
  }
}