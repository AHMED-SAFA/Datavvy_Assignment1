package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.request.VehicleRequest;
import com.starkgroup.vms.dto.response.VehicleResponse;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.exception.DuplicateVehicleNumberException;
import com.starkgroup.vms.exception.ResourceNotFoundException;
import com.starkgroup.vms.mapper.VehicleMapper;
import com.starkgroup.vms.repository.VehicleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class VehicleServiceImpl implements VehicleService {

    private final VehicleRepository vehicleRepository;
    private final VehicleMapper vehicleMapper;

    @Override
    @Transactional
    public VehicleResponse createVehicle(VehicleRequest request) {
        String normalizedVehicleNumber = request.getVehicleNumber().trim().toUpperCase();
        log.info("Creating vehicle with vehicle number: {}", normalizedVehicleNumber);

        if (vehicleRepository.existsByVehicleNumberIgnoreCase(normalizedVehicleNumber)) {
            log.warn("Vehicle creation failed: Vehicle number '{}' already exists", normalizedVehicleNumber);
            throw new DuplicateVehicleNumberException(
                    String.format("Vehicle with number '%s' already exists", normalizedVehicleNumber)
            );
        }

        Vehicle vehicle = vehicleMapper.toEntity(request);
        Vehicle savedVehicle = vehicleRepository.save(vehicle);
        log.info("Vehicle created successfully with id: {}", savedVehicle.getId());

        return vehicleMapper.toResponse(savedVehicle);
    }

    @Override
    public List<VehicleResponse> getAllVehicles() {
        log.info("Fetching all vehicles");
        List<Vehicle> vehicles = vehicleRepository.findAllByOrderByIdDesc();
        return vehicleMapper.toResponseList(vehicles);
    }

    @Override
    public VehicleResponse getVehicleById(Long id) {
        log.info("Fetching vehicle by id: {}", id);
        Vehicle vehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle", "id", id));
        return vehicleMapper.toResponse(vehicle);
    }

    @Override
    @Transactional
    public VehicleResponse updateVehicle(Long id, VehicleRequest request) {
        String normalizedVehicleNumber = request.getVehicleNumber().trim().toUpperCase();
        log.info("Updating vehicle with id: {}, vehicle number: {}", id, normalizedVehicleNumber);

        Vehicle existingVehicle = vehicleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle", "id", id));

        if (vehicleRepository.existsByVehicleNumberIgnoreCaseAndIdNot(normalizedVehicleNumber, id)) {
            log.warn("Vehicle update failed: Vehicle number '{}' is already in use by another vehicle", normalizedVehicleNumber);
            throw new DuplicateVehicleNumberException(
                    String.format("Vehicle with number '%s' already exists for another vehicle", normalizedVehicleNumber)
            );
        }

        vehicleMapper.updateEntityFromRequest(existingVehicle, request);
        Vehicle updatedVehicle = vehicleRepository.save(existingVehicle);
        log.info("Vehicle updated successfully with id: {}", updatedVehicle.getId());

        return vehicleMapper.toResponse(updatedVehicle);
    }

    @Override
    @Transactional
    public void deleteVehicle(Long id) {
        log.info("Deleting vehicle with id: {}", id);
        if (!vehicleRepository.existsById(id)) {
            log.warn("Vehicle delete failed: Vehicle with id {} not found", id);
            throw new ResourceNotFoundException("Vehicle", "id", id);
        }
        vehicleRepository.deleteById(id);
        log.info("Vehicle deleted successfully with id: {}", id);
    }

    @Override
    public List<VehicleResponse> searchVehicles(String query) {
        if (!StringUtils.hasText(query)) {
            log.info("Search query is empty, returning all vehicles");
            return getAllVehicles();
        }

        String trimmedQuery = query.trim();
        log.info("Searching vehicles with query: '{}'", trimmedQuery);
        List<Vehicle> results = vehicleRepository.searchVehicles(trimmedQuery);
        return vehicleMapper.toResponseList(results);
    }
}
