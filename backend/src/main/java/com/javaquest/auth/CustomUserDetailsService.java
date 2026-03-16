package com.javaquest.auth;

import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

/**
 * Service de chargement des utilisateurs pour Spring Security.
 * Fait le lien entre notre entité User et le système d'authentification Spring.
 */
@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Charge un utilisateur par son nom d'utilisateur.
     * Méthode requise par Spring Security.
     *
     * @param username Le nom d'utilisateur à rechercher
     * @return Les détails de l'utilisateur pour Spring Security
     * @throws UsernameNotFoundException si l'utilisateur n'existe pas
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException(
                "Utilisateur non trouvé: " + username
            ));

        return new org.springframework.security.core.userdetails.User(
            user.getUsername(),
            user.getPasswordHash(),
            user.getIsActive(),      // enabled
            true,                     // accountNonExpired
            true,                     // credentialsNonExpired
            true,                     // accountNonLocked
            Collections.emptyList()   // authorities (pas de rôles pour l'instant)
        );
    }
}
