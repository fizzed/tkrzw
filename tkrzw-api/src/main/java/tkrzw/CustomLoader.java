package tkrzw;

import com.fizzed.jne.JNE;
import com.fizzed.jne.MemoizedInitializer;
import com.fizzed.jne.MemoizedRunner;

/**
 * Custom double-locked safe loading of native libs.
 */
public class CustomLoader {

  static private final MemoizedRunner loader = new MemoizedRunner();

  static public void loadLibrary() {
    loader.once(() -> {
      JNE.loadLibrary("jtkrzw");
    });
  }

}