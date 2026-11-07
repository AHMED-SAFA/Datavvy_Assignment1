package com.starkgroup.vms.service;

import com.starkgroup.vms.dto.request.LoginRequest;
import com.starkgroup.vms.dto.response.LoginResponse;

public interface AuthService {

    LoginResponse login(LoginRequest request);
}
