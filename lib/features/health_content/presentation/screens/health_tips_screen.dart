import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medilink/features/health_content/presentation/providers/health_content_providers.dart';
import 'package:medilink/features/health_content/presentation/state/health_content_state.dart';
import 'package:medilink/features/health_content/presentation/widgets/health_tip_card.dart';

class HealthTipsScreen extends ConsumerWidget {
  const HealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentState = ref.watch(healthContentViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tips & Articles'),
        actions: [
          if (contentState.categories.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list),
              onSelected: (category) {
                ref
                    .read(healthContentViewmodelProvider.notifier)
                    .setCategory(category == 'All' ? null : category);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'All',
                  child: Text('All Categories'),
                ),
                ...contentState.categories.map(
                  (category) => PopupMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Health Tips'),
                Tab(text: 'Articles'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildHealthTipsTab(context, contentState),
                  _buildArticlesTab(context, contentState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTipsTab(
      BuildContext context, HealthContentState contentState) {
    if (contentState.status == HealthContentStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contentState.healthTips.isEmpty) {
      return const Center(child: Text('No health tips available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contentState.healthTips.length,
      itemBuilder: (context, index) {
        final tip = contentState.healthTips[index];
        return HealthTipCard(tip: tip);
      },
    );
  }

  Widget _buildArticlesTab(
      BuildContext context, HealthContentState contentState) {
    if (contentState.status == HealthContentStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contentState.articles.isEmpty) {
      return const Center(child: Text('No articles available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contentState.articles.length,
      itemBuilder: (context, index) {
        final article = contentState.articles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => context.push('/articles/${article.id}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl.isNotEmpty)
                  Image.network(
                    article.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.article, size: 60),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Chip(
                            label: Text(article.category),
                            backgroundColor:
                                Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          ),
                          const Spacer(),
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${article.readTime} min read',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.summary,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            child: Text(article.author[0].toUpperCase()),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            article.author,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const Spacer(),
                          Text(
                            _formatDate(article.publishedAt),
                            style: TextStyle(color: Colors.grey[600]),
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
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
