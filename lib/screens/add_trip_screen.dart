import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _driverController = TextEditingController();
  final _routeController = TextEditingController();
  final _weightController = TextEditingController();
  bool _isDelivered = false;

  @override
  void dispose() {
    _driverController.dispose();
    _routeController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveTrip() {
    if (!_formKey.currentState!.validate()) return;

    final weight = double.tryParse(_weightController.text.trim()) ?? 0.0;
    final newTrip = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      driverName: _driverController.text.trim(),
      route: _routeController.text.trim(),
      cargoWeightKg: weight,
      isDelivered: _isDelivered,
    );

    Navigator.pop(context, newTrip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новый рейс')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _driverController,
                decoration: const InputDecoration(
                  labelText: 'Водитель',
                  hintText: 'Например: Иван Петров',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _routeController,
                decoration: const InputDecoration(
                  labelText: 'Маршрут (города)',
                  hintText: 'Например: Астана — Кокшетау',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Вес груза (кг)',
                  hintText: 'Например: 10500',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Статус: Доставлен'),
                subtitle: Text(_isDelivered ? 'Доставлен' : 'В пути'),
                value: _isDelivered,
                onChanged: (val) => setState(() => _isDelivered = val),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _saveTrip,
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
