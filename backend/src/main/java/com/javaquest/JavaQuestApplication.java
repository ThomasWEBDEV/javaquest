package com.javaquest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Point d'entree principal de l'application JavaQuest.
 * Plateforme d'apprentissage Java interactive.
 */
@SpringBootApplication
@EnableScheduling
public class JavaQuestApplication {

    public static void main(String[] args) {
        SpringApplication.run(JavaQuestApplication.class, args);
    }
}
