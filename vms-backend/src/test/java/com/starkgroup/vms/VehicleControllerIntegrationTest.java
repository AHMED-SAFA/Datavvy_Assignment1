package com.starkgroup.vms;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.starkgroup.vms.dto.request.LoginRequest;
import com.starkgroup.vms.dto.request.VehicleRequest;
import com.starkgroup.vms.enums.VehicleStatus;
import com.starkgroup.vms.enums.VehicleType;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.time.LocalDate;

import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class VehicleControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    private String jwtToken;

    @BeforeEach
    void obtainAuthToken() throws Exception {
        LoginRequest loginRequest = new LoginRequest("admin", "admin123");
        MvcResult result = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andReturn();

        String responseStr = result.getResponse().getContentAsString();
        JsonNode root = objectMapper.readTree(responseStr);
        jwtToken = "Bearer " + root.path("data").path("token").asText();
    }

    @Test
    @DisplayName("GET /api/vehicles without token should return 401 Unauthorized")
    void getAllVehicles_WithoutToken_ReturnsUnauthorized() throws Exception {
        mockMvc.perform(get("/api/vehicles"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.success", is(false)));
    }

    @Test
    @DisplayName("GET /api/vehicles with token should return seeded vehicles")
    void getAllVehicles_WithToken_Success() throws Exception {
        mockMvc.perform(get("/api/vehicles")
                        .header("Authorization", jwtToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success", is(true)))
                .andExpect(jsonPath("$.data", hasSize(greaterThanOrEqualTo(1))));
    }

    @Test
    @DisplayName("POST /api/vehicles should create a new vehicle")
    void createVehicle_Success() throws Exception {
        VehicleRequest request = VehicleRequest.builder()
                .vehicleNumber("SG-TEST-999")
                .brand("Chevrolet")
                .model("Corvette")
                .type(VehicleType.CAR)
                .color("Torch Red")
                .year(2023)
                .ownerName("James Rhodes")
                .status(VehicleStatus.ACTIVE)
                .registrationDate(LocalDate.of(2023, 6, 20))
                .build();

        mockMvc.perform(post("/api/vehicles")
                        .header("Authorization", jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success", is(true)))
                .andExpect(jsonPath("$.data.vehicleNumber", is("SG-TEST-999")))
                .andExpect(jsonPath("$.data.id", notNullValue()));
    }

    @Test
    @DisplayName("POST /api/vehicles with duplicate vehicle number should return 409 Conflict")
    void createVehicle_DuplicateVehicleNumber_ReturnsConflict() throws Exception {
        VehicleRequest request = VehicleRequest.builder()
                .vehicleNumber("SG-CAR-001") // seeded in data.sql
                .brand("Audi")
                .model("R8")
                .type(VehicleType.CAR)
                .color("Black")
                .year(2023)
                .ownerName("Duplicate Owner")
                .status(VehicleStatus.ACTIVE)
                .registrationDate(LocalDate.now())
                .build();

        mockMvc.perform(post("/api/vehicles")
                        .header("Authorization", jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success", is(false)))
                .andExpect(jsonPath("$.message", notNullValue()));
    }

    @Test
    @DisplayName("GET /api/vehicles/search should filter vehicles by query")
    void searchVehicles_Success() throws Exception {
        mockMvc.perform(get("/api/vehicles/search")
                        .header("Authorization", jwtToken)
                        .param("query", "Tesla"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success", is(true)));
    }

    @Test
    @DisplayName("PUT /api/vehicles/{id} should update existing vehicle")
    void updateVehicle_Success() throws Exception {
        // First create a unique vehicle to update
        VehicleRequest createReq = VehicleRequest.builder()
                .vehicleNumber("SG-UPD-001")
                .brand("BMW")
                .model("M3")
                .type(VehicleType.CAR)
                .color("Alpine White")
                .year(2022)
                .ownerName("Tony Stark")
                .status(VehicleStatus.ACTIVE)
                .registrationDate(LocalDate.of(2022, 1, 1))
                .build();

        MvcResult createResult = mockMvc.perform(post("/api/vehicles")
                        .header("Authorization", jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(createReq)))
                .andExpect(status().isCreated())
                .andReturn();

        JsonNode root = objectMapper.readTree(createResult.getResponse().getContentAsString());
        long createdId = root.path("data").path("id").asLong();

        // Update the vehicle
        VehicleRequest updateReq = VehicleRequest.builder()
                .vehicleNumber("SG-UPD-001")
                .brand("BMW")
                .model("M3 Competition")
                .type(VehicleType.CAR)
                .color("Isle of Man Green")
                .year(2023)
                .ownerName("Tony Stark")
                .status(VehicleStatus.ACTIVE)
                .registrationDate(LocalDate.of(2023, 2, 2))
                .build();

        mockMvc.perform(put("/api/vehicles/" + createdId)
                        .header("Authorization", jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updateReq)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success", is(true)))
                .andExpect(jsonPath("$.data.model", is("M3 Competition")))
                .andExpect(jsonPath("$.data.color", is("Isle of Man Green")));
    }

    @Test
    @DisplayName("DELETE /api/vehicles/{id} should return 204 No Content")
    void deleteVehicle_Success() throws Exception {
        // First create a temporary vehicle to delete
        VehicleRequest createReq = VehicleRequest.builder()
                .vehicleNumber("SG-DEL-001")
                .brand("Ford")
                .model("Mustang")
                .type(VehicleType.CAR)
                .color("Race Red")
                .year(2021)
                .ownerName("Happy Hogan")
                .status(VehicleStatus.ACTIVE)
                .registrationDate(LocalDate.of(2021, 5, 5))
                .build();

        MvcResult createResult = mockMvc.perform(post("/api/vehicles")
                        .header("Authorization", jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(createReq)))
                .andExpect(status().isCreated())
                .andReturn();

        JsonNode root = objectMapper.readTree(createResult.getResponse().getContentAsString());
        long createdId = root.path("data").path("id").asLong();

        // Delete it
        mockMvc.perform(delete("/api/vehicles/" + createdId)
                        .header("Authorization", jwtToken))
                .andExpect(status().isNoContent());

        // Verify it is gone
        mockMvc.perform(get("/api/vehicles/" + createdId)
                        .header("Authorization", jwtToken))
                .andExpect(status().isNotFound());
    }
}
