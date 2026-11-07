import 'package:flutter_test/flutter_test.dart';

import 'package:vms_frontend/core/utils/validators.dart';

void main() {
  test('vehicle number validator rejects blank values', () {
    expect(Validators.validateVehicleNumber(''), isNotNull);
    expect(Validators.validateVehicleNumber('SG-001'), isNull);
  });
}
