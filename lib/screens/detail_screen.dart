import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class DetailScreen extends StatelessWidget {
  final Trip trip;

  const DetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали рейса'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Удалить рейс',
            onPressed: () => Navigator.pop(context, trip.id),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.route,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    _DetailRow(label: 'ID рейса:', value: trip.id),
                    _DetailRow(label: 'Водитель:', value: trip.driverName),
                    _DetailRow(
                      label: 'Вес груза:',
                      value: '${trip.cargoWeightKg.toStringAsFixed(1)} кг',
                    ),
                    _DetailRow(label: 'Статус:', value: trip.statusText),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, trip.id),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Удалить из журнала'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
