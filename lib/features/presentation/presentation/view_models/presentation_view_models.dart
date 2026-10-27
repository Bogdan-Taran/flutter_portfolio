import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/presentation_content.dart';

final catalogProvider = NotifierProvider<CatalogViewModel, CatalogProgress>(
  CatalogViewModel.new,
);

class CatalogViewModel extends Notifier<CatalogProgress> {
  @override
  CatalogProgress build() => const CatalogProgress();

  /// Signals the transition to six distinct selected platforms exactly once.
  bool addPlatform(String id) {
    final wasComplete = state.isComplete;
    state = state.add(id);
    return !wasComplete && state.isComplete;
  }

  void reset() => state = const CatalogProgress();
}

final expandedBlocksProvider =
    NotifierProvider<ExpandedBlocksViewModel, Set<String>>(
      ExpandedBlocksViewModel.new,
    );

class ExpandedBlocksViewModel extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};
  void toggle(String id) => state = state.contains(id)
      ? Set.unmodifiable({...state}..remove(id))
      : Set.unmodifiable({...state, id});
}

final selectedDutyProvider = NotifierProvider<SelectedDutyViewModel, int>(
  SelectedDutyViewModel.new,
);

class SelectedDutyViewModel extends Notifier<int> {
  @override
  int build() => 1;
  void select(int value) => state = value;
}
