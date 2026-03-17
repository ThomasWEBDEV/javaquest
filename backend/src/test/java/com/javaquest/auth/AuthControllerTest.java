package com.javaquest.auth;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests d'intégration pour AuthController.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
    }

    // Tests Register

    @Test
    void register_success() throws Exception {
        RegisterRequest request = new RegisterRequest("newuser", "new@test.com", "password123");

        mockMvc.perform(post("/api/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.token").exists())
            .andExpect(jsonPath("$.username").value("newuser"))
            .andExpect(jsonPath("$.email").value("new@test.com"));
    }

    @Test
    void register_duplicateUsername_returnsUnauthorized() throws Exception {
        // Given - utilisateur existant
        User existing = new User("existinguser", "existing@test.com", passwordEncoder.encode("password"));
        userRepository.save(existing);

        RegisterRequest request = new RegisterRequest("existinguser", "new@test.com", "password123");

        // When & Then
        mockMvc.perform(post("/api/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.error").value("Ce nom d'utilisateur est déjà pris"));
    }

    @Test
    void register_duplicateEmail_returnsUnauthorized() throws Exception {
        // Given - utilisateur existant
        User existing = new User("existinguser", "existing@test.com", passwordEncoder.encode("password"));
        userRepository.save(existing);

        RegisterRequest request = new RegisterRequest("newuser", "existing@test.com", "password123");

        // When & Then
        mockMvc.perform(post("/api/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.error").value("Cet email est déjà utilisé"));
    }

    @Test
    void register_invalidEmail_returnsBadRequest() throws Exception {
        RegisterRequest request = new RegisterRequest("newuser", "invalid-email", "password123");

        mockMvc.perform(post("/api/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isBadRequest());
    }

    @Test
    void register_shortPassword_returnsBadRequest() throws Exception {
        RegisterRequest request = new RegisterRequest("newuser", "new@test.com", "short");

        mockMvc.perform(post("/api/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isBadRequest());
    }

    // Tests Login

    @Test
    void login_success() throws Exception {
        // Given - créer un utilisateur
        User user = new User("testuser", "test@test.com", passwordEncoder.encode("password123"));
        userRepository.save(user);

        LoginRequest request = new LoginRequest("testuser", "password123");

        // When & Then
        mockMvc.perform(post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.token").exists())
            .andExpect(jsonPath("$.username").value("testuser"));
    }

    @Test
    void login_wrongPassword_returnsUnauthorized() throws Exception {
        // Given
        User user = new User("testuser", "test@test.com", passwordEncoder.encode("password123"));
        userRepository.save(user);

        LoginRequest request = new LoginRequest("testuser", "wrongpassword");

        // When & Then
        mockMvc.perform(post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.error").value("Identifiants invalides"));
    }

    @Test
    void login_userNotFound_returnsUnauthorized() throws Exception {
        LoginRequest request = new LoginRequest("nonexistent", "password123");

        mockMvc.perform(post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isUnauthorized())
            .andExpect(jsonPath("$.error").value("Identifiants invalides"));
    }
}
