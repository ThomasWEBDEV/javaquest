package com.javaquest.auth;

import io.jsonwebtoken.ExpiredJwtException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests unitaires pour JwtService.
 */
class JwtServiceTest {

    private JwtService jwtService;

    @BeforeEach
    void setUp() {
        jwtService = new JwtService();
        // Injecte les valeurs de configuration pour les tests
        ReflectionTestUtils.setField(jwtService, "secret", 
            "test-secret-key-minimum-256-bits-for-hmac-sha256-security");
        ReflectionTestUtils.setField(jwtService, "expiration", 86400000L);
    }

    @Test
    void generateToken_returnsValidToken() {
        // When
        String token = jwtService.generateToken("testuser");

        // Then
        assertNotNull(token);
        assertFalse(token.isEmpty());
        assertTrue(token.contains("."));  // Format JWT: header.payload.signature
    }

    @Test
    void extractUsername_returnsCorrectUsername() {
        // Given
        String username = "testuser";
        String token = jwtService.generateToken(username);

        // When
        String extractedUsername = jwtService.extractUsername(token);

        // Then
        assertEquals(username, extractedUsername);
    }

    @Test
    void isTokenValid_returnsTrueForValidToken() {
        // Given
        String username = "testuser";
        String token = jwtService.generateToken(username);

        // When
        boolean isValid = jwtService.isTokenValid(token, username);

        // Then
        assertTrue(isValid);
    }

    @Test
    void isTokenValid_returnsFalseForWrongUsername() {
        // Given
        String token = jwtService.generateToken("testuser");

        // When
        boolean isValid = jwtService.isTokenValid(token, "wronguser");

        // Then
        assertFalse(isValid);
    }

    @Test
    void expiredToken_throwsExpiredJwtException() {
        // Given - token avec expiration de 1ms
        JwtService shortLivedJwtService = new JwtService();
        ReflectionTestUtils.setField(shortLivedJwtService, "secret",
            "test-secret-key-minimum-256-bits-for-hmac-sha256-security");
        ReflectionTestUtils.setField(shortLivedJwtService, "expiration", 1L);

        String token = shortLivedJwtService.generateToken("testuser");

        // Attend que le token expire
        try {
            Thread.sleep(10);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Then - le token expiré lance une exception
        assertThrows(ExpiredJwtException.class, () -> {
            shortLivedJwtService.extractUsername(token);
        });
    }
}
