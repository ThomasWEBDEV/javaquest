package com.javaquest.gamification;

import com.javaquest.user.User;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entite representant la progression d'un utilisateur.
 * Stocke XP, niveau, streaks.
 */
@Entity
@Table(name = "user_progress")
public class UserProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "total_xp", nullable = false)
    private Integer totalXp = 0;

    @Column(name = "current_level", nullable = false)
    private Integer currentLevel = 1;

    @Column(name = "current_streak", nullable = false)
    private Integer currentStreak = 0;

    @Column(name = "longest_streak", nullable = false)
    private Integer longestStreak = 0;

    @Column(name = "last_activity_date")
    private LocalDate lastActivityDate;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // Constructeur par defaut
    public UserProgress() {
    }

    // Constructeur avec user
    public UserProgress(User user) {
        this.user = user;
    }

    // Callbacks JPA
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Ajoute de l'XP et recalcule le niveau.
     */
    public void addXp(int xp) {
        this.totalXp += xp;
        this.currentLevel = calculateLevel(this.totalXp);
    }

    /**
     * Calcule le niveau en fonction de l'XP total.
     * Formule : niveau = 1 + (totalXp / 1000)
     */
    private int calculateLevel(int totalXp) {
        return 1 + (totalXp / 1000);
    }

    /**
     * Met a jour le streak.
     */
    public void updateStreak() {
        LocalDate today = LocalDate.now();

        if (lastActivityDate == null) {
            this.currentStreak = 1;
        } else if (lastActivityDate.equals(today.minusDays(1))) {
            this.currentStreak++;
        } else if (!lastActivityDate.equals(today)) {
            this.currentStreak = 1;
        }

        if (this.currentStreak > this.longestStreak) {
            this.longestStreak = this.currentStreak;
        }

        this.lastActivityDate = today;
    }

    /**
     * Retourne l'XP necessaire pour le prochain niveau.
     */
    public int getXpForNextLevel() {
        return (currentLevel * 1000) - totalXp;
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

    public Integer getTotalXp() {
        return totalXp;
    }

    public void setTotalXp(Integer totalXp) {
        this.totalXp = totalXp;
    }

    public Integer getCurrentLevel() {
        return currentLevel;
    }

    public void setCurrentLevel(Integer currentLevel) {
        this.currentLevel = currentLevel;
    }

    public Integer getCurrentStreak() {
        return currentStreak;
    }

    public void setCurrentStreak(Integer currentStreak) {
        this.currentStreak = currentStreak;
    }

    public Integer getLongestStreak() {
        return longestStreak;
    }

    public void setLongestStreak(Integer longestStreak) {
        this.longestStreak = longestStreak;
    }

    public LocalDate getLastActivityDate() {
        return lastActivityDate;
    }

    public void setLastActivityDate(LocalDate lastActivityDate) {
        this.lastActivityDate = lastActivityDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
}
