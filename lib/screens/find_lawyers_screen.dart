import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FindLawyersScreen extends StatelessWidget {
  const FindLawyersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lawyers = List.generate(6, (i) => 'Adv. Lawyer ${i + 1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Find Lawyers')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: lawyers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final name = lawyers[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () => context.push('/ai-chat'),
              leading: CircleAvatar(child: Text(name.split(' ').last)),
              title: Text(name),
              subtitle: const Text('Property, Contracts, IP'),
              trailing: ElevatedButton(
                onPressed: () {
                  context.push('/ai-chat');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening chat with $name')),
                  );
                },
                child: const Text('Contact'),
              ),
            ),
          );
        },
      ),
    );
  }
}
