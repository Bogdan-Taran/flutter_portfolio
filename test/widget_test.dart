import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio/app/app.dart';
import 'package:flutter_portfolio/app/router.dart';
import 'package:flutter_portfolio/features/presentation/domain/presentation_content.dart';
import 'package:flutter_portfolio/features/presentation/presentation/view_models/presentation_view_models.dart';

void main() {
  setUpAll(() async {
    final roboto = FontLoader('Roboto');
    for (final file in ['Regular']) {
      roboto.addFont(rootBundle.load('assets/fonts/Roboto-$file.ttf'));
    }
    await roboto.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    await (FontLoader('packages/cupertino_icons/CupertinoIcons')..addFont(
          rootBundle.load('packages/cupertino_icons/assets/CupertinoIcons.ttf'),
        ))
        .load();
  });

  test(
    'catalog accepts distinct platforms in any order and completes once',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final model = container.read(catalogProvider.notifier);
      expect(model.addPlatform('invalid'), false);
      for (final id in platformIds.reversed.take(5)) {
        expect(model.addPlatform(id), false);
        expect(model.addPlatform(id), false);
      }
      expect(container.read(catalogProvider).completedSteps, 5);
      expect(model.addPlatform('android'), true);
      expect(model.addPlatform('android'), false);
      expect(container.read(catalogProvider).completedSteps, 6);
      model.reset();
      expect(container.read(catalogProvider).completedSteps, 0);
    },
  );

  test('growth blocks expand independently and close on repeated tap', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final model = container.read(expandedBlocksProvider.notifier);
    model.toggle('growth-0');
    model.toggle('growth-1');
    model.toggle('growth-0');
    expect(container.read(expandedBlocksProvider), {'growth-1'});
  });

  Future<ProviderContainer> start(
    WidgetTester tester, {
    double width = 393,
    double scale = 1,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 852);
    tester.view.padding = const FakeViewPadding(top: 44, bottom: 26);
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PortfolioApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      final context = tester.element(find.byType(PortfolioApp));
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      for (final asset in manifest.listAssets().where(
        (p) => p.startsWith('assets/images/'),
      )) {
        if (!context.mounted) break;
        await precacheImage(AssetImage(asset), context);
      }
    });
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('all eleven screens render at phone and tablet widths', (
    tester,
  ) async {
    final container = await start(tester);
    for (final width in [320.0, 393.0, 900.0]) {
      tester.view.physicalSize = Size(width, 852);
      for (final page in AppPage.values) {
        container.read(routerProvider).go(page.path);
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${page.name} at $width',
        );
      }
    }
  });

  testWidgets('screens support enlarged text on a narrow phone', (
    tester,
  ) async {
    final container = await start(tester, width: 320, scale: 1.6);
    for (final page in AppPage.values) {
      container.read(routerProvider).go(page.path);
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'large text: ${page.name}',
      );
    }
  });

  testWidgets('profession child survives tab switches', (tester) async {
    final container = await start(tester);
    final router = container.read(routerProvider);
    router.go(AppPage.tradeoffs.path);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-4')));
    await tester.pumpAndSettle();
    expect(find.text('Богдан Таран'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('nav-1')));
    await tester.pumpAndSettle();
    expect(find.text(AppPage.tradeoffs.title), findsOneWidget);
  });

  testWidgets('all accent hobby sheets open and close with the cross', (
    tester,
  ) async {
    final container = await start(tester);
    container.read(routerProvider).go(AppPage.profile.path);
    await tester.pumpAndSettle();
    for (final hobby in hobbies.values) {
      final tile = find.byKey(ValueKey('hobby-${hobby.image}'));
      await tester.scrollUntilVisible(
        tile,
        650,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(find.text(hobby.description), findsOneWidget);
      if (const bool.fromEnvironment('CAPTURE')) {
        await expectLater(
          find.byType(PortfolioApp),
          matchesGoldenFile('../review/hobby_${hobby.image}.png'),
        );
      }
      await tester.tap(find.byTooltip('Закрыть'));
      await tester.pumpAndSettle();
      expect(find.text(hobby.description), findsNothing);
    }
  });

  testWidgets(
    'six catalog buttons update count and show closable confirmation',
    (tester) async {
      final container = await start(tester);
      container.read(routerProvider).go(AppPage.profession.path);
      await tester.pumpAndSettle();
      for (final id in platformIds) {
        final button = find.byKey(ValueKey('add-$id'));
        await tester.scrollUntilVisible(
          button,
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(button);
        await tester.pumpAndSettle();
      }
      expect(container.read(catalogProvider).completedSteps, 6);
      expect(find.text('Добавлено в корзину'), findsOneWidget);
      if (const bool.fromEnvironment('CAPTURE')) {
        await expectLater(
          find.byType(PortfolioApp),
          matchesGoldenFile('../review/cart_confirmation.png'),
        );
      }
      await tester.tap(find.byTooltip('Закрыть'));
      await tester.pumpAndSettle();
      expect(find.text('Добавлено в корзину'), findsNothing);
    },
  );

  testWidgets(
    'growth is collapsed, expands, and final block switches to profession',
    (tester) async {
      final container = await start(tester);
      container.read(routerProvider).go(AppPage.growth.path);
      await tester.pumpAndSettle();
      expect(find.text(growthBlocks[0].body), findsNothing);
      await tester.tap(find.text(growthBlocks[0].title));
      await tester.pumpAndSettle();
      expect(find.text(growthBlocks[0].body), findsOneWidget);
      await tester.tap(find.text(growthBlocks.last.title));
      await tester.pumpAndSettle();
      expect(find.text(AppPage.tradeoffs.title), findsOneWidget);
      expect(
        container.read(routerProvider).routeInformationProvider.value.uri.path,
        AppPage.tradeoffs.path,
      );
    },
  );

  testWidgets('last duty opens skills then education', (tester) async {
    final container = await start(tester);
    container.read(routerProvider).go(AppPage.duties.path);
    await tester.pumpAndSettle();
    final last = find.text(dutyBlocks.last.title);
    await tester.ensureVisible(last);
    await tester.pumpAndSettle();
    await tester.tap(last);
    await tester.pumpAndSettle();
    expect(
      container.read(routerProvider).routeInformationProvider.value.uri.path,
      AppPage.skills.path,
    );
    final learn = find.text('А как всему этому научиться?');
    await tester.ensureVisible(learn);
    await tester.pumpAndSettle();
    await tester.tap(learn);
    await tester.pumpAndSettle();
    expect(
      container.read(routerProvider).routeInformationProvider.value.uri.path,
      AppPage.learning.path,
    );
  });

  testWidgets('profile and growth actions return through stack to overview', (
    tester,
  ) async {
    final container = await start(tester);
    final router = container.read(routerProvider);
    Future<void> tap(String label) async {
      final target = find.text(label).last;
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    await tap('Начать знакомство');
    await tester.tap(find.byKey(const ValueKey('nav-4')));
    await tester.pumpAndSettle();
    await tap('Стек?');
    expect(router.routeInformationProvider.value.uri.path, AppPage.stack.path);
    await tap('Вернуться к обзору');
    expect(
      router.routeInformationProvider.value.uri.path,
      AppPage.overview.path,
    );
    router.go(AppPage.profile.path);
    await tester.pumpAndSettle();
    await tap('Почему?');
    expect(router.routeInformationProvider.value.uri.path, AppPage.why.path);
    router.go(AppPage.learning.path);
    await tester.pumpAndSettle();
    await tap('Как расти?');
    expect(router.routeInformationProvider.value.uri.path, AppPage.growth.path);
    await tap('Почему я выбираю Flutter');
    expect(router.routeInformationProvider.value.uri.path, AppPage.stack.path);
    router.go(AppPage.tradeoffs.path);
    await tester.pumpAndSettle();
    await tap('Почему я выбираю Flutter');
    expect(router.routeInformationProvider.value.uri.path, AppPage.stack.path);
  });

  if (const bool.fromEnvironment('CAPTURE')) {
    for (final page in AppPage.values) {
      testWidgets('render review: ${page.name}', (tester) async {
        final container = await start(tester);
        container.read(routerProvider).go(page.path);
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(PortfolioApp),
          matchesGoldenFile('../review/${page.name}.png'),
        );
      });
    }
  }
}
