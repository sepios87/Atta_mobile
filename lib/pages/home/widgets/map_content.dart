part of '../home_page.dart';

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
            width: 48,
            height: 48,
            point: LatLng(restaurant.latitude, restaurant.longitude),
            child: CachedNetworkImage(
              imageUrl: restaurant.imageUrl,
              fadeInDuration: AttaAnimation.fastAnimation,
              fadeOutDuration: AttaAnimation.fastAnimation,
              memCacheWidth: 52 * 2,
              imageBuilder: (context, imageProvider) {
                return GestureDetector(
                  onTap: () {
                    final restaurantIndex = restaurants.indexOf(restaurant);
                    if (_pageController.page != restaurantIndex) {
                      _pageController.animateToPage(
                        restaurants.indexOf(restaurant),
                        duration: AttaAnimation.fastAnimation,
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _animatedMapController.animateTo(
                        dest: LatLng(restaurant.latitude, restaurant.longitude),
                        zoom: 17,
                        offset: const Offset(0, -98),
                        curve: Curves.easeInOutCubic,
                      );
                    }
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
                      zoom: 17,
                    );
                  }
                },
                // TODO(florian): set current location
                initialCenter: LatLng(43.600000, 1.433333),
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
            if (restaurants.isNotEmpty)
              Positioned(
                bottom: AttaSpacing.s,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    height: 98 +
                        AttaTextStyle.subHeader.fontSize! +
                        AttaTextStyle.content.fontSize! +
                        AttaSpacing.xs +
                        AttaSpacing.xs * 2,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        final restaurant = context.read<HomeCubit>().state.restaurants[index];
                        _animatedMapController.animateTo(
                          dest: LatLng(restaurant.latitude, restaurant.longitude),
                          zoom: 17,
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
                              child: RestaurantCard(restaurant: restaurant),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
