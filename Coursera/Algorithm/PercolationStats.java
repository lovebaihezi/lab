import edu.princeton.cs.algs4.StdRandom;
import edu.princeton.cs.algs4.StdStats;

public class PercolationStats {
  private final double[] div;
  // perform independent trials on an n-by-n grid
  public PercolationStats(int n, int t) {
    if (n <= 0 || t <= 0) {
      throw new IllegalArgumentException();
    }
    var data = new int[t];
    div = new double[t];
    for (var i = 0; i < t; i += 1) {
      var percolation = new Percolation(n);
      while (!percolation.percolates()) {
        var row = StdRandom.uniform(1, n + 1);
        var col = StdRandom.uniform(1, n + 1);
        percolation.open(row, col);
      }
      data[i] = percolation.numberOfOpenSites();
      div[i] = (double) data[i] / (n * n);
    }
  }

  public static void main(String[] args) {}

  // sample mean of percolation threshold
  public double mean() {
    return StdStats.mean(div);
  }

  // sample standard deviation of percolation threshold
  public double stddev() {
    return StdStats.stddev(div);
  }

  // low endpoint of 95% confidence interval
  public double confidenceLo() {
    return mean() - 1.96 / Math.sqrt(div.length);
  }

  // high endpoint of 95% confidence interval
  public double confidenceHi() {
    return mean() + 1.96 / Math.sqrt(div.length);
  }
}
