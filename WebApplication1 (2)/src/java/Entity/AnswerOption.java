package Entity;

public class AnswerOption {
    private int answerID;
    private int questionID;
    private String answerText;
    private boolean isCorrect;

    public AnswerOption() {}

    public AnswerOption(String answerText, boolean isCorrect) {
        this.answerText = answerText;
        this.isCorrect = isCorrect;
    }

    public int getAnswerID() { return answerID; }
    public void setAnswerID(int answerID) { this.answerID = answerID; }

    public int getQuestionID() { return questionID; }
    public void setQuestionID(int questionID) { this.questionID = questionID; }

    public String getAnswerText() { return answerText; }
    public void setAnswerText(String answerText) { this.answerText = answerText; }

    public boolean isCorrect() { return isCorrect; }
    public void setCorrect(boolean correct) { isCorrect = correct; }
}
