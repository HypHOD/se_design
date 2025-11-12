package Game;
import java.io.IOException;

public class DuckBark {
    interface BehaveStrategy { void makeBehave(); }
    // Behave不同的实现
    static class Behave_GetPoint implements BehaveStrategy {
        @Override public void makeBehave() {System.out.println("Behave_GetPoint");}
    }

    interface SoundStrategy { void makeSound(); }
    // Sound不同的实现
    static class Sound_GetPoint implements SoundStrategy {
        @Override public void makeSound() {
            String txt="又要到饭啦";
            TTSUtil.speak(txt);
        }
    }

    /* 封装 TTS */
    static class TTSUtil {
        public static void speak(String text) {
            try {
                String cmd;
                String os = System.getProperty("os.name").toLowerCase();
                if (os.contains("win")) {
                    // PowerShell 调用 SAPI
                    cmd = "powershell -ExecutionPolicy Bypass -Command \"Add-Type –AssemblyName System.Speech; " +
                            "(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('" + text + "');\"";
                } else if (os.contains("mac")) {
                    cmd = "say " + text;
                } else {               // Linux
                    cmd = "espeak \"" + text + "\"";
                }
                new ProcessBuilder(cmd.split(" ")).inheritIO().start().waitFor();
            } catch (IOException | InterruptedException e) {
                System.err.println("TTS 失败: " + e.getMessage());
            }
        }
    }

    static class Duck {
        private BehaveStrategy behaveStrategy;
        private SoundStrategy soundStrategy;

        public void setBehaveStrategy(BehaveStrategy behaveStrategy) {this.behaveStrategy = behaveStrategy;}
        public void setSoundStrategy(SoundStrategy soundStrategy) {this.soundStrategy = soundStrategy;}

        public void act() {
            behaveStrategy.makeBehave();
            soundStrategy.makeSound();
        }
    }
}
