class LatLon {
  final double lat;
  final double lon;

  LatLon(this.lat, this.lon);

  factory LatLon.fromJson(Map<String, dynamic> json) =>
      LatLon(json["lat"], json["lon"]);
}
