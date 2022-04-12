

// class PickResult {
//   PickResult({
//     required this.placeId,
//     required this.geometry,
//     required this.formattedAddress,
//     required this.types,
//     required this.addressComponents,
//     required this.adrAddress,
//     required this.formattedPhoneNumber,
//     required this.id,
//     required this.reference,
//     required this.icon,
//     required this.name,
//     required this.openingHours,
//     required this.photos,
//     required this.internationalPhoneNumber,
//     required this.priceLevel,
//     required this.rating,
//     required this.scope,
//     required this.url,
//     required this.vicinity,
//     required this.utcOffset,
//     required this.website,
//     required this.reviews,
//   });

//   final String placeId;
//   final Geometry geometry;
//   final String formattedAddress;
//   final List<String> types;
//   final List<AddressComponent> addressComponents;

//   // Below results will not be fetched if 'usePlaceDetailSearch' is set to false (Defaults to false).
//   final String adrAddress;
//   final String formattedPhoneNumber;
//   final String id;
//   final String reference;
//   final String icon;
//   final String name;
//   final OpeningHoursDetail openingHours;
//   final List<Photo> photos;
//   final String internationalPhoneNumber;
//   final PriceLevel priceLevel;
//   final num rating;
//   final String scope;
//   final String url;
//   final String vicinity;
//   final num utcOffset;
//   final String website;
//   final List<Review> reviews;

//   factory PickResult.fromGeocodingResult(GeocodingResult result) {
//     return PickResult(
//       placeId: result.placeId,
//       geometry: result.geometry,
//       formattedAddress: result.formattedAddress,
//       types: result.types,
//       addressComponents: result.addressComponents,
//     );
//   }

//   factory PickResult.fromPlaceDetailResult(PlaceDetails result) {
//     return PickResult(
//       placeId: result.placeId,
//       geometry: result.geometry,
//       formattedAddress: result.formattedAddress,
//       types: result.types,
//       addressComponents: result.addressComponents,
//       adrAddress: result.adrAddress,
//       formattedPhoneNumber: result.formattedPhoneNumber,
//       id: result.id,
//       reference: result.reference,
//       icon: result.icon,
//       name: result.name,
//       openingHours: result.openingHours,
//       photos: result.photos,
//       internationalPhoneNumber: result.internationalPhoneNumber,
//       priceLevel: result.priceLevel,
//       rating: result.rating,
//       scope: result.scope,
//       url: result.url,
//       vicinity: result.vicinity,
//       utcOffset: result.utcOffset,
//       website: result.website,
//       reviews: result.reviews,
//     );
//   }
// }
