from python import Python
from utils.list import Dim

struct Board:
    var board_size: DTypePointer[DType.uint8]
    var bounding_box: DTypePointer[DType.uint8]
    var image_size: DTypePointer[DType.uint8]
    