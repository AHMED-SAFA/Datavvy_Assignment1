package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.request.VehicleRequest;
import com.starkgroup.vms.dto.response.VehicleResponse;
import com.starkgroup.vms.entity.Vehicle;
import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;
import com.starkgroup.vms.exception.DuplicateVehicleNumberException;
import com.starkgroup.vms.exception.ResourceNotFoundException;
import com.starkgroup.vms.mapper.VehicleMapper;
import com.starkgroup.vms.repository.VehicleRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class VehicleServiceTest {

    @Mock
    private VehicleRepository vehicleRepository;

    @Spy
    private VehicleMapper vehicleMapper;

    @InjectMocks
    private VehicleServiceImpl vehicleService;

    private Vehicle sampleVehicle;
    private VehicleRequest sampleRequest;

    @BeforeEach
    void setUp() {
        sampleVehicle = Vehicle.builder()
                .id(1L)
                .vehicleNumber("SG-CAR-001")
                .brand("Audi")
                .model("R8 V10")
                .type(VehicleType.CAR)
                .color("Matte Black")
                .year(2023)
                .ownerName("Tony Stark")
                .status(VehicleStatus.ACTIVE)
                .registrationDate(LocalDate.of(2023, 1, 15))
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        sampleRequest = VehicleRequest.builder()
                .vehicleNumber("SG-CAR-001")
                .brand("Audi")
                .model("R8 V10")
                .type(VehicleType.CAR)
                .color("Matte Black")
                .year(2023)
                .ownerName("Tony Stark")
                .status(VehicleStatus.ACTIVE)
                .registrationDate(LocalDate.of(2023, 1, 15))
                .build();
    }

    @Test
    @DisplayName("createVehicle should succeed when vehicle number is unique")
    void createVehicle_Success() {
        when(vehicleRepository.existsByVehicleNumberIgnoreCase("SG-CAR-001")).thenReturn(false);
        when(vehicleRepository.save(any(Vehicle.class))).thenReturn(sampleVehicle);

        VehicleResponse response = vehicleService.createVehicle(sampleRequest);

        assertThat(response).isNotNull();
        assertThat(response.getVehicleNumber()).isEqualTo("SG-CAR-001");
        assertThat(response.getBrand()).isEqualTo("Audi");
        verify(vehicleRepository).save(any(Vehicle.class));
    }

    @Test
    @DisplayName("createVehicle should throw DuplicateVehicleNumberException when vehicle number exists")
    void createVehicle_ThrowsDuplicateException() {
        when(vehicleRepository.existsByVehicleNumberIgnoreCase("SG-CAR-001")).thenReturn(true);

        assertThatThrownBy(() -> vehicleService.createVehicle(sampleRequest))
                .isInstanceOf(DuplicateVehicleNumberException.class)
                .hasMessageContaining("SG-CAR-001");

        verify(vehicleRepository, never()).save(any(Vehicle.class));
    }

    @Test
    @DisplayName("getAllVehicles should return list of vehicle responses")
    void getAllVehicles_Success() {
        when(vehicleRepository.findAllByOrderByIdDesc()).thenReturn(List.of(sampleVehicle));

        List<VehicleResponse> list = vehicleService.getAllVehicles();

        assertThat(list).hasSize(1);
        assertThat(list.get(0).getVehicleNumber()).isEqualTo("SG-CAR-001");
    }

    @Test
    @DisplayName("getVehicleById should return vehicle response when found")
    void getVehicleById_Success() {
        when(vehicleRepository.findById(1L)).thenReturn(Optional.of(sampleVehicle));

        VehicleResponse response = vehicleService.getVehicleById(1L);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("getVehicleById should throw ResourceNotFoundException when not found")
    void getVehicleById_ThrowsNotFoundException() {
        when(vehicleRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> vehicleService.getVehicleById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("updateVehicle should succeed when vehicle number is not taken by another vehicle")
    void updateVehicle_Success() {
        when(vehicleRepository.findById(1L)).thenReturn(Optional.of(sampleVehicle));
        when(vehicleRepository.existsByVehicleNumberIgnoreCaseAndIdNot("SG-CAR-001", 1L)).thenReturn(false);
        when(vehicleRepository.save(any(Vehicle.class))).thenReturn(sampleVehicle);

        VehicleResponse response = vehicleService.updateVehicle(1L, sampleRequest);

        assertThat(response).isNotNull();
        verify(vehicleRepository).save(sampleVehicle);
    }

    @Test
    @DisplayName("updateVehicle should throw DuplicateVehicleNumberException when number is used by another vehicle")
    void updateVehicle_ThrowsDuplicateException() {
        when(vehicleRepository.findById(1L)).thenReturn(Optional.of(sampleVehicle));
        when(vehicleRepository.existsByVehicleNumberIgnoreCaseAndIdNot("SG-CAR-001", 1L)).thenReturn(true);

        assertThatThrownBy(() -> vehicleService.updateVehicle(1L, sampleRequest))
                .isInstanceOf(DuplicateVehicleNumberException.class)
                .hasMessageContaining("already exists for another vehicle");

        verify(vehicleRepository, never()).save(any(Vehicle.class));
    }

    @Test
    @DisplayName("deleteVehicle should delete successfully when vehicle exists")
    void deleteVehicle_Success() {
        when(vehicleRepository.existsById(1L)).thenReturn(true);

        vehicleService.deleteVehicle(1L);

        verify(vehicleRepository).deleteById(1L);
    }

    @Test
    @DisplayName("deleteVehicle should throw ResourceNotFoundException when vehicle does not exist")
    void deleteVehicle_ThrowsNotFoundException() {
        when(vehicleRepository.existsById(99L)).thenReturn(false);

        assertThatThrownBy(() -> vehicleService.deleteVehicle(99L))
                .isInstanceOf(ResourceNotFoundException.class);

        verify(vehicleRepository, never()).deleteById(any());
    }

    @Test
    @DisplayName("searchVehicles with query should return matching vehicles")
    void searchVehicles_WithQuery_ReturnsResults() {
        when(vehicleRepository.searchVehicles("Audi")).thenReturn(List.of(sampleVehicle));

        List<VehicleResponse> results = vehicleService.searchVehicles("Audi");

        assertThat(results).hasSize(1);
        assertThat(results.get(0).getBrand()).isEqualTo("Audi");
    }

    @Test
    @DisplayName("searchVehicles with blank query should delegate to getAllVehicles")
    void searchVehicles_WithBlankQuery_ReturnsAll() {
        when(vehicleRepository.findAllByOrderByIdDesc()).thenReturn(List.of(sampleVehicle));

        List<VehicleResponse> results = vehicleService.searchVehicles("   ");

        assertThat(results).hasSize(1);
        verify(vehicleRepository).findAllByOrderByIdDesc();
        verify(vehicleRepository, never()).searchVehicles(anyString());
    }
}
