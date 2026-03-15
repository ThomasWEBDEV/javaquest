package com.javaquest.auth;

import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * Service gérant l'authentification des utilisateurs.
 * Inscription, connexion et validation des credentials.
 */
@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(UserRepository userRepository, 
                       PasswordEncoder passwordEncoder,
                       JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    /**
     * Inscrit un nouvel utilisateur.
     * 
     * @param request Les informations d'inscription
     * @return La réponse contenant le token JWT
     * @throws AuthException si le username ou email existe déjà
     */
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        // Vérifie si le username existe déjà
        if (userRepository.existsByUsername(request.username())) {
            throw new AuthException("Ce nom d'utilisateur est déjà pris");
        }

        // Vérifie si l'email existe déjà
        if (userRepository.existsByEmail(request.email())) {
            throw new AuthException("Cet email est déjà utilisé");
        }

        // Crée le nouvel utilisateur
        User user = new User(
            request.username(),
            request.email(),
            passwordEncoder.encode(request.password())
        );

        userRepository.save(user);

        // Génère le token JWT
        String token = jwtService.generateToken(user.getUsername());

        return AuthResponse.success(token, user.getUsername(), user.getEmail());
    }

    /**
     * Connecte un utilisateur existant.
     * 
     * @param request Les informations de connexion
     * @return La réponse contenant le token JWT
     * @throws AuthException si les credentials sont invalides
     */
    @Transactional
    public AuthResponse login(LoginRequest request) {
        // Recherche l'utilisateur par username
        User user = userRepository.findByUsername(request.username())
            .orElseThrow(() -> new AuthException("Identifiants invalides"));

        // Vérifie le mot de passe
        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new AuthException("Identifiants invalides");
        }

        // Vérifie si le compte est actif
        if (!user.getIsActive()) {
            throw new AuthException("Ce compte est désactivé");
        }

        // Met à jour la date de dernière connexion
        user.setLastLoginAt(LocalDateTime.now());
        userRepository.save(user);

        // Génère le token JWT
        String token = jwtService.generateToken(user.getUsername());

        return AuthResponse.success(token, user.getUsername(), user.getEmail());
    }
}
