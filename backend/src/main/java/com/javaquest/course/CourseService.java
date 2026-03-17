package com.javaquest.course;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Service gérant les opérations sur les cours.
 * CRUD chapitres et leçons.
 */
@Service
public class CourseService {

    private final ChapterRepository chapterRepository;
    private final LessonRepository lessonRepository;

    public CourseService(ChapterRepository chapterRepository, LessonRepository lessonRepository) {
        this.chapterRepository = chapterRepository;
        this.lessonRepository = lessonRepository;
    }

    // ==================== Chapitres ====================

    /**
     * Récupère tous les chapitres publiés.
     */
    public List<Chapter> getPublishedChapters() {
        return chapterRepository.findByIsPublishedTrueOrderByOrderIndexAsc();
    }

    /**
     * Récupère tous les chapitres (admin).
     */
    public List<Chapter> getAllChapters() {
        return chapterRepository.findAllByOrderByOrderIndexAsc();
    }

    /**
     * Récupère un chapitre par son ID.
     */
    public Chapter getChapterById(Long id) {
        return chapterRepository.findById(id)
            .orElseThrow(() -> new CourseException("Chapitre non trouvé"));
    }

    /**
     * Récupère un chapitre par son slug.
     */
    public Chapter getChapterBySlug(String slug) {
        return chapterRepository.findBySlug(slug)
            .orElseThrow(() -> new CourseException("Chapitre non trouvé"));
    }

    /**
     * Crée un nouveau chapitre.
     */
    @Transactional
    public Chapter createChapter(String title, String slug, String description, Integer orderIndex) {
        if (chapterRepository.existsBySlug(slug)) {
            throw new CourseException("Ce slug existe déjà");
        }

        Chapter chapter = new Chapter(title, slug, description, orderIndex);
        return chapterRepository.save(chapter);
    }

    /**
     * Met à jour un chapitre.
     */
    @Transactional
    public Chapter updateChapter(Long id, String title, String description, Integer xpReward, Boolean isPublished) {
        Chapter chapter = getChapterById(id);
        
        if (title != null) chapter.setTitle(title);
        if (description != null) chapter.setDescription(description);
        if (xpReward != null) chapter.setXpReward(xpReward);
        if (isPublished != null) chapter.setIsPublished(isPublished);

        return chapterRepository.save(chapter);
    }

    /**
     * Supprime un chapitre.
     */
    @Transactional
    public void deleteChapter(Long id) {
        Chapter chapter = getChapterById(id);
        chapterRepository.delete(chapter);
    }

    // ==================== Leçons ====================

    /**
     * Récupère toutes les leçons d'un chapitre.
     */
    public List<Lesson> getLessonsByChapter(Long chapterId) {
        // Vérifie que le chapitre existe
        getChapterById(chapterId);
        return lessonRepository.findByChapterIdOrderByOrderIndexAsc(chapterId);
    }

    /**
     * Récupère une leçon par son ID.
     */
    public Lesson getLessonById(Long id) {
        return lessonRepository.findById(id)
            .orElseThrow(() -> new CourseException("Leçon non trouvée"));
    }

    /**
     * Récupère une leçon par chapitre et slug.
     */
    public Lesson getLessonBySlug(Long chapterId, String slug) {
        return lessonRepository.findByChapterIdAndSlug(chapterId, slug)
            .orElseThrow(() -> new CourseException("Leçon non trouvée"));
    }

    /**
     * Crée une nouvelle leçon dans un chapitre.
     */
    @Transactional
    public Lesson createLesson(Long chapterId, String title, String slug, String content, Integer orderIndex) {
        Chapter chapter = getChapterById(chapterId);

        if (lessonRepository.existsByChapterIdAndSlug(chapterId, slug)) {
            throw new CourseException("Ce slug existe déjà dans ce chapitre");
        }

        Lesson lesson = new Lesson(title, slug, content, orderIndex);
        chapter.addLesson(lesson);
        
        return lessonRepository.save(lesson);
    }

    /**
     * Met à jour une leçon.
     */
    @Transactional
    public Lesson updateLesson(Long id, String title, String content, Integer xpReward) {
        Lesson lesson = getLessonById(id);

        if (title != null) lesson.setTitle(title);
        if (content != null) lesson.setContent(content);
        if (xpReward != null) lesson.setXpReward(xpReward);

        return lessonRepository.save(lesson);
    }

    /**
     * Supprime une leçon.
     */
    @Transactional
    public void deleteLesson(Long id) {
        Lesson lesson = getLessonById(id);
        lessonRepository.delete(lesson);
    }
}
