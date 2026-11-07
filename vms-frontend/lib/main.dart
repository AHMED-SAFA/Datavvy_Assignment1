import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/network/dio_client.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/validators.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/vehicle_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/vehicle_repository_impl.dart';
import 'domain/entities/vehicle.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'presentation/blocs/vehicle_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final client = DioClient(sharedPreferences: preferences);
  final authRepository = AuthRepositoryImpl(
    dataSource: AuthRemoteDataSource(dio: client.dio),
    preferences: preferences,
  );
  final vehicleRepository = VehicleRepositoryImpl(
    dataSource: VehicleRemoteDataSource(dio: client.dio),
  );

  runApp(VmsApp(
    authRepository: authRepository,
    vehicleRepository: vehicleRepository,
  ));
}

class VmsApp extends StatefulWidget {
  final AuthRepositoryImpl authRepository;
  final VehicleRepositoryImpl vehicleRepository;

  const VmsApp({
    super.key,
    required this.authRepository,
    required this.vehicleRepository,
  });

  @override
  State<VmsApp> createState() => _VmsAppState();
}

class _VmsAppState extends State<VmsApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(repository: widget.authRepository)..restoreSession(),
        ),
        BlocProvider(
          create: (_) => VehicleCubit(repository: widget.vehicleRepository),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: AuthGate(
          isDarkMode: _themeMode == ThemeMode.dark,
          onToggleTheme: () => setState(() {
            _themeMode = _themeMode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
          }),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const AuthGate({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.checking) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == AuthStatus.authenticated) {
          return VehiclePage(
            isDarkMode: isDarkMode,
            onToggleTheme: onToggleTheme,
          );
        }
        return const LoginPage();
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final busy = state.status == AuthStatus.checking;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.directions_car,
                        size: 52, color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(AppStrings.loginTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 6),
                    Text(AppStrings.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _usernameController,
                      validator: Validators.validateUsername,
                      decoration: const InputDecoration(
                        labelText: AppStrings.username,
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: Validators.validatePassword,
                      decoration: InputDecoration(
                        labelText: AppStrings.password,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    if (state.status == AuthStatus.failure) ...[
                      const SizedBox(height: 12),
                      Text(state.errorMessage ?? AppStrings.invalidCredentials,
                          style: const TextStyle(color: AppColors.error)),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: busy
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().login(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );
                              }
                            },
                      child: Text(busy ? AppStrings.signingIn : AppStrings.signIn),
                    ),
                    const SizedBox(height: 16),
                    Text(AppStrings.demoCredentialsHint,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
              selected: true,
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text(AppStrings.navDashboard),
              onTap: () => Navigator.pop(context),
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
