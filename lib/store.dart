class Store {
  final int id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final String address;

  Store(this.id, this.name, this.type, this.latitude, this.longitude,
      this.address);

  Store.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        address = json['address'];
}
