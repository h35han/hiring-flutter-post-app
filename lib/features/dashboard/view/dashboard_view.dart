import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_app/features/dashboard/bloc/search_posts_cubit.dart';
import 'package:flutter_post_app/ui/organisms/post_cards.dart';

import '../bloc/featured_posts_cubit.dart';
import '../bloc/recent_posts_cubit.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        maintainBottomViewPadding: true,
        child: Column(
          spacing: 12,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Good Morning!",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(),
                ],
              ),
            ),
            SearchBar(),
            BlocBuilder<SearchPostsCubit, SearchPostsState>(
              builder: (context, state) {
                if (state.posts.isNotEmpty) {
                  return Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              var post = state.posts[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: VerticalPostCard(
                                  title: post.title,
                                  content: post.body,
                                  author: post.userId.toString(),
                                  hearts: post.likes,
                                ),
                              );
                            }, childCount: state.posts.length),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.wait([
                        context.read<FeaturedPostsCubit>().refresh(),
                        context.read<RecentPostsCubit>().refresh(),
                      ]);
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SectionHeader(title: "Featured Posts", onViewMore: () {}),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 240, child: FeaturedPostsSection())),
                        SliverToBoxAdapter(
                          child: SectionHeader(title: "Recent Posts", onViewMore: () {}),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          sliver: RecentPostsSection(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        onChanged: (query) {
          context.read<SearchPostsCubit>().onQueryChanged(query);
        },
        maxLines: 1,
        decoration: InputDecoration(
          prefixIconColor: Theme.of(context).colorScheme.secondary,
          prefixIcon: Icon(Icons.search),
          hintText: "Search posts ...",
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
          border: ShapedInputBorder(shape: StadiumBorder(), borderSide: BorderSide.none),
          isDense: true,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final void Function()? onViewMore;

  const SectionHeader({super.key, required this.title, this.onViewMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          TextButton(onPressed: onViewMore, child: Text("View All")),
        ],
      ),
    );
  }
}

class FeaturedPostsSection extends StatelessWidget {
  const FeaturedPostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturedPostsCubit, FeaturedPostsState>(
      builder: (context, state) {
        if (state.errorMessage != null) {
          return Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error));
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          itemCount: state.posts.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            var post = state.posts[index];
            return HorizontalPostCard(title: post.title, author: post.userId.toString(), hearts: post.likes);
          },
        );
      },
    );
  }
}

class RecentPostsSection extends StatelessWidget {
  const RecentPostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentPostsCubit, RecentPostsState>(
      builder: (context, state) {
        if (state.errorMessage != null) {
          return Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error));
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            var post = state.posts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: VerticalPostCard(
                title: post.title,
                content: post.body,
                author: post.userId.toString(),
                hearts: post.likes,
              ),
            );
          }, childCount: state.posts.length),
        );
      },
    );
  }
}
