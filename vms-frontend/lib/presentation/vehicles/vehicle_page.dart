import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/vehicle.dart';
import '../../presentation/blocs/auth_cubit.dart';
import '../../presentation/blocs/vehicle_cubit.dart';
import 'vehicle_form_dialog.dart';

class VehiclePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const VehiclePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<VehicleCubit>().loadVehicles(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm([Vehicle? vehicle]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => VehicleFormDialog(vehicle: vehicle),
    );
  }

  Future<void> _delete(Vehicle vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.confirmDeleteTitle),
        content: Text(
            'Are you sure you want to delete ${vehicle.vehicleNumber}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(AppStrings.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(AppStrings.delete)),
        ],
      ),
    );
    if (confirmed == true && vehicle.id != null && mounted) {
      await context.read<VehicleCubit>().deleteVehicle(vehicle.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    return Scaffold(
      drawer: _buildSidebar(context, auth.username),
      appBar: AppBar(
        title: const Text(AppStrings.navDashboard),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<VehicleCubit, VehicleState>(
        listenWhen: (previous, current) =>
            current.status == VehicleStatus.failure &&
            current.errorMessage != previous.errorMessage,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Request failed')),
          );
        },
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(AppStrings.vehicles,
                              style: Theme.of(context).textTheme.headlineLarge),
                        ),
                        FilledButton.icon(
                          onPressed: () => _openForm(),
                          icon: const Icon(Icons.add),
                          label: const Text(AppStrings.registerVehicle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _summaryCards(context),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _searchController,
                      onSubmitted: (query) =>
                          context.read<VehicleCubit>().loadVehicles(query: query),
                      decoration: InputDecoration(
                        hintText: AppStrings.searchVehicles,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            context.read<VehicleCubit>().loadVehicles();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _vehicleList(constraints.maxWidth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, String? username) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              color: AppColors.primary,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.accent,
                    child: Icon(Icons.directions_car,
                        color: AppColors.primary, size: 28),
                  ),
                  SizedBox(height: 16),
                  Text(AppStrings.appTitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(AppStrings.appSubtitle,
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car_outlined),
              title: const Text(AppStrings.navVehicles),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            ListTile(
              leading: Icon(widget.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined),
              title: Text(widget.isDarkMode ? 'Light mode' : 'Dark mode'),
              onTap: () {
                Navigator.pop(context);
                widget.onToggleTheme();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(AppStrings.logout),
              subtitle: Text(username ?? ''),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthCubit>().logout();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _summaryCards(BuildContext context) {
    final vehicles = context.watch<VehicleCubit>().state.vehicles;
    final active = vehicles.where((v) => v.status == 'ACTIVE').length;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _summaryCard(AppStrings.totalVehicles, '${vehicles.length}',
            Icons.directions_car),
        _summaryCard(AppStrings.activeVehicles, '$active', Icons.check_circle),
        _summaryCard(AppStrings.inactiveVehicles, '${vehicles.length - active}',
            Icons.pause_circle),
      ],
    );
  }

  Widget _summaryCard(String title, String value, IconData icon) {
    return SizedBox(
      width: 220,
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title),
          subtitle: Text(value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _vehicleList(double width) {
    final state = context.watch<VehicleCubit>().state;
    if (state.status == VehicleStatus.loading && state.vehicles.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(),
      ));
    }
    if (state.vehicles.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: Text(AppStrings.noVehiclesFound)),
        ),
      );
    }
    if (width < 700) {
      return Column(
        children: state.vehicles
            .map((vehicle) => _vehicleCard(context, vehicle))
            .toList(),
      );
    }
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text(AppStrings.colVehicleNo)),
            DataColumn(label: Text(AppStrings.colBrand)),
            DataColumn(label: Text(AppStrings.colModel)),
            DataColumn(label: Text(AppStrings.colType)),
            DataColumn(label: Text(AppStrings.colYear)),
            DataColumn(label: Text(AppStrings.colOwner)),
            DataColumn(label: Text(AppStrings.colStatus)),
            DataColumn(label: Text(AppStrings.colActions)),
          ],
          rows: state.vehicles.map((vehicle) => DataRow(cells: [
            DataCell(Text(vehicle.vehicleNumber)),
            DataCell(Text(vehicle.brand)),
            DataCell(Text(vehicle.model)),
            DataCell(Text(vehicle.type)),
            DataCell(Text('${vehicle.year}')),
            DataCell(Text(vehicle.ownerName)),
            DataCell(_statusChip(vehicle.status)),
            DataCell(Row(children: [
              IconButton(onPressed: () => _openForm(vehicle),
                  icon: const Icon(Icons.edit_outlined)),
              IconButton(onPressed: () => _delete(vehicle),
                  icon: const Icon(Icons.delete_outline, color: AppColors.error)),
            ])),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _vehicleCard(BuildContext context, Vehicle vehicle) => Card(
        child: ListTile(
          title: Text('${vehicle.vehicleNumber} • ${vehicle.brand} ${vehicle.model}'),
          subtitle: Text('${vehicle.type} • ${vehicle.ownerName} • ${vehicle.year}'),
          trailing: Wrap(children: [
            _statusChip(vehicle.status),
            IconButton(onPressed: () => _openForm(vehicle),
                icon: const Icon(Icons.edit_outlined)),
            IconButton(onPressed: () => _delete(vehicle),
                icon: const Icon(Icons.delete_outline, color: AppColors.error)),
          ]),
        ),
      );

  Widget _statusChip(String status) => Chip(
        label: Text(status),
        backgroundColor: status == 'ACTIVE'
            ? AppColors.successLight
            : AppColors.warningLight,
      );
}
