package com.starkgroup.vms.mapper;

import com.starkgroup.vms.dto.request.VehicleRequest;
import com.starkgroup.vms.dto.response.VehicleResponse;
import com.starkgroup.vms.entity.Vehicle;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class VehicleMapper {

    public Vehicle toEntity(VehicleRequest request) {
        if (request == null) {
            return null;
        }

        return Vehicle.builder()
                .vehicleNumber(request.getVehicleNumber().trim().toUpperCase())
                .brand(request.getBrand().trim())
                .model(request.getModel().trim())
                .type(request.getType())
                .color(request.getColor().trim())
                .year(request.getYear())
                .ownerName(request.getOwnerName().trim())
                .status(request.getStatus())
                .registrationDate(request.getRegistrationDate())
                .build();
    }

    public VehicleResponse toResponse(Vehicle entity) {
        if (entity == null) {
            return null;
        }

        return VehicleResponse.builder()
                .id(entity.getId())
                .vehicleNumber(entity.getVehicleNumber())
                .brand(entity.getBrand())
                .model(entity.getModel())
                .type(entity.getType())
                .color(entity.getColor())
                .year(entity.getYear())
                .ownerName(entity.getOwnerName())
                .status(entity.getStatus())
                .registrationDate(entity.getRegistrationDate())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }

    public void updateEntityFromRequest(Vehicle entity, VehicleRequest request) {
        if (entity == null || request == null) {
            return;
        }

        entity.setVehicleNumber(request.getVehicleNumber().trim().toUpperCase());
        entity.setBrand(request.getBrand().trim());
        entity.setModel(request.getModel().trim());
        entity.setType(request.getType());
        entity.setColor(request.getColor().trim());
        entity.setYear(request.getYear());
        entity.setOwnerName(request.getOwnerName().trim());
        entity.setStatus(request.getStatus());
        entity.setRegistrationDate(request.getRegistrationDate());
    }

    public List<VehicleResponse> toResponseList(List<Vehicle> entities) {
        if (entities == null || entities.isEmpty()) {
            return Collections.emptyList();
        }

        return entities.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
}
