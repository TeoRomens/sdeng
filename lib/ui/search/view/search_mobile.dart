import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          padding: const EdgeInsets.only(top: 20, right: 30, left: 30),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              SvgPicture.asset('assets/illustrations/search.svg', height: 100,),
              const SizedBox(height: 30,),
              const Text(
                  'Search an athlete',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const Text(
                'Type below the name or surname',
                style: TextStyle(
                    fontSize: 14,
                  color: Colors.grey
                ),
              ),
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
              const SizedBox(height: 20,),
              const Text(
                'Results',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
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