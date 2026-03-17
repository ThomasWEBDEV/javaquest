package com.javaquest.auth;

import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

/**
 * Tests unitaires pour AuthService.
 */
@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @InjectMocks
    private AuthService authService;

    private RegisterRequest registerRequest;
    private LoginRequest loginRequest;
    private User existingUser;

    @BeforeEach
    void setUp() {
        registerRequest = new RegisterRequest("newuser", "new@test.com", "password123");
        loginRequest = new LoginRequest("testuser", "password123");
        
        existingUser = new User("testuser", "test@test.com", "hashedPassword");
        existingUser.setId(1L);
        existingUser.setIsActive(true);
    }

    // Tests Register

    @Test
    void register_success() {
        // Given
        when(userRepository.existsByUsername(anyString())).thenReturn(false);
        when(userRepository.existsByEmail(anyString())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("hashedPassword");
        when(userRepository.save(any(User.class))).thenAnswer(i -> i.getArgument(0));
        when(jwtService.generateToken(anyString())).thenReturn("jwt-token");

        // When
        AuthResponse response = authService.register(registerRequest);

        // Then
        assertNotNull(response);
        assertEquals("jwt-token", response.token());
        assertEquals("newuser", response.username());
        assertEquals("new@test.com", response.email());
        verify(userRepository).save(any(User.class));
    }

    @Test
    void register_usernameExists_throwsException() {
        // Given
        when(userRepository.existsByUsername("newuser")).thenReturn(true);

        // When & Then
        AuthException exception = assertThrows(AuthException.class, () -> {
            authService.register(registerRequest);
        });
        assertEquals("Ce nom d'utilisateur est déjà pris", exception.getMessage());
        verify(userRepository, never()).save(any());
    }

    @Test
    void register_emailExists_throwsException() {
        // Given
        when(userRepository.existsByUsername(anyString())).thenReturn(false);
        when(userRepository.existsByEmail("new@test.com")).thenReturn(true);

        // When & Then
        AuthException exception = assertThrows(AuthException.class, () -> {
            authService.register(registerRequest);
        });
        assertEquals("Cet email est déjà utilisé", exception.getMessage());
        verify(userRepository, never()).save(any());
    }

    // Tests Login

    @Test
    void login_success() {
        // Given
        when(userRepository.findByUsername("testuser")).thenReturn(Optional.of(existingUser));
        when(passwordEncoder.matches("password123", "hashedPassword")).thenReturn(true);
        when(jwtService.generateToken("testuser")).thenReturn("jwt-token");
        when(userRepository.save(any(User.class))).thenReturn(existingUser);

        // When
        AuthResponse response = authService.login(loginRequest);

        // Then
        assertNotNull(response);
        assertEquals("jwt-token", response.token());
        assertEquals("testuser", response.username());
        verify(userRepository).save(any(User.class)); // Mise à jour lastLoginAt
    }

    @Test
    void login_userNotFound_throwsException() {
        // Given
        when(userRepository.findByUsername("testuser")).thenReturn(Optional.empty());

        // When & Then
        AuthException exception = assertThrows(AuthException.class, () -> {
            authService.login(loginRequest);
        });
        assertEquals("Identifiants invalides", exception.getMessage());
    }

    @Test
    void login_wrongPassword_throwsException() {
        // Given
        when(userRepository.findByUsername("testuser")).thenReturn(Optional.of(existingUser));
        when(passwordEncoder.matches("password123", "hashedPassword")).thenReturn(false);

        // When & Then
        AuthException exception = assertThrows(AuthException.class, () -> {
            authService.login(loginRequest);
        });
        assertEquals("Identifiants invalides", exception.getMessage());
    }

    @Test
    void login_inactiveAccount_throwsException() {
        // Given
        existingUser.setIsActive(false);
        when(userRepository.findByUsername("testuser")).thenReturn(Optional.of(existingUser));
        when(passwordEncoder.matches("password123", "hashedPassword")).thenReturn(true);

        // When & Then
        AuthException exception = assertThrows(AuthException.class, () -> {
            authService.login(loginRequest);
        });
        assertEquals("Ce compte est désactivé", exception.getMessage());
    }
}
