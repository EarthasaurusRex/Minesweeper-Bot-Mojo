from utils.vector import UnsafeFixedVector
from python import Python

try:
            let pg = Python.import_module("pyautogui")
        except:
            pass

struct Tile:
    var tileSize: UnsafeFixedVector[UInt8]
    var coord: UnsafeFixedVector[UInt8]
    var tilePosition: UnsafeFixedVector[UInt8]
    var data_type: Int
    var updated: Bool

    # Initialize
    fn __init__(inout self, imageSize: UnsafeFixedVector[Int], boardSize: UnsafeFixedVector[UInt8], coord: UnsafeFixedVector[UInt8], data_type: Int):
        # Available data types: 0 - 8 (# of mines in neighbors), 9 (Flagged), 10 (Unknown), 11 (Updated)
        self.data_type = data_type
        self.updated = True
        self.coord = coord
        self.tileSize = UnsafeFixedVector[UInt8](2)
        self.tilePosition = UnsafeFixedVector[UInt8](2)
        self.tileSize[0] = imageSize[0] / boardSize[0]
        self.tileSize[1] = imageSize[1] / boardSize[1]

        

    # Clicks the tile
    fn click(inout self, boundingBox: UnsafeFixedVector[UInt8], clickType: String):
        if len(self.tilePosition) < 2:
            self.tilePosition[0] = self.tileSize[0] * (self.coord[0] + 1.0 / 2) + boundingBox[0]
            self.tilePosition[1] = self.tileSize[1] * (self.coord[1] + 1.0 / 2) + boundingBox[1]
        pg.moveTo(self.tilePosition[0], self.tilePosition[1])
        if (clickType.equalsIgnoreCase("left")) {
            robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
        }
        else if (clickType.equalsIgnoreCase("right")) {
            robot.mousePress(InputEvent.BUTTON3_DOWN_MASK);
            robot.mouseRelease(InputEvent.BUTTON3_DOWN_MASK);
        }
//         TimeUnit.MILLISECONDS.sleep(50);
//         robot.mouseMove(0, 0);

    // Check if item in array
    public boolean check(double[][] array, double[] toCheck) {
        List<double[]> list = Arrays.asList(array);
        boolean contains = false;
        for (double[] arr : list) {
            if (Arrays.equals(arr, toCheck)) {
                contains = true;
            }
        }
//        Arrays.sort(array, Comparator.comparingDouble(a -> a[0]));
//        int res = Arrays.binarySearch(array, toCheck);
//        boolean test = res > 0 ? true : false;
//        boolean test = Arrays.asList(array).contains(toCheck);
        return contains;
    }

    // Update data type
    public void updatedata_type(Mat board, Mat prevBoard) {
        if (this.data_type == 9) {
            return;
        }
        // Get Tile
        Mat tileImage = board.submat(
                this.tileSize[1] * this.coord[1] + 5,
                this.tileSize[1] * (this.coord[1] + 1) - 5,
                this.tileSize[0] * this.coord[0] + 5,
                this.tileSize[0] * (this.coord[0] + 1) - 5
        );
        Mat prevTileImage = prevBoard.submat(
                this.tileSize[1] * this.coord[1] + 5,
                this.tileSize[1] * (this.coord[1] + 1) - 5,
                this.tileSize[0] * this.coord[0] + 5,
                this.tileSize[0] * (this.coord[0] + 1) - 5
        );

        // Check if image is updated
//        Mat diff = new Mat();
//        Core.subtract(tileImage, prevTileImage, diff);
//        System.out.println(Arrays.toString(diff.get(0,0)));
//        boolean eq = (diff.get(1, 0)[0] == 0) && (diff.get(0, 0)[1] == 0) && (diff.get(0, 0)[2] == 0);
//        if (eq) {
//            return;
//        }

        // Create mask to get number only
        Scalar light = new Scalar(159, 194, 229);
        Scalar dark = new Scalar(153, 184, 215);
        Mat mask = new Mat();
        Core.inRange(tileImage, dark, light, mask);
        Core.bitwise_not(mask, mask);
        Mat masked = new Mat();
        Core.bitwise_and(tileImage, tileImage, masked, mask);

//        HighGui.imshow("Masked", masked);
//        HighGui.waitKey(0);
//        HighGui.destroyAllWindows();

        // Get most dominant color
//         num_copy = num.copy();
//         unique, counts = numpy.unique(num_copy.reshape(-1,   3), axis=0, return_counts=True);
//         try:
//         	num_copy[:, :, 0], num_copy[:, :, 1], num_copy[:, :, 2] = unique[numpy.argsort(counts)[-2]];
//         except:
//         	num_copy[:, :, 0], num_copy[:, :, 1], num_copy[:, :, 2] = unique[numpy.argsort(counts)[-1]];
//         bgr = num_copy[round(num_copy.shape[0] / 2), round(num_copy.shape[1] / 2), :];

        // Get all pixel data
        double[][] pixels = new double[this.tileSize[0] * this.tileSize[1]][3];
        for (int row = 0; row < tileSize[0]; row++) {
            for (int col = 0; col < tileSize[1]; col++) {
                try {
                    double[] pixel = masked.get(row, col);
                    pixels[row * this.tileSize[0] + col] = pixel;
                } catch (Exception e) {}
            }
        }

//        System.out.println("Tile: (" + tileSize[0] + ", " + tileSize[1] + ")");
//        for (double[] arr : pixels) {
//            System.out.println(Arrays.toString(arr));
//        }

        // Identify data type
        if (check(pixels, new double[] {210, 118, 25})) {
            this.data_type = 1;
        }
		else if (check(pixels, new double[] {60, 142, 56})) {
            this.data_type = 2;
        }
		else if (check(pixels, new double[] {47, 47, 211})) {
            this.data_type = 3;
        }
		else if (check(pixels, new double[] {162, 31, 123})) {
            this.data_type = 4;
        }
		else if (check(pixels, new double[] {0, 143, 255})) {
            this.data_type = 5;
        }
		else if (check(pixels, new double[] {167, 151, 0})){
            this.data_type = 6;
        }
//        else if (check(pixels, new double[] {7, 54, 242})) {
//             this.data_type = 9;
//        }
		else if (check(pixels, new double[] {81, 215, 170}) || check(pixels, new double[] {73, 209, 162})) {
            this.data_type = 10;
        }
		else if (check(pixels, new double[] {0, 0, 0})) {
            this.data_type = 0;
        }
    }
}