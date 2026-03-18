package com.javaquest.course;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controller REST pour la gestion des cours.
 * Endpoints pour chapitres et lecons.
 */
@RestController
@RequestMapping("/api/courses")
public class CourseController {

    private final CourseService courseService;

    public CourseController(CourseService courseService) {
        this.courseService = courseService;
    }

    // ==================== Chapitres ====================

    /**
     * Liste tous les chapitres publies.
     * GET /api/courses/chapters
     */
    @GetMapping("/chapters")
    public ResponseEntity<List<ChapterDto>> getPublishedChapters() {
        List<ChapterDto> chapters = courseService.getPublishedChapters()
            .stream()
            .map(ChapterDto::fromEntity)
            .toList();
        return ResponseEntity.ok(chapters);
    }

    /**
     * Liste tous les chapitres (admin).
     * GET /api/courses/chapters/all
     */
    @GetMapping("/chapters/all")
    public ResponseEntity<List<ChapterDto>> getAllChapters() {
        List<ChapterDto> chapters = courseService.getAllChapters()
            .stream()
            .map(ChapterDto::fromEntity)
            .toList();
        return ResponseEntity.ok(chapters);
    }

    /**
     * Recupere un chapitre par son slug.
     * GET /api/courses/chapters/{slug}
     */
    @GetMapping("/chapters/{slug}")
    public ResponseEntity<ChapterDto> getChapterBySlug(@PathVariable String slug) {
        Chapter chapter = courseService.getChapterBySlug(slug);
        return ResponseEntity.ok(ChapterDto.fromEntity(chapter));
    }

    /**
     * Cree un nouveau chapitre.
     * POST /api/courses/chapters
     */
    @PostMapping("/chapters")
    public ResponseEntity<ChapterDto> createChapter(@Valid @RequestBody CreateChapterRequest request) {
        Chapter chapter = courseService.createChapter(
            request.title(),
            request.slug(),
            request.description(),
            request.orderIndex()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(ChapterDto.fromEntity(chapter));
    }

    /**
     * Met a jour un chapitre.
     * PUT /api/courses/chapters/{id}
     */
    @PutMapping("/chapters/{id}")
    public ResponseEntity<ChapterDto> updateChapter(
            @PathVariable Long id,
            @Valid @RequestBody UpdateChapterRequest request) {
        Chapter chapter = courseService.updateChapter(
            id,
            request.title(),
            request.description(),
            request.xpReward(),
            request.isPublished()
        );
        return ResponseEntity.ok(ChapterDto.fromEntity(chapter));
    }

    /**
     * Supprime un chapitre.
     * DELETE /api/courses/chapters/{id}
     */
    @DeleteMapping("/chapters/{id}")
    public ResponseEntity<Void> deleteChapter(@PathVariable Long id) {
        courseService.deleteChapter(id);
        return ResponseEntity.noContent().build();
    }

    // ==================== Lecons ====================

    /**
     * Liste toutes les lecons d'un chapitre.
     * GET /api/courses/chapters/{chapterId}/lessons
     */
    @GetMapping("/chapters/{chapterId}/lessons")
    public ResponseEntity<List<LessonDto>> getLessonsByChapter(@PathVariable Long chapterId) {
        List<LessonDto> lessons = courseService.getLessonsByChapter(chapterId)
            .stream()
            .map(LessonDto::fromEntity)
            .toList();
        return ResponseEntity.ok(lessons);
    }

    /**
     * Recupere une lecon par son ID.
     * GET /api/courses/lessons/{id}
     */
    @GetMapping("/lessons/{id}")
    public ResponseEntity<LessonDto> getLessonById(@PathVariable Long id) {
        Lesson lesson = courseService.getLessonById(id);
        return ResponseEntity.ok(LessonDto.fromEntity(lesson));
    }

    /**
     * Cree une nouvelle lecon dans un chapitre.
     * POST /api/courses/chapters/{chapterId}/lessons
     */
    @PostMapping("/chapters/{chapterId}/lessons")
    public ResponseEntity<LessonDto> createLesson(
            @PathVariable Long chapterId,
            @Valid @RequestBody CreateLessonRequest request) {
        Lesson lesson = courseService.createLesson(
            chapterId,
            request.title(),
            request.slug(),
            request.content(),
            request.orderIndex()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(LessonDto.fromEntity(lesson));
    }

    /**
     * Met a jour une lecon.
     * PUT /api/courses/lessons/{id}
     */
    @PutMapping("/lessons/{id}")
    public ResponseEntity<LessonDto> updateLesson(
            @PathVariable Long id,
            @Valid @RequestBody UpdateLessonRequest request) {
        Lesson lesson = courseService.updateLesson(
            id,
            request.title(),
            request.content(),
            request.xpReward()
        );
        return ResponseEntity.ok(LessonDto.fromEntity(lesson));
    }

    /**
     * Supprime une lecon.
     * DELETE /api/courses/lessons/{id}
     */
    @DeleteMapping("/lessons/{id}")
    public ResponseEntity<Void> deleteLesson(@PathVariable Long id) {
        courseService.deleteLesson(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Gestion des erreurs liees aux cours.
     */
    @ExceptionHandler(CourseException.class)
    public ResponseEntity<Map<String, String>> handleCourseException(CourseException ex) {
        return ResponseEntity
            .status(HttpStatus.NOT_FOUND)
            .body(Map.of("error", ex.getMessage()));
    }
}
