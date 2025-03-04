import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.speech.v1.*;
import com.google.cloud.speech.v1.RecognitionConfig.AudioEncoding;
import com.google.protobuf.ByteString;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class SpeechToTextUtil {
    private static final String CREDENTIALS_PATH = "D:/Fraud detection website/tomcat/credentials/coral-balancer-452113-d1-b4db16284e55.json";

    public static String transcribeAudio(String filePath) throws IOException {
        // Load Google Cloud credentials explicitly
        GoogleCredentials credentials = GoogleCredentials.fromStream(new FileInputStream(CREDENTIALS_PATH));
        SpeechSettings speechSettings = SpeechSettings.newBuilder()
                .setCredentialsProvider(() -> credentials)
                .build();

        try (SpeechClient speechClient = SpeechClient.create(speechSettings)) {  
            byte[] audioBytes = Files.readAllBytes(Paths.get(filePath));
            ByteString audioData = ByteString.copyFrom(audioBytes);

            RecognitionConfig config = RecognitionConfig.newBuilder()
                .setEncoding(AudioEncoding.WEBM_OPUS)  
                .setLanguageCode("en-US")
//                .addAlternativeLanguageCodes("hi-IN")  
//                .addAlternativeLanguageCodes("mr-IN")  
                .build();

            RecognitionAudio audio = RecognitionAudio.newBuilder()
                .setContent(audioData)
                .build();

            RecognizeResponse response = speechClient.recognize(config, audio);
            List<SpeechRecognitionResult> results = response.getResultsList();

            StringBuilder transcript = new StringBuilder();
            for (SpeechRecognitionResult result : results) {
                transcript.append(result.getAlternatives(0).getTranscript()).append("\n");
            }

            return transcript.toString();
        }
    }
}

