package com.javaquest.dashboard;

import com.javaquest.exercise.Exercise;
import com.javaquest.user.User;
import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entite representant la progression d'un utilisateur sur un exercice.
 */
@Entity
@Table(name = "user_exercise_progress", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "exercise_id"})
})
public class UserExerciseProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercise_id", nullable = false)
    private Exercise exercise;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ProgressStatus status = ProgressStatus.NOT_STARTED;

    @Column(name = "attempts_count", nullable = false)
    private Integer attemptsCount = 0;

    @Column(name = "last_code", columnDefinition = "TEXT")
    private String lastCode;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // Constructeur par defaut
    public UserExerciseProgress() {
    }

    // Constructeur avec user et exercise
    public UserExerciseProgress(User user, Exercise exercise) {
        this.user = user;
        this.exercise = exercise;
    }

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
     * Marque l'exercice comme complete.
     */
    public void markCompleted() {
        this.status = ProgressStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();
    }

    /**
     * Incremente le compteur de tentatives.
     */
    public void incrementAttempts() {
        this.attemptsCount++;
        if (this.status == ProgressStatus.NOT_STARTED) {
            this.status = ProgressStatus.IN_PROGRESS;
        }
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

    public Exercise getExercise() {
        return exercise;
    }

    public void setExercise(Exercise exercise) {
        this.exercise = exercise;
    }

    public ProgressStatus getStatus() {
        return status;
    }

    public void setStatus(ProgressStatus status) {
        this.status = status;
    }

    public Integer getAttemptsCount() {
        return attemptsCount;
    }

    public void setAttemptsCount(Integer attemptsCount) {
        this.attemptsCount = attemptsCount;
    }

    public String getLastCode() {
        return lastCode;
    }

    public void setLastCode(String lastCode) {
        this.lastCode = lastCode;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
}
