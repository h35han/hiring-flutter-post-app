import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/featured_posts_cubit.dart';
import '../bloc/recent_posts_cubit.dart';
import '../bloc/search_posts_cubit.dart';
import '../data/dashboard_repository.dart';
import 'dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RecentPostsCubit(context.read<DashboardRepository>())..load()),
        BlocProvider(create: (context) => FeaturedPostsCubit(context.read<DashboardRepository>())..load()),
        BlocProvider(create: (context) => SearchPostsCubit(context.read<DashboardRepository>())),
      ],
      child: DashboardView(),
    );
  }
}
