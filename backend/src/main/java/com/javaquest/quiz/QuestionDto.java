package com.javaquest.quiz;

import java.util.List;

/**
 * DTO pour la representation d'une question.
 * Note: l'explication n'est pas exposee avant la soumission.
 */
public record QuestionDto(
    Long id,
    String text,
    QuestionType questionType,
    String codeSnippet,
    Integer orderIndex,
    List<AnswerDto> answers
) {
    public static QuestionDto fromEntity(Question question, boolean includeCorrect) {
        List<AnswerDto> answerDtos = question.getAnswers().stream()
            .map(a -> AnswerDto.fromEntity(a, includeCorrect))
            .toList();

        return new QuestionDto(
            question.getId(),
            question.getText(),
            question.getQuestionType(),
            question.getCodeSnippet(),
            question.getOrderIndex(),
            answerDtos
        );
    }
}
