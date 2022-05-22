public class HelloGoodbye {
  public static void main(String[] args) {
    assert args.length > 2;
    System.out.printf("Hello %s and %s.\n", args[0], args[1]);
  }
}
