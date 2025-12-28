import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class LawyerDashboard extends ConsumerWidget {
  const LawyerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.lawyer),
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.feed), text: l10n.feed),
              Tab(icon: const Icon(Icons.message), text: l10n.inbox),
              const Tab(icon: Icon(Icons.auto_awesome), text: "AI Tools"),
            ],
          ),
        ),
        body: TabBarView(children: [_SocialFeed(), _Inbox(), _AITools()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final result = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('New Post'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    TextField(decoration: InputDecoration(hintText: 'Title')),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Write your post...',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Post'),
                  ),
                ],
              ),
            );
            if (result == true) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Post created')),
              );
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _SocialFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _FeedItem(index: index);
      },
    );
  }
}

class _Inbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.account_circle)),
          title: Text("Client Name ${index + 1}"),
          subtitle: const Text("Thank you for the advice, Adv. Kumar."),
          trailing: const Text("10:30 AM"),
          onTap: () {
            context.push('/ai-chat');
          },
        );
      },
    );
  }
}

class _FeedItem extends StatefulWidget {
  final int index;
  const _FeedItem({required this.index});

  @override
  State<_FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<_FeedItem> {
  bool isFollowing = false;
  bool isLiked = false;
  int likes = 0;

  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text("Adv. Senior Professional ${index + 1}"),
            subtitle: const Text("New Amendment in Patent Law"),
            trailing: TextButton(
              onPressed: () {
                setState(() => isFollowing = !isFollowing);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFollowing ? 'Following' : 'Unfollowed'),
                  ),
                );
              },
              child: Text(isFollowing ? 'Following' : 'Follow'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "I just read the latest Supreme Court judgment on data privacy. Here are my thoughts...",
            ),
          ),
          const SizedBox(height: 8),
          OverflowBar(
            children: [
              IconButton(
                icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt),
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                    likes = (likes + (isLiked ? 1 : -1)).clamp(0, 999);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text('$likes'),
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Comment'),
                      content: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Close'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Comment posted')),
                            );
                          },
                          child: const Text('Post'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share link copied')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AITools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            "Lawyer AI Assistant",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text("Summarize docs, research case laws, and more."),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/ai-chat'),
            icon: const Icon(Icons.analytics),
            label: const Text("Analyze Case File"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
