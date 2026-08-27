import 'package:flutter/material.dart';

class HorizontalPostCard extends StatelessWidget {
  final String title;
  final String author;
  final int hearts;

  const HorizontalPostCard({super.key, required this.title, required this.author, this.hearts = 0});

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

class VerticalPostCard extends StatelessWidget {
  final String title;
  final String content;
  final String author;
  final int hearts;
  final int comments;

  const VerticalPostCard({
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
