import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/presentation_content.dart';
import '../view_models/presentation_view_models.dart';
import 'design_widgets.dart';
import 'dialogs.dart';
import 'profile_screen.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key, required this.page});
  final AppPage page;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (page == AppPage.welcome) return const WelcomeScreen();
    if (page == AppPage.profile) return const ProfileScreen();
    void go(AppPage target) => context.go(target.path);
    Widget action(String text, AppPage target, {bool dark = false}) =>
        ActionButton(text, dark: dark, onTap: () => go(target));
    final (eyebrow, subtitle, children) = switch (page) {
      AppPage.overview => (
        'МОЙ ПУТЬ',
        null,
        <Widget>[
          const InfoCard(
            ContentBlock(
              'Одна идея. Множество платформ.',
              'Создавать полезное для Android, iOS, Mac, Linux, Windows и Web.',
              CardTone.dark,
            ),
          ),
          const SizedBox(height: 10),
          for (final (index, title, target) in _overviewLinks) ...[
            _OverviewLink(index: index, title: title, onTap: () => go(target)),
            const SizedBox(height: 5),
          ],
        ],
      ),
      AppPage.profession => (
        'МОЯ БУДУЩАЯ ПРОФЕССИЯ',
        'Кроссплатформенные мобильные приложения',
        <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '‹ / ›',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 10),
                Text(
                  'Android · iOS · Web\nWindows · macOS · Linux',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...spacedCards(const [
            ContentBlock(
              'Что я буду создавать',
              'Сервисы, которые помогают учиться, общаться, работать и решать ежедневные задачи.',
            ),
            ContentBlock(
              'В чём суть работы',
              'Превращать идею и дизайн в удобное приложение, где есть интерфейс, логика, данные и уведомления.',
            ),
          ]),
          action('К обязанностям', AppPage.duties),
          const SizedBox(height: 28),
          const CatalogView(),
          const SizedBox(height: 20),
          action('Плюсы и минусы', AppPage.tradeoffs, dark: true),
        ],
      ),
      AppPage.why => (
        'ВАЖНОСТЬ ВЫБОРА ПРОФЕССИИ',
        'Профессия влияет на то, чему я учусь, как развиваюсь и какую пользу приношу.',
        spacedCards(whyBlocks),
      ),
      AppPage.duties => (
        'ОБЯЗАННОСТИ И ЗАДАЧИ В ПРОФЕССИИ',
        'Каждый этап приближает идею к работающему продукту.',
        <Widget>[
          for (var i = 0; i < dutyBlocks.length; i++) ...[
            InfoCard(
              dutyBlocks[i],
              verticalPadding: 12,
              tone: ref.watch(selectedDutyProvider) == i
                  ? CardTone.accent
                  : CardTone.neutral,
              onTap: () {
                ref.read(selectedDutyProvider.notifier).select(i);
                if (i == dutyBlocks.length - 1) go(AppPage.skills);
              },
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
      AppPage.skills => (
        'КЛЮЧЕВЫЕ НАВЫКИ ДЛЯ\nПРОФЕССИОНАЛЬНОГО УСПЕХА',
        'Техническая база + умение работать с людьми.',
        <Widget>[
          ...spacedCards(skillBlocks),
          const SizedBox(height: 14),
          action('А как всему этому научиться?', AppPage.learning),
        ],
      ),
      AppPage.learning => (
        'ОБРАЗОВАНИЕ И ОБУЧЕНИЕ: ГДЕ И КАК\nПОЛУЧИТЬ',
        'Теория становится навыком, когда применяешь её в проекте.',
        <Widget>[
          ...spacedCards(learningBlocks),
          action('Как расти?', AppPage.growth),
        ],
      ),
      AppPage.growth => (
        'КАРЬЕРНЫЙ РОСТ И РАЗВИТИЕ',
        'Мой план развития во Flutter-разработке.',
        <Widget>[
          for (var i = 0; i < growthBlocks.length; i++) ...[
            if (i == growthBlocks.length - 1)
              InfoCard(growthBlocks[i], onTap: () => go(AppPage.tradeoffs))
            else
              InfoCard(
                growthBlocks[i],
                expanded: ref.watch(
                  expandedBlocksProvider.select((s) => s.contains('growth-$i')),
                ),
                tone:
                    ref.watch(
                      expandedBlocksProvider.select(
                        (s) => s.contains('growth-$i'),
                      ),
                    )
                    ? CardTone.accent
                    : CardTone.neutral,
                onTap: () => ref
                    .read(expandedBlocksProvider.notifier)
                    .toggle('growth-$i'),
              ),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 4),
          action('Почему я выбираю Flutter', AppPage.stack),
        ],
      ),
      AppPage.tradeoffs => (
        'ПЛЮСЫ И МИНУСЫ ПРОФЕССИИ',
        'Возможности вдохновляют. Сложности помогают оценить выбор честно.',
        <Widget>[
          ...spacedCards(tradeoffBlocks),
          action('Почему я выбираю Flutter', AppPage.stack),
        ],
      ),
      AppPage.stack => (
        'ПОЧЕМУ Я ВЫБРАЛ ЭТУ ПРОФЕССИЮ',
        'Почему я выбрал разработку на Flutter.',
        <Widget>[
          for (final block in stackBlocks) ...[
            InfoCard(block, verticalPadding: 14),
            const SizedBox(height: 10),
          ],
          action('Вернуться к обзору', AppPage.overview),
        ],
      ),
      AppPage.profile || AppPage.welcome => throw StateError('Handled above'),
    };
    return PageLayout(
      page: page,
      eyebrow: eyebrow,
      subtitle: subtitle,
      codeMark: page == AppPage.overview,
      children: children,
    );
  }
}

const _overviewLinks = [
  ('01', 'Моя будущая профессия', AppPage.profession),
  ('02', 'Почему выбор важен', AppPage.why),
  ('03', 'Мои увлечения', AppPage.profile),
  ('04', 'Обязанности и задачи', AppPage.duties),
  ('05', 'Ключевые навыки', AppPage.skills),
  ('06', 'Где и как учиться', AppPage.learning),
  ('07', 'Карьерный рост', AppPage.growth),
  ('08', 'Плюсы и минусы', AppPage.tradeoffs),
  ('09', 'Почему именно Flutter', AppPage.stack),
];

class _OverviewLink extends StatelessWidget {
  const _OverviewLink({
    required this.index,
    required this.title,
    required this.onTap,
  });
  final String index, title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.5),
        child: Row(
          children: [
            Text(
              index,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward, size: 21),
          ],
        ),
      ),
    ),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark,
    child: Scaffold(
      backgroundColor: AppColors.welcome,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final short = constraints.maxHeight < 700;
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 520,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 42),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/welcome_art.png',
                          height: short ? constraints.maxHeight * .43 : 404,
                          fit: BoxFit.contain,
                          excludeFromSemantics: true,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Моя будущая\nпрофессия',
                          style: Theme.of(context).textTheme.headlineLarge!
                              .copyWith(fontSize: 40, height: 1.3),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Моя будущая профессия —\nразработчик мобильных приложений\nна Flutter',
                          style: TextStyle(fontSize: 16, height: 1.25),
                        ),
                        SizedBox(height: short ? 36 : 64),
                        ActionButton(
                          'Начать знакомство',
                          dark: true,
                          onTap: () => context.go(AppPage.overview.path),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class CatalogView extends ConsumerWidget {
  const CatalogView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(catalogProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Каталог платформ',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        const Text(
          'Одна основа кода — шесть платформ',
          style: TextStyle(fontSize: 12, color: AppColors.muted),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                '6 платформ',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
            Semantics(
              liveRegion: true,
              label: 'В корзине ${progress.completedSteps} из 6',
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '${progress.completedSteps}',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 600 ? 3 : 2;
            final width = (constraints.maxWidth - 12 * (columns - 1)) / columns;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (var i = 0; i < platformIds.length; i++)
                  SizedBox(
                    width: width,
                    child: _PlatformTile(index: i),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PlatformTile extends ConsumerWidget {
  const _PlatformTile({required this.index});
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = platformIds[index];
    final added = ref.watch(
      catalogProvider.select((s) => s.selected.contains(id)),
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/platform_$id.png',
              height: 36,
              width: 36,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            platformLabels[index],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Semantics(
            label:
                '${added ? 'Добавлено' : 'Добавить в корзину'}: ${platformLabels[index]}',
            button: true,
            child: Material(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                key: ValueKey('add-$id'),
                onTap: added
                    ? null
                    : () {
                        if (ref
                            .read(catalogProvider.notifier)
                            .addPlatform(id)) {
                          showCartConfirmation(
                            context,
                            ref.read(catalogProvider).completedSteps,
                          );
                        }
                      },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          added ? 'Добавлено' : 'В корзину',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Icon(added ? Icons.check : Icons.add, size: 22),
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
}
