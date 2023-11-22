import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/common/player_tile.dart';
import 'package:sdeng/ui/search/bloc/search_bloc.dart';

class SearchMobile extends StatelessWidget {
  const SearchMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 30.0, top: 20),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      context.read<SearchBloc>().search(searchController.value.text);
                    },
                  )
                ),
              ),
              ListView.builder(
                  itemCount: state.results.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: PlayerTileWidget(
                          athlete: state.results[index],
                        ),
                      ),
                    );
                  }
              ),
            ],
          ),
        );
      }
    );
  }
}