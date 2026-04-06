package com.javaquest.challenge;

import com.javaquest.gamification.GamificationService;
import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

/**
 * Service gerant les defis quotidiens.
 */
@Service
public class ChallengeService {

    private static final Logger log = LoggerFactory.getLogger(ChallengeService.class);

    private final DailyChallengeRepository challengeRepository;
    private final UserDailyChallengeRepository userChallengeRepository;
    private final UserRepository userRepository;
    private final GamificationService gamificationService;

    public ChallengeService(DailyChallengeRepository challengeRepository,
                            UserDailyChallengeRepository userChallengeRepository,
                            UserRepository userRepository,
                            GamificationService gamificationService) {
        this.challengeRepository = challengeRepository;
        this.userChallengeRepository = userChallengeRepository;
        this.userRepository = userRepository;
        this.gamificationService = gamificationService;
    }

    /**
     * Recupere le defi du jour.
     */
    public DailyChallenge getTodayChallenge() {
        return challengeRepository.findByDate(LocalDate.now())
            .orElseThrow(() -> new ChallengeException("Pas de defi disponible aujourd'hui"));
    }

    /**
     * Recupere un defi par son ID.
     */
    public DailyChallenge getChallengeById(Long id) {
        return challengeRepository.findById(id)
            .orElseThrow(() -> new ChallengeException("Defi non trouve"));
    }

    /**
     * Recupere les defis des derniers jours.
     */
    public List<DailyChallenge> getRecentChallenges(int days) {
        LocalDate end = LocalDate.now();
        LocalDate start = end.minusDays(days);
        return challengeRepository.findByDateBetweenOrderByDateDesc(start, end);
    }

    /**
     * Cree un nouveau defi quotidien.
     */
    @Transactional
    public DailyChallenge createChallenge(LocalDate date, String title, String description,
                                          String starterCode, String solutionCode, String testCode,
                                          String hints, Integer xpReward, Integer bonusXp) {
        if (challengeRepository.existsByDate(date)) {
            throw new ChallengeException("Un defi existe deja pour cette date");
        }

        DailyChallenge challenge = new DailyChallenge(date, title, description, solutionCode, testCode);
        challenge.setStarterCode(starterCode);
        challenge.setHints(hints);
        challenge.setXpReward(xpReward != null ? xpReward : 100);
        challenge.setBonusXp(bonusXp != null ? bonusXp : 50);

        return challengeRepository.save(challenge);
    }

    /**
     * Demarre un defi pour un utilisateur.
     */
    @Transactional
    public UserDailyChallenge startChallenge(Long userId, Long challengeId) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new ChallengeException("Utilisateur non trouve"));

        DailyChallenge challenge = getChallengeById(challengeId);

        Optional<UserDailyChallenge> existing = userChallengeRepository
            .findByUserIdAndChallengeId(userId, challengeId);

        if (existing.isPresent()) {
            return existing.get();
        }

        UserDailyChallenge userChallenge = new UserDailyChallenge(user, challenge);
        return userChallengeRepository.save(userChallenge);
    }

    /**
     * Soumet une tentative de defi.
     */
    @Transactional
    public ChallengeResult submitChallenge(Long userId, Long challengeId, String code, boolean success) {
        UserDailyChallenge userChallenge = userChallengeRepository
            .findByUserIdAndChallengeId(userId, challengeId)
            .orElseThrow(() -> new ChallengeException("Participation non trouvee"));

        if (userChallenge.getStatus() == ChallengeStatus.COMPLETED) {
            return new ChallengeResult(true, 0, false, "Defi deja complete");
        }

        userChallenge.incrementAttempts();
        userChallenge.setSubmittedCode(code);

        if (success) {
            DailyChallenge challenge = userChallenge.getChallenge();
            int xpEarned = calculateXp(challenge, userChallenge);

            userChallenge.markCompleted(xpEarned);
            userChallengeRepository.save(userChallenge);

            gamificationService.addXp(userId, xpEarned, "Defi quotidien: " + challenge.getTitle());

            return new ChallengeResult(true, xpEarned, true, "Bravo! Defi reussi!");
        }

        userChallengeRepository.save(userChallenge);
        return new ChallengeResult(false, 0, false, "Essaie encore!");
    }

    /**
     * Calcule l'XP gagne selon le nombre de tentatives.
     */
    private int calculateXp(DailyChallenge challenge, UserDailyChallenge userChallenge) {
        int baseXp = challenge.getXpReward();
        int bonusXp = challenge.getBonusXp();

        // Bonus si reussi du premier coup
        if (userChallenge.getAttemptsCount() <= 1) {
            return baseXp + bonusXp;
        }
        // Bonus reduit si moins de 3 tentatives
        if (userChallenge.getAttemptsCount() <= 3) {
            return baseXp + (bonusXp / 2);
        }
        return baseXp;
    }

    /**
     * Recupere la participation d'un utilisateur a un defi.
     */
    public UserDailyChallenge getUserChallenge(Long userId, Long challengeId) {
        return userChallengeRepository.findByUserIdAndChallengeId(userId, challengeId)
            .orElse(null);
    }

    /**
     * Recupere l'historique des defis d'un utilisateur.
     */
    public List<UserDailyChallenge> getUserChallengeHistory(Long userId) {
        return userChallengeRepository.findByUserIdOrderByStartedAtDesc(userId);
    }

    /**
     * Compte les defis completes par un utilisateur.
     */
    public long countCompletedChallenges(Long userId) {
        return userChallengeRepository.countByUserIdAndStatus(userId, ChallengeStatus.COMPLETED);
    }

    /**
     * Genere automatiquement le defi du lendemain chaque jour a 23h.
     */
    @Scheduled(cron = "0 0 23 * * *")
    @Transactional
    public void scheduleTomorrowChallenge() {
        LocalDate tomorrow = LocalDate.now().plusDays(1);
        if (!challengeRepository.existsByDate(tomorrow)) {
            log.info("Generation automatique du defi pour {}", tomorrow);
            generateDefaultChallenge(tomorrow);
        }
    }

    /**
     * Genere un defi par defaut pour une date donnee.
     */
    @Transactional
    public void generateDefaultChallenge(LocalDate date) {
        if (challengeRepository.existsByDate(date)) {
            return;
        }
        String label = date.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        try {
            createChallenge(
                date,
                "Defi du " + label,
                "Ecrivez un programme Java qui affiche les nombres de 1 a 10.",
                "public class Main {\n    public static void main(String[] args) {\n        // Affichez les nombres de 1 a 10\n        \n    }\n}",
                "public class Main {\n    public static void main(String[] args) {\n        for (int i = 1; i <= 10; i++) {\n            System.out.println(i);\n        }\n    }\n}",
                "output.contains(\"10\")",
                "Utilisez une boucle for de 1 a 10.",
                100, 50
            );
            log.info("Defi genere automatiquement pour {}", date);
        } catch (Exception e) {
            log.warn("Impossible de generer le defi pour {}: {}", date, e.getMessage());
        }
    }
}
