package com.javaquest.user;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repository pour acces aux donnees utilisateur.
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Recherche un utilisateur par son nom d'utilisateur.
     */
    Optional<User> findByUsername(String username);

    /**
     * Recherche un utilisateur par son email.
     */
    Optional<User> findByEmail(String email);

    /**
     * Verifie si un nom d'utilisateur existe deja.
     */
    boolean existsByUsername(String username);

    /**
     * Verifie si un email existe deja.
     */
    boolean existsByEmail(String email);
}
