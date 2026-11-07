package com.starkgroup.vms.dto.response;

import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VehicleResponse {

    private Long id;
    private String vehicleNumber;
    private String brand;
    private String model;
    private VehicleType type;
    private String color;
    private Integer year;
    private String ownerName;
    private VehicleStatus status;
    private LocalDate registrationDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
