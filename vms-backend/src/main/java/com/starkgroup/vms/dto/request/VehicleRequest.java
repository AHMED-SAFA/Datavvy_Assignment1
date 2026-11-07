package com.starkgroup.vms.dto.request;

import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VehicleRequest {

    @NotBlank(message = "Vehicle number is required")
    @Size(min = 2, max = 50, message = "Vehicle number must be between 2 and 50 characters")
    private String vehicleNumber;

    @NotBlank(message = "Brand is required")
    @Size(max = 100, message = "Brand must not exceed 100 characters")
    private String brand;

    @NotBlank(message = "Model is required")
    @Size(max = 100, message = "Model must not exceed 100 characters")
    private String model;

    @NotNull(message = "Vehicle type is required (CAR, TRUCK, BIKE, SUV, VAN)")
    private VehicleType type;

    @NotBlank(message = "Color is required")
    @Size(max = 50, message = "Color must not exceed 50 characters")
    private String color;

    @NotNull(message = "Year is required")
    @Min(value = 1886, message = "Year must be 1886 or later")
    @Max(value = 2100, message = "Year cannot exceed 2100")
    private Integer year;

    @NotBlank(message = "Owner name is required")
    @Size(max = 150, message = "Owner name must not exceed 150 characters")
    private String ownerName;

    @NotNull(message = "Status is required (ACTIVE, INACTIVE)")
    private VehicleStatus status;

    @NotNull(message = "Registration date is required")
    private LocalDate registrationDate;
}
