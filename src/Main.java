import javax.microedition.midlet.*;
import javax.microedition.lcdui.*;

public class Main extends MIDlet {
    private Display display;

    public void startApp() {
        display = Display.getDisplay(this);
        TextBox helloScreen = new TextBox("Hello", "Hello, Nokia 112!", 256, 0);
        display.setCurrent(helloScreen);
    }

    public void pauseApp() {}

    public void destroyApp(boolean unconditional) {}
}