package com.javaquest.gamification;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entite representant un badge.
 */
@Entity
@Table(name = "badges")
public class Badge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String name;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "icon_url")
    private String iconUrl;

    @Enumerated(EnumType.STRING)
    @Column(name = "criteria_type", nullable = false, length = 50)
    private BadgeCriteria criteriaType;

    @Column(name = "criteria_value", nullable = false)
    private Integer criteriaValue;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    // Constructeur par defaut
    public Badge() {
    }

    // Constructeur complet
    public Badge(String name, String description, BadgeCriteria criteriaType, Integer criteriaValue) {
        this.name = name;
        this.description = description;
        this.criteriaType = criteriaType;
        this.criteriaValue = criteriaValue;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public BadgeCriteria getCriteriaType() {
        return criteriaType;
    }

    public void setCriteriaType(BadgeCriteria criteriaType) {
        this.criteriaType = criteriaType;
    }

    public Integer getCriteriaValue() {
        return criteriaValue;
    }

    public void setCriteriaValue(Integer criteriaValue) {
        this.criteriaValue = criteriaValue;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
