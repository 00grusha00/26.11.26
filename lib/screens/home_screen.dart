import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../services/desktop_storage.dart';
import 'add_trip_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip> _trips = [];
  bool _isLoading = true;
  String _desktopFilePath = '';

  final List<Trip> _defaultTrips = [
    Trip(
      id: '1',
      driverName: 'Алексей Смирнов',
      route: 'Петропавловск — Астана',
      cargoWeightKg: 12400,
      isDelivered: true,
    ),
    Trip(
      id: '2',
      driverName: 'Марат Касымов',
      route: 'Алматы — Шымкент',
      cargoWeightKg: 18500,
      isDelivered: false,
    ),
    Trip(
      id: '3',
      driverName: 'Дмитрий Волков',
      route: 'Костанай — Караганда',
      cargoWeightKg: 9200,
      isDelivered: false,
    ),
    Trip(
      id: '4',
      driverName: 'Ерлан Нурпеисов',
      route: 'Астана — Павлодар',
      cargoWeightKg: 15000,
      isDelivered: true,
    ),
    Trip(
      id: '5',
      driverName: 'Сергей Морозов',
      route: 'Омск — Петропавловск',
      cargoWeightKg: 7800,
      isDelivered: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      final path = await DesktopStorage.getFilePath();
      final saved = await DesktopStorage.loadTrips();

      setState(() {
        _desktopFilePath = path;
        _trips = saved ?? List<Trip>.from(_defaultTrips);
        _isLoading = false;
      });

      if (saved == null) {
        await _persistTrips();
      }
    } catch (e) {
      setState(() {
        _trips = List<Trip>.from(_defaultTrips);
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка доступа к Рабочему столу: $e')),
        );
      }
    }
  }

  Future<void> _persistTrips() async {
    try {
      await DesktopStorage.saveTrips(_trips);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось сохранить файл: $e')),
        );
      }
    }
  }

  int get _totalCount => _trips.length;
  int get _deliveredCount => _trips.where((t) => t.isDelivered).length;
  int get _inTransitCount => _totalCount - _deliveredCount;

  Future<void> _openAddTripScreen() async {
    final newTrip = await Navigator.push<Trip>(
      context,
      MaterialPageRoute(builder: (context) => const AddTripScreen()),
    );

    if (newTrip != null) {
      setState(() {
        _trips.add(newTrip);
      });
      await _persistTrips();
    }
  }

  Future<void> _openDetailScreen(Trip trip) async {
    final deletedId = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(trip: trip)),
    );

    if (deletedId != null) {
      setState(() {
        _trips.removeWhere((item) => item.id == deletedId);
      });
      await _persistTrips();
    }
  }

  Future<void> _toggleStatus(int index, bool value) async {
    setState(() {
      _trips[index].isDelivered = value;
    });
    await _persistTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Журнал грузоперевозок'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(label: 'Всего рейсов', value: '$_totalCount'),
                          _StatItem(label: 'В пути', value: '$_inTransitCount'),
                          _StatItem(label: 'Доставлено', value: '$_deliveredCount'),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_desktopFilePath.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      'Файл: $_desktopFilePath',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 6),
                Expanded(
                  child: _trips.isEmpty
                      ? const Center(
                          child: Text('Рейсов пока нет. Нажмите + для добавления.'),
                        )
                      : ListView.builder(
                          itemCount: _trips.length,
                          itemBuilder: (context, index) {
                            final trip = _trips[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              child: ListTile(
                                onTap: () => _openDetailScreen(trip),
                                leading: Icon(
                                  trip.isDelivered
                                      ? Icons.check_circle
                                      : Icons.local_shipping,
                                  color: trip.isDelivered
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                title: Text(
                                  trip.route,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Водитель: ${trip.driverName} • ${trip.cargoWeightKg.toStringAsFixed(0)} кг • ${trip.statusText}',
                                ),
                                trailing: Switch(
                                  value: trip.isDelivered,
                                  onChanged: (val) => _toggleStatus(index, val),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTripScreen,
        tooltip: 'Добавить рейс',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
