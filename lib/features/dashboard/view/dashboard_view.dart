import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_app/features/auth/data/auth_repository.dart';

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
            TextButton(onPressed: () => context.read<AuthRepository>().logout(), child: Text("logout")),
            SearchBar(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SectionHeader(title: "Featured Posts", onViewMore: () {}),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 240, child: FeaturedPostsSection())),
                  SliverToBoxAdapter(
                    child: SectionHeader(title: "Recent Posts", onViewMore: () {}),
                  ),
                  SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 18), sliver: RecentPostsSection()),
                ],
              ),
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
      child: const TextField(
        maxLines: 1,
        decoration: InputDecoration(
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
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: 10,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) => FeaturedPostCard(
        title: "10 Tips for Better iO Development Better iO Development",
        author: "John Doe",
        hearts: 142,
      ),
    );
  }
}

class FeaturedPostCard extends StatelessWidget {
  final String title;
  final String author;
  final int hearts;

  const FeaturedPostCard({super.key, required this.title, required this.author, this.hearts = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: AspectRatio(
          aspectRatio: 5 / 4,
          child: Column(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                  child: Center(child: Text("📖", style: TextStyle(fontSize: 28))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.2),
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Text(
                          '👤 $author',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.secondary),
                        ),
                        Text(
                          '❤️ $hearts',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentPostsSection extends StatelessWidget {
  const RecentPostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RecentPostCard(
            title: "Understanding SwiftData Architecture",
            content: "Learn how to implement SwiftData in your iOS applications with practical examples",
            author: "Alice Miller",
            hearts: 142,
          ),
        );
      }, childCount: 10),
    );
  }
}

class RecentPostCard extends StatelessWidget {
  final String title;
  final String content;
  final String author;
  final int hearts;
  final int comments;

  const RecentPostCard({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    this.hearts = 0,
    this.comments = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      CircleAvatar(radius: 14, backgroundColor: Color(0x32000000)),
                      Text(author, style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.2),
                  ),
                  Text(
                    content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.2, color: Theme.of(context).colorScheme.secondary),
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      Text(
                        '❤️ $hearts',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        '💬 $comments',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
