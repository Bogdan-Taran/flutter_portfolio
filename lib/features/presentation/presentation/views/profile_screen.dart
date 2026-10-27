import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/presentation_content.dart';
import 'design_widgets.dart';
import 'dialogs.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => PageLayout(
    page: AppPage.profile,
    eyebrow: 'МОЙ ПРОФИЛЬ',
    codeMark: true,
    children: [
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/avatar.png',
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                semanticLabel: 'Богдан Таран',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Богдан Таран',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Разработчик мобильных\nприложений на Flutter',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const InfoCard(
        ContentBlock(
          'Образование',
          'ТТИТ — 4 курс\nСпециальность: разработчик веб- и мультимедийных приложений.\nСостою на кафедре разработки.',
        ),
      ),
      const SizedBox(height: 4),
      Text('Мой стек', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.muted),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tech in techStack)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  tech,
                  style: const TextStyle(color: AppColors.accent, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Align(
        alignment: Alignment.centerRight,
        child: ActionButton(
          'Стек?',
          compact: true,
          onTap: () => context.go(AppPage.stack.path),
        ),
      ),
      const SizedBox(height: 28),
      Text(
        'Участие и достижения',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 18),
      for (var i = 0; i < achievements.length; i++) ...[
        _AchievementCard(item: achievements[i], index: i),
        const SizedBox(height: 12),
      ],
      const SizedBox(height: 6),
      Align(
        alignment: Alignment.centerRight,
        child: ActionButton(
          'Почему?',
          compact: true,
          onTap: () => context.go(AppPage.why.path),
        ),
      ),
      const SizedBox(height: 64),
      Text('Хобби и навыки', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 10),
      LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - 12) / 2;
          return Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              for (final label in hobbyLabels)
                SizedBox(
                  width: width,
                  child: _HobbyTile(label: label),
                ),
            ],
          );
        },
      ),
      const SizedBox(height: 14),
    ],
  );
}

class _HobbyTile extends StatelessWidget {
  const _HobbyTile({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final hobby = hobbies[label];
    return Semantics(
      button: hobby == null ? null : true,
      child: Material(
        color: hobby == null ? AppColors.ink : AppColors.accent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          key: ValueKey('hobby-${hobby?.image ?? label}'),
          borderRadius: BorderRadius.circular(20),
          onTap: hobby == null ? null : () => showHobby(context, hobby),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: hobby == null ? Colors.white : AppColors.ink,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.item, required this.index});
  final Achievement item;
  final int index;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/achievement_$index.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Divider(height: 1, color: Color(0xffe8e9e2)),
        ),
        Text(
          item.description,
          style: const TextStyle(
            fontSize: 12,
            height: 1.4,
            color: Color(0xff62665b),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                item.result,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (item.year.isNotEmpty)
              Text(
                item.year,
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
          ],
        ),
      ],
    ),
  );
}
