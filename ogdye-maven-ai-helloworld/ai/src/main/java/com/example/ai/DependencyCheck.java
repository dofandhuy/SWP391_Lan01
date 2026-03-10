package com.example.ai;

public class DependencyCheck {
    public static void main(String[] args) {
        try {
			System.out.println("Hello from AI World!");
            Class.forName("opennlp.tools.tokenize.TokenizerME");
            System.out.println("OpenNLP Tokenize classes are available for use!");
            Class.forName("opennlp.tools.sentdetect.SentenceDetectorME");
            System.out.println("OpenNLP Sentence Detector classes are available for use!");
        } catch (ClassNotFoundException e) {
            System.out.println("OpenNLP classes NOT found");
            e.printStackTrace();
        }
    }
}