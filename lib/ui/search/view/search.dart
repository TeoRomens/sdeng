import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/search/bloc/search_bloc.dart';
import 'package:sdeng/ui/search/view/search_mobile.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const Search(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Athlete',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: BlocProvider<SearchBloc>(
        create: (context) => SearchBloc(),
        child: const Scaffold(
           body: SearchMobile(),
        ),
      ),
    );
  }
}