import 'package:atta/entities/filter.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/extensions/border_radius.dart';
import 'package:atta/screens/home/cubit/home_cubit.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/app_bar.dart';
import 'package:atta/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'widgets/search_bar.dart';
part 'widgets/restaurant_card.dart';
part 'widgets/restaurant_list.dart';
part 'widgets/filters.dart';
part 'widgets/default_content.dart';
part 'widgets/search_content.dart';
part 'widgets/restaurant_search_card.dart';
part 'modals/restaurant_detail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final textEditingController = TextEditingController();

    return BlocProvider(
      create: (context) => HomeCubit(
        searchFocusNode: focusNode,
        searchController: textEditingController,
      ),
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.selectedRestaurant != null) {
            showModalBottomSheet<void>(
              context: context,
              builder: (_) => const _RestaurantDetail(),
            ).whenComplete(() {
              context.read<HomeCubit>().onRestaurantUnselected();
            });
          }
        },
        child: Builder(
          builder: (context) => WillPopScope(
            onWillPop: () async {
              context.read<HomeCubit>().onWillPop();
              return false;
            },
            child: Scaffold(
              appBar: const AttaAppBar(),
              bottomNavigationBar: const AttaBottomNavigationBar(),
              body: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusExt.top(AttaRadius.radiusMedium),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AttaSpacing.l),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                      child: Row(
                        children: [
                          Flexible(
                            child: _SearchBar(
                              focusNode: focusNode,
                              textEditingController: textEditingController,
                            ),
                          ),
                          BlocSelector<HomeCubit, HomeState, bool>(
                            selector: (state) => state.isOnSearch,
                            builder: (context, isOnSearch) {
                              return isOnSearch
                                  ? IconButton(
                                      onPressed: () {
                                        context.read<HomeCubit>().resetSearch();
                                      },
                                      icon: Icon(
                                        isOnSearch ? Icons.close : Icons.search,
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AttaSpacing.s),
                    const _Filters(),
                    const SizedBox(height: AttaSpacing.s),
                    Expanded(
                      child: BlocSelector<HomeCubit, HomeState, bool>(
                        selector: (state) => state.isOnSearch,
                        builder: (context, isOnSearch) {
                          return AnimatedSwitcher(
                            duration: AttaAnimation.mediumAnimation,
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: isOnSearch
                                ? const _SearchContent(key: ValueKey('search_content'))
                                : const _DefaultContent(key: ValueKey('default_content')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
