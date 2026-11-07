package com.starkgroup.vms.controller;

import com.starkgroup.vms.dto.request.VehicleRequest;
import com.starkgroup.vms.dto.response.ApiResponse;
import com.starkgroup.vms.dto.response.VehicleResponse;
import com.starkgroup.vms.service.VehicleService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/vehicles")
@RequiredArgsConstructor
public class VehicleController {

    private final VehicleService vehicleService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<VehicleResponse>>> getAllVehicles() {
        log.info("REST request to fetch all vehicles");
        List<VehicleResponse> vehicles = vehicleService.getAllVehicles();
        return ResponseEntity.ok(ApiResponse.success("Vehicles retrieved successfully", vehicles));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<VehicleResponse>>> searchVehicles(
            @RequestParam(required = false) String query) {
        log.info("REST request to search vehicles with query: '{}'", query);
        List<VehicleResponse> vehicles = vehicleService.searchVehicles(query);
        return ResponseEntity.ok(ApiResponse.success("Vehicle search completed successfully", vehicles));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<VehicleResponse>> getVehicleById(@PathVariable Long id) {
        log.info("REST request to get vehicle by id: {}", id);
        VehicleResponse vehicle = vehicleService.getVehicleById(id);
        return ResponseEntity.ok(ApiResponse.success("Vehicle retrieved successfully", vehicle));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<VehicleResponse>> createVehicle(@Valid @RequestBody VehicleRequest request) {
        log.info("REST request to create vehicle with number: {}", request.getVehicleNumber());
        VehicleResponse createdVehicle = vehicleService.createVehicle(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Vehicle created successfully", createdVehicle));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<VehicleResponse>> updateVehicle(
            @PathVariable Long id,
            @Valid @RequestBody VehicleRequest request) {
        log.info("REST request to update vehicle with id: {}", id);
        VehicleResponse updatedVehicle = vehicleService.updateVehicle(id, request);
        return ResponseEntity.ok(ApiResponse.success("Vehicle updated successfully", updatedVehicle));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteVehicle(@PathVariable Long id) {
        log.info("REST request to delete vehicle with id: {}", id);
        vehicleService.deleteVehicle(id);
        return ResponseEntity.noContent().build();
    }
}
