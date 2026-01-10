class GuageUtils {
    static double getAlignmentForAVGLevel(int level) {
    switch (level) {
      case 0:
        return -0.80;
      case 1:
        return -0.40;
      case 2:
        return 0.0;
      case 3:
        return 0.40;
      case 4:
        return 0.80;
      default:
        return 0.0;
    }
  }

  static double getAlignmentForLevel(int level) {
    switch (level) {
      case 0:
        return -0.85;
      case 1:
        return -0.43;
      case 2:
        return 0.0;
      case 3:
        return 0.43; 
      case 4:
        return 0.85;
      default:
        return 0.0;
    }
  }
}