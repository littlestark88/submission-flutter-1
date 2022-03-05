
import 'package:core/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/searchmovie/search_event.dart';

import '../bloc/searchtv/search_state_tv.dart';
import '../bloc/searchtv/search_tv_bloc.dart';
import '../widgets/tv_card_list.dart';

class SearchTvPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Tv'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged : (query) {
                  context.read<SearchTvBloc>().add(OnQueryChanged(query));
                },
                decoration: InputDecoration(
                  hintText: 'Search Title Tv',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.search,
              ),
              SizedBox(height: 16),
              Text(
                'Search Result Tv',
                style: kHeading6,
              ),
              BlocBuilder<SearchTvBloc, SearchStateTv>(
                  builder: (context, state) {
                if (state is SearchTvLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchTvHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tvData = result[index];
                        return TvCard(tvData);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchErrorTv) {
                  return Center(
                    key: Key('error_message'),
                    child: Text(state.message),
                  );
                } else {
                  return Expanded(child: Container());
                }
              })
            ],
          ),
        ));
  }
}
