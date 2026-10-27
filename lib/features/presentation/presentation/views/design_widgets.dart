import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/presentation_content.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
    this.label, {
    super.key,
    required this.onTap,
    this.dark = false,
    this.compact = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool dark, compact;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: Material(
      color: dark ? AppColors.ink : AppColors.accent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: compact ? 14 : 17,
          ),
          child: Row(
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              if (compact)
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: dark ? Colors.white : AppColors.ink,
                  ),
                )
              else
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: dark ? Colors.white : AppColors.ink,
                    ),
                  ),
                ),
              SizedBox(width: compact ? 24 : 12),
              Icon(
                Icons.arrow_forward,
                size: 22,
                color: dark ? Colors.white : AppColors.ink,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class InfoCard extends StatelessWidget {
  const InfoCard(
    this.block, {
    super.key,
    this.onTap,
    this.expanded = true,
    this.tone,
    this.largeTitle = false,
    this.verticalPadding = 18,
  });
  final ContentBlock block;
  final VoidCallback? onTap;
  final bool expanded, largeTitle;
  final CardTone? tone;
  final double verticalPadding;
  @override
  Widget build(BuildContext context) {
    final current = tone ?? block.tone;
    final dark = current == CardTone.dark;
    final color = switch (current) {
      CardTone.dark => AppColors.ink,
      CardTone.accent => AppColors.accent,
      CardTone.neutral => AppColors.card,
    };
    final child = Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            block.title,
            style: TextStyle(
              fontSize: largeTitle ? 20 : 16,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: dark ? Colors.white : AppColors.ink,
            ),
          ),
          AnimatedSize(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 180),
            alignment: Alignment.topCenter,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      block.body,
                      style: TextStyle(
                        fontSize: largeTitle ? 14 : 13,
                        height: 1.4,
                        color: dark ? Colors.white : AppColors.muted,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
    return Semantics(
      button: onTap == null ? null : true,
      expanded: onTap == null ? null : expanded,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: onTap == null ? child : InkWell(onTap: onTap, child: child),
      ),
    );
  }
}

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.page,
    required this.eyebrow,
    required this.children,
    this.subtitle,
    this.codeMark = false,
  });
  final AppPage page;
  final String eyebrow;
  final String? subtitle;
  final List<Widget> children;
  final bool codeMark;
  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: CustomScrollView(
      key: PageStorageKey(page.name),
      primary: false,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        if (codeMark)
                          SizedBox(
                            width: 26,
                            height: 40,
                            child: Center(
                              child: Image.asset(
                                'assets/images/code_mark.png',
                                width: 24,
                                height: 26,
                                excludeFromSemantics: true,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            width: 28,
                            height: 40,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              tooltip: 'Назад',
                              onPressed: () => context.canPop()
                                  ? context.pop()
                                  : context.go(AppPage.overview.path),
                              icon: const Icon(Icons.arrow_back, size: 23),
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            eyebrow,
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.25,
                              color: AppColors.muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      page.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

List<Widget> spacedCards(List<ContentBlock> blocks) => [
  for (var i = 0; i < blocks.length; i++) ...[
    InfoCard(blocks[i], largeTitle: blocks[i].title == 'Не только код'),
    const SizedBox(height: 14),
  ],
];
