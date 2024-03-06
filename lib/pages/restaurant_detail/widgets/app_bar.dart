part of '../restaurant_detail_page.dart';

const _kBottomPreferredSize = kToolbarHeight + kSelectHourlyHeight;

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.restaurant,
    required this.pageControler,
    required this.isTopScroll,
    required this.pageViewHeight,
    required this.onTapHeader,
  });

  final AttaRestaurant restaurant;
  final PageController pageControler;
  final bool isTopScroll;
  final double pageViewHeight;
  final void Function() onTapHeader;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // Remove the bottom line artefact
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
      ),
      expandedHeight: pageViewHeight,
      automaticallyImplyLeading: false,
      pinned: true,
      leading: IconButton(
        onPressed: () => context.adaptativePopNamed(HomePage.routeName),
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      actions: [
        if (userService.isLogged)
          BlocSelector<RestaurantDetailCubit, RestaurantDetailState, bool>(
            selector: (state) => state.isFavorite,
            builder: (context, isFavorite) {
              return FavoriteButton(
                isFavorite: isFavorite,
                onFavoriteChanged: () => context.read<RestaurantDetailCubit>().onToogleFavoriteRestaurant(),
              );
            },
          ),
        const SizedBox(width: AttaSpacing.s),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: isTopScroll
            ? EdgeInsets.only(
                bottom: _kBottomPreferredSize + AttaSpacing.l,
                top: MediaQuery.sizeOf(context).height - pageViewHeight - kToolbarHeight / 2 + AttaSpacing.s,
              )
            : EdgeInsets.zero,
        title: isTopScroll
            ? Stack(
                children: [
                  Positioned.fill(
                    bottom: 6 + AttaSpacing.s, // Height of the indicator
                    child: PageView.builder(
                      controller: pageControler,
                      itemCount: restaurant.imagesUrl.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: restaurant.imagesUrl[index],
                          maxWidthDiskCache: 1000,
                          maxHeightDiskCache: 1000,
                          fadeInDuration: AttaAnimation.mediumAnimation,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SmoothPageIndicator(
                      controller: pageControler,
                      count: restaurant.imagesUrl.length,
                      effect: WormEffect(
                        activeDotColor: AttaColors.primary,
                        dotHeight: 6,
                        dotWidth: 12,
                      ),
                    ),
                  ),
                ],
              )
            : GestureDetector(onTap: onTapHeader),
        background: Stack(
          children: [
            Positioned.fill(
              bottom: _kScrollHeigtToShowCarousel,
              child: AnimatedCrossFade(
                duration: AttaAnimation.mediumAnimation,
                crossFadeState: isTopScroll ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
                  return Stack(
                    children: [
                      Positioned.fill(child: bottomChild),
                      Positioned.fill(child: topChild),
                    ],
                  );
                },
                firstChild: SizedBox.expand(
                  child: CachedNetworkImage(
                    imageUrl: restaurant.thumbnail,
                    maxWidthDiskCache: 1000,
                    maxHeightDiskCache: 1000,
                    fadeInDuration: AttaAnimation.mediumAnimation,
                    fit: BoxFit.cover,
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AttaColors.black.withOpacity(0.6),
                      AttaColors.black.withOpacity(0.1),
                      AttaColors.black.withOpacity(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_kBottomPreferredSize),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: AttaSpacing.m,
            right: AttaSpacing.m,
            bottom: AttaSpacing.m,
          ),
          decoration: BoxDecoration(
            color: AttaColors.white,
            borderRadius: BorderRadiusExt.top(AttaRadius.medium),
          ),
          child: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
            buildWhen: (state, previous) =>
                state.selectedDate != previous.selectedDate ||
                state.selectedOpeningTime != previous.selectedOpeningTime,
            builder: (context, state) {
              return SelectHourly(
                openingTimes: state.restaurant.openingHoursSlots,
                selectedDate: state.selectedDate,
                selectedOpeningTime: state.selectedOpeningTime,
                onDateChanged: (date) {
                  context.read<RestaurantDetailCubit>().selectDate(date);
                  context.read<RestaurantDetailCubit>().selectFirstOpeningTime();
                },
                onOpeningTimeChanged: (openingTime) {
                  context.read<RestaurantDetailCubit>().selectOpeningTime(openingTime);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
