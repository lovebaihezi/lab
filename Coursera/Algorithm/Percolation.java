import edu.princeton.cs.algs4.StdRandom;
import edu.princeton.cs.algs4.WeightedQuickUnionUF;

public class Percolation {
  // typeof Object will be Array<Integer>[]
  private final WeightedQuickUnionUF connected;
  private final boolean[][] map;
  private int numberOfOpenSites = 0;
  // creates n-by-n grid, with all sites initially blocked
  public Percolation(int n) {
    if (n <= 0) {
      throw new IllegalArgumentException();
    }
    // the first and the last will be the virtual root node to quick find if the map is percolates
    connected = new WeightedQuickUnionUF(n * n + 2);
    map = new boolean[n][n];
    for (var arr : map) {
      for (var i = 0; i < arr.length; i += 1) {
        arr[i] = false;
      }
    }
  }

  // test client (optional)
  public static void main(String[] args) {
    var n = Integer.parseInt(args[0]);
    var percolation = new Percolation(n);
    while (!percolation.percolates()) {
      var row = StdRandom.uniform(1, n + 1);
      var col = StdRandom.uniform(1, n + 1);
      percolation.open(row, col);
    }
    percolation.printMap();
  }

  private void printMap() {
    for (var arr : map) {
      for (var v : arr) {
        System.out.printf("%s", v ? "o" : " ");
      }
      System.out.println();
    }
    System.out.println();
    for (var i = 1; i <= map.length; i += 1) {
      for (var j = 1; j <= map[i - 1].length; j += 1) {
        System.out.printf("%s", isFull(i, j) ? "+" : " ");
      }
      System.out.println();
    }
  }

  // opens the site (row, col) if it is not open already
  public void open(int row, int col) {
    if (row <= 0 || col <= 0 || row > map.length || col > map.length) {
      throw new IllegalArgumentException();
    }
    row -= 1;
    col -= 1;
    if (!map[row][col]) {
      numberOfOpenSites += 1;
    } else {
      return;
    }
    map[row][col] = true;
    //   A
    // D T B
    //   C
    final var t = row * map.length + col + 1;
    if (row == 0) {
      connected.union(t, 0);
    }
    if (row == map.length - 1) {
      connected.union(t, map.length * map.length + 1);
    }
    // if A then connect T with A
    if (row != 0 && map[row - 1][col]) {
      connected.union(t, t - map.length);
    }
    // if C then connect T with C
    if ((row != map.length - 1) && map[row + 1][col]) {
      connected.union(t, t + map.length);
    }
    // if D then connect T with D
    if (col != 0 && map[row][col - 1]) {
      connected.union(t, t - 1);
    }
    // if B then connect T with B
    if ((col != map.length - 1) && map[row][col + 1]) {
      connected.union(t, t + 1);
    }
  }

  // is the site (row, col) open?
  public boolean isOpen(int row, int col) {
    if (row <= 0 || col <= 0 || row > map.length || col > map.length) {
      throw new IllegalArgumentException();
    }
    return map[row - 1][col - 1];
  }

  // is the site (row, col) full?
  public boolean isFull(int row, int col) {
    if (row <= 0 || col <= 0 || row > map.length || col > map.length) {
      throw new IllegalArgumentException();
    }
    return this.isOpen(row, col)
        && connected.find((row - 1) * map.length + col) == connected.find(0);
  }

  // returns the number of open sites
  public int numberOfOpenSites() {
    return numberOfOpenSites;
  }

  // does the system percolate?
  public boolean percolates() {
    return connected.find(0) == connected.find(map.length * map.length + 1);
  }
}
