import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/core.dart';

part 'main_cubit.freezed.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState.tab(0));

  static const routes = [Routes.dashboard, Routes.settings];

  int get currentIndex => switch (state) {
    MainStateTab(:final index) => index,
  };

  void updateIndex(int index) {
    emit(MainState.tab(index));
  }

  void syncIndexFromPath(String matchedLocation) {
    for (int i = 0; i < routes.length; i++) {
      if (matchedLocation == routes[i].path) {
        if (currentIndex != i) emit(MainState.tab(i));
        return;
      }
    }
  }

  bool onBackPressed() {
    if (currentIndex == 0) return true;
    updateIndex(0);
    return false;
  }
}

@freezed
sealed class MainState with _$MainState {
  const factory MainState.tab(int index) = MainStateTab;
}
