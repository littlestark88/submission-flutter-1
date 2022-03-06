import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/populartv/popular_tv_bloc.dart';
import '../bloc/populartv/popular_tv_event.dart';
import '../bloc/populartv/popular_tv_state.dart';
import '../widgets/tv_card_list.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  const PopularTvPage({Key? key}) : super(key: key);

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PopularTvBloc>().add(FetchPopularTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvBloc, PopularTvState>(
          builder: (context, state) {
            if (state is PopularTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is PopularTvError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Expanded(child: Container());
            }
          },
        ),
      ),
    );
  }
}
