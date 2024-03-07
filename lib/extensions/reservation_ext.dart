import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/extensions/date_time_ext.dart';

extension AttaReservationExt on AttaReservation {
  String shareText(AttaRestaurant restaurant) {
    // TODO(florian): translate
    return "AttaReservation !\n\nRetrouves moi ${dateTime.accurateFormat(withPronoun: true).toLowerCase()} au restaurant ${restaurant.name} (${restaurant.address}) ! J'ai réservé une table pour $numberOfPersons personnes.";
  }
}
