import Cocoa
import CoreFoundation

class SwiftFastImageSize {
    var text = "Hello, World!"

    /// Supported image types.
    public enum ImageType: String {
      case gif
      case png
      case jpeg
      case bmp
      case unsupported
    }

    private struct PNGSize {
      var width: UInt32 = 0
      var height: UInt32 = 0
    }

    private struct GIFSize {
      var width: UInt16 = 0
      var height: UInt16 = 0
    }
    
    /// Takes an NSData instance and returns an image type.
    static func imageType(with data: Data) -> ImageType {
        let sampleLength = 2

        if (data.count < sampleLength) { return .unsupported }

        var length = UInt16(0); (data as NSData).getBytes(&length, range: NSRange(location: 0, length: sampleLength))
        
        switch CFSwapInt16(length) {
            case 0xFFD8:
              return .jpeg
            case 0x8950:
              return .png
            case 0x4749:
              return .gif
            default:
              return .unsupported
        }
    }
    
    /// Takes an NSData instance and returns an image size (CGSize).
    static func imageSize(with data: Data) -> CGSize {
      switch self.imageType(with: data) {
      case .png:
        return self.sizeForPNG(with: data)
      case .gif:
        return self.sizeForGIF(with: data)
      case .jpeg:
        return self.sizeForJPEG(with: data)
      default:
        return CGSize.zero
      }
    }
    
    // MARK: GIF
    
    static func sizeForGIF(with data: Data) -> CGSize {
      if (data.count < 11) { return CGSize.zero }
      
      var size = GIFSize(); (data as NSData).getBytes(&size, range: NSRange(location: 6, length: 4))
      
      return CGSize(width: Int(size.width), height: Int(size.height))
    }
    
    // MARK: PNG
    
    static func sizeForPNG(with data: Data) -> CGSize {
      if (data.count < 25) { return CGSize.zero }
      
      var size = PNGSize()
      (data as NSData).getBytes(&size, range: NSRange(location: 16, length: 8))
      
      return CGSize(width: Int(CFSwapInt32(size.width)), height: Int(CFSwapInt32(size.height)))
    }
    
    // MARK: JPEG
    
    static func sizeForJPEG(with data: Data) -> CGSize {
      let offset = 2
      var size: CGSize?
      
        // TODO
      
      return size!
    }
    
    // MARK: BMP
    
    static func sizeForBMP(with data: Data) -> CGSize {
        if (data.count < 25) { return CGSize.zero }

      
      return CGSize.zero
    }
    
    var path: String
    var filename: String?
    var attrs: [FileAttributeKey : Any]?
    var imageType: ImageType?
    init(path: String) {
        self.path = path
        filename = URL(fileURLWithPath: path).lastPathComponent
    }
    
    func parse() throws {
        attrs = try FileManager.default.attributesOfItem(atPath: path)
        guard let fileHandle = FileHandle(forReadingAtPath: path) else {
            return
        }
        
        if #available(OSX 10.15, *) {
            let header = try fileHandle.read(upToCount: 26)
        } else {
            // Fallback on earlier versions
        }
        imageType = SwiftFastImageSize.imageType(with: header)
    }
}

