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
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            final horizontalPadding = isMobile ? 16.0 : 24.0;
            return SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _pageHeader(isMobile),
                    SizedBox(height: isMobile ? 16 : 20),
                    _summaryCards(context, isMobile),
                    SizedBox(height: isMobile ? 16 : 20),
                    TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (query) =>
                          context.read<VehicleCubit>().loadVehicles(query: query),
                      decoration: InputDecoration(
                        hintText: AppStrings.searchVehicles,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          tooltip: AppStrings.refresh,
                          onPressed: () {
                            _searchController.clear();
                            context.read<VehicleCubit>().loadVehicles();
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                      ),
                    ),
                    SizedBox(height: isMobile ? 12 : 16),
                    _vehicleList(constraints.maxWidth - horizontalPadding * 2),
                  ],
                ),
              ),
            ),
          );},
        ),
      ),
    );
  }

  Widget _pageHeader(bool isMobile) {
    final title = Text(
      AppStrings.vehicles,
      style: Theme.of(context).textTheme.headlineLarge,
    );
    final action = FilledButton.icon(
      onPressed: () => _openForm(),
      icon: const Icon(Icons.add),
      label: const Text(AppStrings.registerVehicle),
    );
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(height: 12),
          action,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: title),
        action,
      ],
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

  Widget _summaryCards(BuildContext context, bool isMobile) {
    final vehicles = context.watch<VehicleCubit>().state.vehicles;
    final active = vehicles.where((v) => v.status == 'ACTIVE').length;
    final cards = [
      _summaryCard(AppStrings.totalVehicles, '${vehicles.length}',
          Icons.directions_car),
      _summaryCard(AppStrings.activeVehicles, '$active', Icons.check_circle),
      _summaryCard(AppStrings.inactiveVehicles, '${vehicles.length - active}',
          Icons.pause_circle),
    ];
    if (isMobile) {
      return Column(
        children: [
          for (var index = 0; index < cards.length; index++) ...[
            SizedBox(width: double.infinity, child: cards[index]),
            if (index < cards.length - 1) const SizedBox(height: 8),
          ],
        ],
      );
    }
    return Row(
      children: [
        for (var index = 0; index < cards.length; index++) ...[
          Expanded(child: cards[index]),
          if (index < cards.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }

  Widget _summaryCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: .1),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      vehicle.vehicleNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _statusChip(vehicle.status),
                ],
              ),
              const SizedBox(height: 8),
              Text('${vehicle.brand} ${vehicle.model}',
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('${vehicle.type} • ${vehicle.ownerName} • ${vehicle.year}',
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _openForm(vehicle),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                  ),
                  IconButton(
                    tooltip: AppStrings.delete,
                    onPressed: () => _delete(vehicle),
                    icon: const Icon(Icons.delete_outline,
                        color: AppColors.error),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _statusChip(String status) => Chip(
        label: Text(status),
        backgroundColor: status == 'ACTIVE'
            ? AppColors.successLight
            : AppColors.warningLight,
      );
}
