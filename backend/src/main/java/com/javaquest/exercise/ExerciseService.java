package com.javaquest.exercise;

import com.javaquest.course.Lesson;
import com.javaquest.course.LessonRepository;
import com.javaquest.course.CourseException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Service gerant les operations sur les exercices.
 */
@Service
public class ExerciseService {

    private final ExerciseRepository exerciseRepository;
    private final LessonRepository lessonRepository;

    public ExerciseService(ExerciseRepository exerciseRepository, LessonRepository lessonRepository) {
        this.exerciseRepository = exerciseRepository;
        this.lessonRepository = lessonRepository;
    }

    /**
     * Recupere tous les exercices d'une lecon.
     */
    public List<Exercise> getExercisesByLesson(Long lessonId) {
        return exerciseRepository.findByLessonIdOrderByOrderIndexAsc(lessonId);
    }

    /**
     * Recupere un exercice par son ID.
     */
    public Exercise getExerciseById(Long id) {
        return exerciseRepository.findById(id)
            .orElseThrow(() -> new ExerciseException("Exercice non trouve"));
    }

    /**
     * Cree un nouvel exercice.
     */
    @Transactional
    public Exercise createExercise(Long lessonId, String title, String description,
                                   String starterCode, String solutionCode, String testCode,
                                   String hints, Difficulty difficulty, Integer xpReward,
                                   Integer orderIndex) {
        Lesson lesson = lessonRepository.findById(lessonId)
            .orElseThrow(() -> new CourseException("Lecon non trouvee"));

        Exercise exercise = new Exercise(title, description, starterCode, solutionCode, testCode, orderIndex);
        exercise.setLesson(lesson);
        exercise.setHints(hints);
        exercise.setDifficulty(difficulty != null ? difficulty : Difficulty.EASY);
        exercise.setXpReward(xpReward != null ? xpReward : 50);

        return exerciseRepository.save(exercise);
    }

    /**
     * Met a jour un exercice.
     */
    @Transactional
    public Exercise updateExercise(Long id, String title, String description,
                                   String starterCode, String solutionCode, String testCode,
                                   String hints, Difficulty difficulty, Integer xpReward) {
        Exercise exercise = getExerciseById(id);

        if (title != null) exercise.setTitle(title);
        if (description != null) exercise.setDescription(description);
        if (starterCode != null) exercise.setStarterCode(starterCode);
        if (solutionCode != null) exercise.setSolutionCode(solutionCode);
        if (testCode != null) exercise.setTestCode(testCode);
        if (hints != null) exercise.setHints(hints);
        if (difficulty != null) exercise.setDifficulty(difficulty);
        if (xpReward != null) exercise.setXpReward(xpReward);

        return exerciseRepository.save(exercise);
    }

    /**
     * Supprime un exercice.
     */
    @Transactional
    public void deleteExercise(Long id) {
        Exercise exercise = getExerciseById(id);
        exerciseRepository.delete(exercise);
    }

    /**
     * Recupere les exercices par difficulte.
     */
    public List<Exercise> getExercisesByDifficulty(Difficulty difficulty) {
        return exerciseRepository.findByDifficulty(difficulty);
    }
}
