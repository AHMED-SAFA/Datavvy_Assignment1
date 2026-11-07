MERGE INTO vehicles (vehicle_number, brand, model, type, color, "year", owner_name, status, registration_date, created_at, updated_at)
KEY(vehicle_number)
VALUES ('SG-CAR-001', 'Audi', 'R8 V10', 'CAR', 'Matte Black', 2023, 'Tony Stark', 'ACTIVE', '2023-01-15', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

MERGE INTO vehicles (vehicle_number, brand, model, type, color, "year", owner_name, status, registration_date, created_at, updated_at)
KEY(vehicle_number)
VALUES ('SG-SUV-002', 'Range Rover', 'Sentinel', 'SUV', 'Metallic Silver', 2022, 'Pepper Potts', 'ACTIVE', '2022-05-10', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

MERGE INTO vehicles (vehicle_number, brand, model, type, color, "year", owner_name, status, registration_date, created_at, updated_at)
KEY(vehicle_number)
VALUES ('SG-TRUCK-003', 'Ford', 'F-150 Lightning', 'TRUCK', 'Deep Blue', 2023, 'Happy Hogan', 'ACTIVE', '2023-03-22', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

MERGE INTO vehicles (vehicle_number, brand, model, type, color, "year", owner_name, status, registration_date, created_at, updated_at)
KEY(vehicle_number)
VALUES ('SG-BIKE-004', 'Ducati', 'Panigale V4', 'BIKE', 'Crimson Red', 2024, 'James Rhodes', 'ACTIVE', '2024-02-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

MERGE INTO vehicles (vehicle_number, brand, model, type, color, "year", owner_name, status, registration_date, created_at, updated_at)
KEY(vehicle_number)
VALUES ('SG-VAN-005', 'Mercedes-Benz', 'Sprinter', 'VAN', 'Obsidian Black', 2021, 'Stark Security', 'INACTIVE', '2021-08-14', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

MERGE INTO vehicles (vehicle_number, brand, model, type, color, "year", owner_name, status, registration_date, created_at, updated_at)
KEY(vehicle_number)
VALUES ('SG-CAR-006', 'Acura', 'NSX', 'CAR', 'Monaco Blue', 2022, 'Peter Parker', 'ACTIVE', '2022-11-05', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
