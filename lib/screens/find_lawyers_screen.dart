import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/models/lawyer.dart';

class FindLawyersScreen extends StatelessWidget {
  const FindLawyersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final lawyers = List.generate(
      6,
      (i) => Lawyer(
        name: 'Adv. Lawyer ${i + 1}',
        specialization: 'Property, Contracts, IP',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Find Lawyers'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: lawyers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final lawyer = lawyers[index];

          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              onTap: () => context.push('/ai-chat'),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  lawyer.name.split(' ').last,
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              title: Text(
                lawyer.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(lawyer.specialization),
              trailing: FilledButton.tonal(
                onPressed: () {
                  context.push('/ai-chat');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening chat with ${lawyer.name}')),
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
