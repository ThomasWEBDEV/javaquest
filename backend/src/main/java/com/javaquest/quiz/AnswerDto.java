package com.javaquest.quiz;

/**
 * DTO pour la representation d'une reponse.
 */
public record AnswerDto(
    Long id,
    String text,
    Integer orderIndex,
    Boolean isCorrect
) {
    public static AnswerDto fromEntity(Answer answer, boolean includeCorrect) {
        return new AnswerDto(
            answer.getId(),
            answer.getText(),
            answer.getOrderIndex(),
            includeCorrect ? answer.getIsCorrect() : null
        );
    }
}
