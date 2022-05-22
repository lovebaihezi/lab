import edu.princeton.cs.algs4.StdIn;
import edu.princeton.cs.algs4.StdRandom;

public class RandomWord {
  public static void main(String[] args) {
    String champion = null;
    var i = 0.;
    while (!StdIn.isEmpty()) {
      i += 1.;
      if(StdRandom.bernoulli(1. / i)) {
        champion = StdIn.readString();
      }
    }
    System.out.println(champion);
  }
}
