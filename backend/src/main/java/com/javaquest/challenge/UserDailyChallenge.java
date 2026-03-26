package com.javaquest.challenge;

import com.javaquest.user.User;
import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entite representant la participation d'un utilisateur a un defi quotidien.
 */
@Entity
@Table(name = "user_daily_challenges", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "challenge_id"})
})
public class UserDailyChallenge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "challenge_id", nullable = false)
    private DailyChallenge challenge;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ChallengeStatus status = ChallengeStatus.STARTED;

    @Column(name = "submitted_code", columnDefinition = "TEXT")
    private String submittedCode;

    @Column(name = "attempts_count", nullable = false)
    private Integer attemptsCount = 0;

    @Column(name = "xp_earned", nullable = false)
    private Integer xpEarned = 0;

    @Column(name = "time_spent_seconds")
    private Integer timeSpentSeconds;

    @Column(name = "started_at", nullable = false)
    private LocalDateTime startedAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    // Constructeur par defaut
    public UserDailyChallenge() {
    }

    // Constructeur avec parametres
    public UserDailyChallenge(User user, DailyChallenge challenge) {
        this.user = user;
        this.challenge = challenge;
        this.startedAt = LocalDateTime.now();
    }

    /**
     * Marque le defi comme complete.
     */
    public void markCompleted(int xpEarned) {
        this.status = ChallengeStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();
        this.xpEarned = xpEarned;
    }

    /**
     * Marque le defi comme echoue.
     */
    public void markFailed() {
        this.status = ChallengeStatus.FAILED;
    }

    /**
     * Incremente le compteur de tentatives.
     */
    public void incrementAttempts() {
        this.attemptsCount++;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public DailyChallenge getChallenge() {
        return challenge;
    }

    public void setChallenge(DailyChallenge challenge) {
        this.challenge = challenge;
    }

    public ChallengeStatus getStatus() {
        return status;
    }

    public void setStatus(ChallengeStatus status) {
        this.status = status;
    }

    public String getSubmittedCode() {
        return submittedCode;
    }

    public void setSubmittedCode(String submittedCode) {
        this.submittedCode = submittedCode;
    }

    public Integer getAttemptsCount() {
        return attemptsCount;
    }

    public void setAttemptsCount(Integer attemptsCount) {
        this.attemptsCount = attemptsCount;
    }

    public Integer getXpEarned() {
        return xpEarned;
    }

    public void setXpEarned(Integer xpEarned) {
        this.xpEarned = xpEarned;
    }

    public Integer getTimeSpentSeconds() {
        return timeSpentSeconds;
    }

    public void setTimeSpentSeconds(Integer timeSpentSeconds) {
        this.timeSpentSeconds = timeSpentSeconds;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }
}
