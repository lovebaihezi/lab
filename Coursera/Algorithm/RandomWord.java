import edu.princeton.cs.algs4.StdIn;
import edu.princeton.cs.algs4.StdRandom;

public class RandomWord {
  public static void main(String[] args) {
    String champion = null;
    for (int i = 1;!StdIn.isEmpty();i += 1) {
      var v = StdIn.readString();
      if(StdRandom.bernoulli(1. / (double)i)) {
        champion = v;
      }
    }
    System.out.println(champion);
  }
}
