package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.request.VehicleRequest;
import com.starkgroup.vms.dto.response.VehicleResponse;

import java.util.List;

public interface VehicleService {

    VehicleResponse createVehicle(VehicleRequest request);

    List<VehicleResponse> getAllVehicles();

    VehicleResponse getVehicleById(Long id);

    VehicleResponse updateVehicle(Long id, VehicleRequest request);

    void deleteVehicle(Long id);

    List<VehicleResponse> searchVehicles(String query);
}
