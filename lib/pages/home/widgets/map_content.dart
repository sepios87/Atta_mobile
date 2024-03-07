part of '../home_page.dart';

const _kDefaultCenterZoom = 15.0;

class _MapContent extends StatefulWidget {
  const _MapContent({super.key});

  @override
  State<_MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<_MapContent> with TickerProviderStateMixin {
  late final _animatedMapController = AnimatedMapController(
    vsync: this,
    duration: AttaAnimation.mediumAnimation,
    curve: Curves.easeInOutExpo,
  );

  final _pageController = PageController(viewportFraction: 0.8);

  void _onCenterMap() {
    locationService.determinePosition().then((position) {
      _animatedMapController.animateTo(
        dest: LatLng(position.latitude, position.longitude),
        zoom: _kDefaultCenterZoom,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _onCenterMap();
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
      selector: (state) => state.filterRestaurants(state.restaurants),
      builder: (context, restaurants) {
        final markers = restaurants.map((restaurant) {
          return Marker(
            key: Key(restaurant.id.toString()),
            width: 48,
            height: 48,
            point: LatLng(restaurant.latitude, restaurant.longitude),
            child: BlocBuilder<HomeCubit, HomeState>(
              // Rebuild just 2 restaurants
              buildWhen: (previous, current) =>
                  previous.selectedRestaurant != current.selectedRestaurant &&
                      current.selectedRestaurant?.id == restaurant.id ||
                  previous.selectedRestaurant?.id == restaurant.id,
              builder: (context, state) {
                return AnimatedContainer(
                  key: Key(restaurant.id.toString()),
                  duration: AttaAnimation.mediumAnimation,
                  decoration: state.selectedRestaurant?.id == restaurant.id
                      ? BoxDecoration(
                          border: Border.all(color: AttaColors.accent, width: 3),
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: CachedNetworkImage(
                    imageUrl: restaurant.thumbnail,
                    fadeInDuration: AttaAnimation.fastAnimation,
                    fadeOutDuration: AttaAnimation.fastAnimation,
                    useOldImageOnUrlChange: true,
                    memCacheWidth: 52 * 2,
                    imageBuilder: (context, imageProvider) {
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            restaurants.indexOf(restaurant),
                            duration: AttaAnimation.fastAnimation,
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AttaColors.black,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AttaColors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }).toList();

        return Stack(
          children: [
            FlutterMap(
              mapController: _animatedMapController.mapController,
              options: MapOptions(
                minZoom: 10,
                maxZoom: 19,
                onMapReady: () {
                  if (restaurants.length == 1) {
                    _animatedMapController.animateTo(
                      dest: LatLng(restaurants.first.latitude, restaurants.first.longitude),
                      zoom: _kDefaultCenterZoom,
                    );
                  }
                },
                initialCenter: const LatLng(43.60, 1.43),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.jawg.io/a89cf173-9914-47cc-a9d7-5ba3812680e7/{z}/{x}/{y}.png?access-token=${const String.fromEnvironment('JAWG_API_KEY')}',
                  userAgentPackageName: 'com.atta.app',
                  minZoom: 10,
                  maxZoom: 19,
                ),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    size: const Size.square(32),
                    alignment: Alignment.center,
                    disableClusteringAtZoom: _kDefaultCenterZoom.floor() - 1,
                    rotate: true,
                    animationsOptions: AnimationsOptions(
                      fadeInCurve: Curves.easeIn,
                      fadeOutCurve: Curves.easeOut,
                      centerMarker: AttaAnimation.fastAnimation,
                      zoom: AttaAnimation.mediumAnimation,
                      spiderfy: AttaAnimation.fastAnimation,
                    ),
                    markers: markers,
                    builder: (context, markers) {
                      return Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AttaColors.black),
                        child: Center(
                          child: Text(
                            markers.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: AttaSpacing.xs,
              right: AttaSpacing.xs,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AttaColors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AttaColors.black),
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: _onCenterMap,
                  icon: const Icon(
                    Icons.location_searching_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (restaurants.isNotEmpty)
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + AttaSpacing.s,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 98 + AttaTextStyle.subHeader.fontSize! + AttaSpacing.xs + AttaSpacing.xs * 2,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      final restaurant = context.read<HomeCubit>().state.restaurants[index];
                      context.read<HomeCubit>().onRestaurantSelected(restaurant);
                      _animatedMapController.animateTo(
                        dest: LatLng(restaurant.latitude, restaurant.longitude),
                        zoom: _kDefaultCenterZoom,
                        offset: const Offset(0, -98),
                      );
                    },
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.s),
                        child: InkWell(
                          onTap: () => context.adapativePushNamed(
                            RestaurantDetailPage.routeName,
                            pathParameters: RestaurantDetailPageArgument(
                              restaurantId: restaurant.id,
                            ).toPathParameters(),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AttaSpacing.xs,
                              horizontal: AttaSpacing.s,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AttaRadius.small),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AttaColors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: RestaurantCard(restaurant: restaurant, showFilters: false),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
