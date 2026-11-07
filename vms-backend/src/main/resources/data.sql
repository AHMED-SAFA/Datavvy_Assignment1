INSERT INTO vehicles
    (vehicle_number, brand, model, type, color, "year", owner_name, status,
     registration_date, created_at, updated_at)
VALUES
    ('SG-CAR-001', 'Audi', 'R8 V10', 'CAR', 'Matte Black', 2023, 'Tony Stark',
     'ACTIVE', '2023-01-15', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (vehicle_number) DO NOTHING;

INSERT INTO vehicles
    (vehicle_number, brand, model, type, color, "year", owner_name, status,
     registration_date, created_at, updated_at)
VALUES
    ('SG-CAR-007', 'BMW', 'M4 Competition', 'CAR', 'Alpine White', 2023, 'Bruce Wayne', 'ACTIVE', '2023-01-20', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-SUV-008', 'Volvo', 'XC90', 'SUV', 'Crystal White', 2022, 'Natasha Romanoff', 'ACTIVE', '2022-02-14', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-TRUCK-009', 'Toyota', 'Hilux', 'TRUCK', 'Graphite Gray', 2021, 'Sam Wilson', 'INACTIVE', '2021-03-18', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-BIKE-010', 'Yamaha', 'MT-09', 'BIKE', 'Storm Fluo', 2024, 'Scott Lang', 'ACTIVE', '2024-04-02', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-VAN-011', 'Volkswagen', 'Crafter', 'VAN', 'Candy White', 2020, 'Wanda Maximoff', 'ACTIVE', '2020-05-11', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-CAR-012', 'Mercedes-Benz', 'C-Class', 'CAR', 'Obsidian Black', 2023, 'Steve Rogers', 'ACTIVE', '2023-06-09', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-SUV-013', 'Toyota', 'Land Cruiser', 'SUV', 'Desert Sand', 2021, 'Carol Danvers', 'INACTIVE', '2021-07-22', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-TRUCK-014', 'Tesla', 'Cybertruck', 'TRUCK', 'Stainless Steel', 2024, 'Peter Quill', 'ACTIVE', '2024-08-03', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-BIKE-015', 'Kawasaki', 'Ninja ZX-10R', 'BIKE', 'Lime Green', 2022, 'Stephen Strange', 'ACTIVE', '2022-09-16', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-VAN-016', 'Ford', 'Transit', 'VAN', 'Frozen White', 2020, 'Maria Hill', 'INACTIVE', '2020-10-28', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-CAR-017', 'Lexus', 'ES 350', 'CAR', 'Nori Green', 2022, 'Clint Barton', 'ACTIVE', '2022-11-12', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-SUV-018', 'Hyundai', 'Palisade', 'SUV', 'Moonlight Cloud', 2023, 'Shuri', 'ACTIVE', '2023-12-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-TRUCK-019', 'Chevrolet', 'Silverado', 'TRUCK', 'Summit White', 2021, 'James Barnes', 'ACTIVE', '2021-01-07', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-BIKE-020', 'Honda', 'Africa Twin', 'BIKE', 'Grand Prix Red', 2023, 'Nick Fury', 'INACTIVE', '2023-02-19', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-VAN-021', 'Renault', 'Master', 'VAN', 'Pearl Black', 2022, 'Okoye', 'ACTIVE', '2022-03-27', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-CAR-022', 'Porsche', '911 Carrera', 'CAR', 'Guards Red', 2024, 'Harley Keener', 'ACTIVE', '2024-04-15', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-SUV-023', 'Kia', 'Telluride', 'SUV', 'Everlasting Silver', 2020, 'Scott Lang', 'INACTIVE', '2020-05-30', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-TRUCK-024', 'Isuzu', 'D-Max', 'TRUCK', 'Mercury Silver', 2022, 'Happy Hogan', 'ACTIVE', '2022-06-18', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-BIKE-025', 'Triumph', 'Tiger 900', 'BIKE', 'Sapphire Black', 2021, 'Pepper Potts', 'ACTIVE', '2021-07-04', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-VAN-026', 'Nissan', 'NV350', 'VAN', 'Brilliant Silver', 2023, 'Riri Williams', 'ACTIVE', '2023-08-21', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-CAR-027', 'Jaguar', 'F-Type', 'CAR', 'British Racing Green', 2021, 'Bruce Banner', 'INACTIVE', '2021-09-10', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-SUV-028', 'Mazda', 'CX-60', 'SUV', 'Soul Red Crystal', 2024, 'Kamala Khan', 'ACTIVE', '2024-10-06', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-TRUCK-029', 'Ram', '1500 Rebel', 'TRUCK', 'Flame Red', 2022, 'Rhodey', 'ACTIVE', '2022-11-24', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SG-BIKE-030', 'Suzuki', 'Hayabusa', 'BIKE', 'Metallic Mat Sword Silver', 2023, 'Bucky Barnes', 'ACTIVE', '2023-12-17', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (vehicle_number) DO NOTHING;

INSERT INTO vehicles
    (vehicle_number, brand, model, type, color, "year", owner_name, status,
     registration_date, created_at, updated_at)
VALUES
    ('SG-SUV-002', 'Range Rover', 'Sentinel', 'SUV', 'Metallic Silver', 2022,
     'Pepper Potts', 'ACTIVE', '2022-05-10', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (vehicle_number) DO NOTHING;

INSERT INTO vehicles
    (vehicle_number, brand, model, type, color, "year", owner_name, status,
     registration_date, created_at, updated_at)
VALUES
    ('SG-TRUCK-003', 'Ford', 'F-150 Lightning', 'TRUCK', 'Deep Blue', 2023,
     'Happy Hogan', 'ACTIVE', '2023-03-22', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (vehicle_number) DO NOTHING;

INSERT INTO vehicles
    (vehicle_number, brand, model, type, color, "year", owner_name, status,
     registration_date, created_at, updated_at)
VALUES
    ('SG-BIKE-004', 'Ducati', 'Panigale V4', 'BIKE', 'Crimson Red', 2024,
     'James Rhodes', 'ACTIVE', '2024-02-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (vehicle_number) DO NOTHING;

INSERT INTO vehicles
    (vehicle_number, brand, model, type, color, "year", owner_name, status,
     registration_date, created_at, updated_at)
VALUES
    ('SG-VAN-005', 'Mercedes-Benz', 'Sprinter', 'VAN', 'Obsidian Black', 2021,
     'Stark Security', 'INACTIVE', '2021-08-14', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (vehicle_number) DO NOTHING;

INSERT INTO vehicles
    (vehicle_number, brand, model, type, color, "year", owner_name, status,
     registration_date, created_at, updated_at)
VALUES
    ('SG-CAR-006', 'Acura', 'NSX', 'CAR', 'Monaco Blue', 2022, 'Peter Parker',
     'ACTIVE', '2022-11-05', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (vehicle_number) DO NOTHING;
