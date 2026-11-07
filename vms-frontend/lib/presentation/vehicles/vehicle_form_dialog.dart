import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/vehicle.dart';
import '../../presentation/blocs/vehicle_cubit.dart';
class VehicleFormDialog extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleFormDialog({super.key, this.vehicle});

  @override
  State<VehicleFormDialog> createState() => _VehicleFormDialogState();
}

class _VehicleFormDialogState extends State<VehicleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _number;
  late final TextEditingController _brand;
  late final TextEditingController _model;
  late final TextEditingController _color;
  late final TextEditingController _year;
  late final TextEditingController _owner;
  late DateTime _registrationDate;
  late String _type;
  late String _status;

  @override
  void initState() {
    super.initState();
    final vehicle = widget.vehicle;
    _number = TextEditingController(text: vehicle?.vehicleNumber);
    _brand = TextEditingController(text: vehicle?.brand);
    _model = TextEditingController(text: vehicle?.model);
    _color = TextEditingController(text: vehicle?.color);
    _year = TextEditingController(text: vehicle?.year.toString());
    _owner = TextEditingController(text: vehicle?.ownerName);
    _registrationDate = vehicle?.registrationDate ?? DateTime.now();
    _type = vehicle?.type ?? 'CAR';
    _status = vehicle?.status ?? 'ACTIVE';
  }

  @override
  void dispose() {
    for (final controller in [_number, _brand, _model, _color, _year, _owner]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _registrationDate,
      firstDate: DateTime(1886),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _registrationDate = date);
  }

  Future<void> _pickManufacturingYear() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(int.tryParse(_year.text) ?? DateTime.now().year),
      firstDate: DateTime(1886),
      lastDate: DateTime(2100),
      helpText: 'Select manufacturing year',
    );
    if (selected != null) {
      setState(() => _year.text = selected.year.toString());
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final vehicle = Vehicle(
      id: widget.vehicle?.id,
      vehicleNumber: _number.text.trim(),
      brand: _brand.text.trim(),
      model: _model.text.trim(),
      type: _type,
      color: _color.text.trim(),
      year: int.parse(_year.text.trim()),
      ownerName: _owner.text.trim(),
      status: _status,
      registrationDate: _registrationDate,
      createdAt: widget.vehicle?.createdAt,
      updatedAt: widget.vehicle?.updatedAt,
    );
    final success = await context.read<VehicleCubit>().saveVehicle(vehicle);
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.vehicle != null;
    return AlertDialog(
      title: Text(editing ? AppStrings.editVehicle : AppStrings.registerVehicle),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 14,
              spacing: 14,
              children: [
                _field(_number, AppStrings.fieldVehicleNumber,
                    Validators.validateVehicleNumber),
                _field(_brand, AppStrings.fieldBrand, Validators.validateBrand),
                _field(_model, AppStrings.fieldModel, Validators.validateModel),
                _field(_color, AppStrings.fieldColor, Validators.validateColor),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    controller: _year,
                    readOnly: true,
                    validator: Validators.validateYear,
                    onTap: _pickManufacturingYear,
                    decoration: const InputDecoration(
                      labelText: AppStrings.fieldYear,
                      prefixIcon: Icon(Icons.event_outlined),
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                ),
                _field(_owner, AppStrings.fieldOwnerName,
                    Validators.validateOwnerName),
                _dropdown('Type', _type, ['CAR', 'TRUCK', 'BIKE', 'SUV', 'VAN'],
                    (value) => setState(() => _type = value!)),
                _dropdown('Status', _status, ['ACTIVE', 'INACTIVE'],
                    (value) => setState(() => _status = value!)),
                SizedBox(
                  width: 250,
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(DateFormat('yyyy-MM-dd').format(_registrationDate)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel)),
        FilledButton(onPressed: _save, child: Text(editing ? AppStrings.update : AppStrings.save)),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label,
      String? Function(String?) validator,
      {TextInputType? keyboardType}) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> values,
      ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 250,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: values
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
