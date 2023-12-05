class AttaUser {
  AttaUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.imageUrl,
  });

  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? imageUrl;
  final List<String> favoritesRestaurants = [];
  final List<String> favoritesDishes = [];
}
