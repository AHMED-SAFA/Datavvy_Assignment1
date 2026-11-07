package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.request.LoginRequest;
import com.starkgroup.vms.dto.response.LoginResponse;
import com.starkgroup.vms.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider tokenProvider;

    @Override
    public LoginResponse login(LoginRequest request) {
        log.info("Attempting login for user: {}", request.getUsername());

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername().trim(),
                        request.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = tokenProvider.generateToken(authentication.getName());

        log.info("User '{}' successfully authenticated", authentication.getName());

        return LoginResponse.builder()
                .token(jwt)
                .tokenType("Bearer")
                .username(authentication.getName())
                .expiresIn(tokenProvider.getJwtExpirationMs())
                .build();
    }
}
