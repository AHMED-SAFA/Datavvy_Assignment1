package com.starkgroup.vms.repository;

import com.starkgroup.vms.entity.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VehicleRepository extends JpaRepository<Vehicle, Long> {

    boolean existsByVehicleNumberIgnoreCase(String vehicleNumber);

    boolean existsByVehicleNumberIgnoreCaseAndIdNot(String vehicleNumber, Long id);

    Optional<Vehicle> findByVehicleNumberIgnoreCase(String vehicleNumber);

    List<Vehicle> findAllByOrderByIdDesc();

    @Query("SELECT v FROM Vehicle v WHERE " +
            "LOWER(v.vehicleNumber) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(v.brand) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(v.model) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(v.ownerName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(v.color) LIKE LOWER(CONCAT('%', :query, '%')) " +
            "ORDER BY v.id DESC")
    List<Vehicle> searchVehicles(@Param("query") String query);
}
