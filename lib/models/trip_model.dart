class Trip {
  final String id;
  final String driverName;
  final String route;
  final double cargoWeightKg;
  bool isDelivered;

  Trip({
    required this.id,
    required this.driverName,
    required this.route,
    required this.cargoWeightKg,
    this.isDelivered = false,
  });

  String get statusText => isDelivered ? 'Доставлен' : 'В пути';

  Map<String, dynamic> toJson() => {
        'id': id,
        'driverName': driverName,
        'route': route,
        'cargoWeightKg': cargoWeightKg,
        'isDelivered': isDelivered,
      };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'] as String,
        driverName: json['driverName'] as String,
        route: json['route'] as String,
        cargoWeightKg: (json['cargoWeightKg'] as num).toDouble(),
        isDelivered: json['isDelivered'] as bool? ?? false,
      );
}
