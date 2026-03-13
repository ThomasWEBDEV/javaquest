package com.javaquest;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

/**
 * Test de chargement du contexte Spring.
 */
@SpringBootTest
@ActiveProfiles("test")
class JavaQuestApplicationTests {

    @Test
    void contextLoads() {
        // Verifie que le contexte Spring demarre correctement
    }
}
