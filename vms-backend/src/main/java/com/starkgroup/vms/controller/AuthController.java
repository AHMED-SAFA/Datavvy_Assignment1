package com.starkgroup.vms.controller;

import com.starkgroup.vms.dto.request.LoginRequest;
import com.starkgroup.vms.dto.response.ApiResponse;
import com.starkgroup.vms.dto.response.LoginResponse;
import com.starkgroup.vms.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponse>> login(@Valid @RequestBody LoginRequest request) {
        log.info("Received login request for username: {}", request.getUsername());
        LoginResponse loginResponse = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("Authentication successful", loginResponse));
    }
}
