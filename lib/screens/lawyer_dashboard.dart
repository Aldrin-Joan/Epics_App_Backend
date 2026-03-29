import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/models/feed_post.dart';
import 'package:flutter_application_1/providers/feed_controller.dart';
import 'package:google_fonts/google_fonts.dart';

/// ================= PROFILE =================
///
class LawyerProfileView extends StatelessWidget {
  const LawyerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 12),

          Text(
            "Adv. Lawyer",
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 20),

          _tile(context, "Edit Profile"),
          _tile(context, "My Clients"),
          _tile(context, "Set Availability"),
          _tile(context, "Settings"),

          const Spacer(),

          TextButton(
            onPressed: () => context.go('/auth'),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  /// ✅ CORRECT TILE FUNCTION
  Widget _tile(BuildContext context, String title) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.sora(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {
        if (title == "Edit Profile") {
          context.push('/edit-profile');
        } else if (title == "My Clients") {
          context.push('/my-clients');
        } else if (title == "Set Availability") {
          context.push('/lawyer-availability');
        }
      },
    );
  }
}

/// ================= AI =================

class AIToolsView extends StatelessWidget {
  const AIToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () => context.push('/ai-chat'),
        child: const Text("Open AI Chat"),
      ),
    );
  }
}

/// ================= INBOX =================

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, i) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text("Client ${i + 1}"),
          subtitle: const Text("New legal query..."),
          onTap: () => context.push('/lawyer-to-client-chat'),
        );
      },
    );
  }
}

/// ================= NEW POST DIALOG =================

class NewPostDialog extends StatelessWidget {
  const NewPostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Post'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: InputDecoration(labelText: 'Title')),
          SizedBox(height: 8),
          TextField(decoration: InputDecoration(labelText: 'Post')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Post'),
        ),
      ],
    );
  }
}

class LawyerDashboard extends ConsumerStatefulWidget {
  const LawyerDashboard({super.key});

  @override
  ConsumerState<LawyerDashboard> createState() => _LawyerDashboardState();
}

class _LawyerDashboardState extends ConsumerState<LawyerDashboard> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screens = [
      const SocialFeed(),
      InboxView(),
      AIToolsView(),
      LawyerProfileView(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2EF),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F2EF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.lawyer,
          style: GoogleFonts.sora(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),

      body: screens[_index],

      /// 🔥 CLEAN BOTTOM NAV
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_outlined, "Feed", 0),
            _navItem(Icons.inbox_outlined, "Inbox", 1),
            _navItem(Icons.auto_awesome_outlined, "AI", 2),
            _navItem(Icons.person_outline, "Profile", 3),
          ],
        ),
      ),

      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF0A66C2),
              icon: const Icon(Icons.add),
              label: const Text("New Post"),
              onPressed: () async {
                final created = await showDialog<bool>(
                  context: context,
                  builder: (_) => const NewPostDialog(),
                );
                if (created == true) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Post created')));
                }
              },
            )
          : null,
    );
  }

  Widget _navItem(IconData icon, String label, int i) {
    final isActive = _index == i;

    return GestureDetector(
      onTap: () => setState(() => _index = i),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isActive ? const Color(0xFF0A66C2) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.sora(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? const Color(0xFF0A66C2) : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              height: 3,
              width: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF0A66C2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}

/// ================= FEED =================

class SocialFeed extends ConsumerWidget {
  const SocialFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedProvider);

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 80),
      itemCount: posts.length,
      itemBuilder: (_, i) => FeedCard(post: posts[i]),
    );
  }
}

class FeedCard extends ConsumerWidget {
  final FeedPost post;
  const FeedCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(feedProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
Row(
  children: [
    const CircleAvatar(
      radius: 20,
      child: Icon(Icons.person, size: 18),
    ),
    
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: GoogleFonts.sora(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      post.title,
                      style: GoogleFonts.sora(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => controller.toggleFollow(post.id),
                child: Text(post.following ? "Following" : "Follow"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.content,
            style: GoogleFonts.sora(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _action(
                Icons.thumb_up_outlined,
                '${post.likes}',
                () => controller.toggleLike(post.id),
              ),
              _action(Icons.comment_outlined, "Comment", () {}),
              _action(Icons.share_outlined, "Share", () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(text, style: GoogleFonts.sora(fontSize: 13)),
        ],
      ),
    );
  }
}
