class AppStrings {
  // App Branding
  static const String appTitle = 'Stark Group VMS';
  static const String appSubtitle = 'Vehicle Management System';
  static const String companyName = 'Stark Group Industries';

  // Auth / Login
  static const String loginTitle = 'Welcome to Stark Group';
  static const String loginSubtitle = 'Sign in to access the fleet management portal';
  static const String username = 'Username';
  static const String password = 'Password';
  static const String signIn = 'Sign In';
  static const String signingIn = 'Signing in...';
  static const String logout = 'Log Out';
  static const String demoCredentialsHint = 'Default credentials: admin / admin123';
  static const String invalidCredentials = 'Invalid username or password';

  // Navigation
  static const String navDashboard = 'Dashboard';
  static const String navVehicles = 'Vehicles';
  static const String navSettings = 'Settings';

  // Vehicle Management
  static const String vehicles = 'Vehicles';
  static const String registerVehicle = 'Register Vehicle';
  static const String editVehicle = 'Edit Vehicle';
  static const String addVehicle = 'Add Vehicle';
  static const String vehicleDetails = 'Vehicle Details';
  static const String deleteVehicle = 'Delete Vehicle';
  static const String searchVehicles = 'Search by vehicle number, brand, model or owner...';
  static const String noVehiclesFound = 'No vehicles found';
  static const String totalVehicles = 'Total Vehicles';
  static const String activeVehicles = 'Active Vehicles';
  static const String inactiveVehicles = 'Inactive Vehicles';

  // Table Columns
  static const String colId = 'ID';
  static const String colVehicleNo = 'Vehicle No';
  static const String colBrand = 'Brand';
  static const String colModel = 'Model';
  static const String colType = 'Type';
  static const String colColor = 'Color';
  static const String colYear = 'Year';
  static const String colOwner = 'Owner';
  static const String colStatus = 'Status';
  static const String colRegDate = 'Reg. Date';
  static const String colActions = 'Actions';

  // Form Fields
  static const String fieldVehicleNumber = 'Vehicle Number';
  static const String fieldVehicleNumberHint = 'e.g. SG-CAR-007';
  static const String fieldBrand = 'Brand';
  static const String fieldBrandHint = 'e.g. Audi, Tesla, Ford';
  static const String fieldModel = 'Model';
  static const String fieldModelHint = 'e.g. R8 V10, Model 3';
  static const String fieldType = 'Vehicle Type';
  static const String fieldColor = 'Color';
  static const String fieldColorHint = 'e.g. Matte Black, Red';
  static const String fieldYear = 'Manufacturing Year';
  static const String fieldYearHint = 'e.g. 2024';
  static const String fieldOwnerName = 'Owner Name';
  static const String fieldOwnerNameHint = 'e.g. Tony Stark';
  static const String fieldStatus = 'Status';
  static const String fieldRegDate = 'Registration Date';
  static const String selectDate = 'Select Date';

  // Buttons
  static const String save = 'Save';
  static const String update = 'Update';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';
  static const String refresh = 'Refresh';

  // Dialogs
  static const String confirmDeleteTitle = 'Delete Vehicle';
  static const String confirmDeleteMessage =
      'Are you sure you want to delete vehicle "{vehicleNumber}"? This action cannot be undone.';

  // Validation Messages
  static const String valRequired = 'This field is required';
  static const String valVehicleNumberRequired = 'Vehicle number is required';
  static const String valVehicleNumberLength = 'Vehicle number must be between 2 and 50 characters';
  static const String valBrandRequired = 'Brand is required';
  static const String valModelRequired = 'Model is required';
  static const String valTypeRequired = 'Please select a vehicle type';
  static const String valColorRequired = 'Color is required';
  static const String valYearRequired = 'Year is required';
  static const String valYearRange = 'Year must be between 1886 and 2100';
  static const String valOwnerRequired = 'Owner name is required';
  static const String valDateRequired = 'Registration date is required';
  static const String valDuplicateVehicle = 'A vehicle with this number already exists.';
}
