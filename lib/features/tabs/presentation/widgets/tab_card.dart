import 'package:flutter/material.dart';
import '../../domain/models/browser_tab.dart';

class TabCard extends StatelessWidget {
  final BrowserTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const TabCard({
    super.key,
    required this.tab,
    required this.isActive,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isActive ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with favicon and close button
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  if (tab.isPrivate)
                    Icon(
                      Icons.incognito_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  else if (tab.favicon != null)
                    Image.network(
                      tab.favicon!,
                      width: 16,
                      height: 16,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.public,
                        size: 16,
                      ),
                    )
                  else
                    Icon(
                      Icons.public,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getDomain(),
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content preview
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: tab.isPrivate
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.incognito_outlined,
                              size: 32,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Private',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        )
                      : const Icon(
                          Icons.public,
                          size: 32,
                        ),
                ),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                tab.title ?? 'New Tab',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDomain() {
    if (tab.url == null || tab.url!.isEmpty) return '';
    try {
      final uri = Uri.parse(tab.url!);
      return uri.host;
    } catch (_) {
      return '';
    }
  }
}
