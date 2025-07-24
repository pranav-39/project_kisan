import 'package:flutter/material.dart';

class CarouselController extends InheritedWidget {
  final PageController pageController;
  final int currentPage;
  final int totalItems;
  final void Function() scrollNext;
  final void Function() scrollPrev;

  const CarouselController({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.totalItems,
    required this.scrollNext,
    required this.scrollPrev,
    required super.child,
  });

  static CarouselController of(BuildContext context) {
    final CarouselController? result =
    context.dependOnInheritedWidgetOfExactType<CarouselController>();
    assert(result != null, 'No CarouselController found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CarouselController old) =>
      old.currentPage != currentPage;
}
