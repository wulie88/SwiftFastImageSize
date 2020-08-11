import Cocoa
import CoreFoundation

class SwiftFastImageSize {

    /// Supported image types.
    public enum ImageType: String {
      case gif
      case png
      case jpeg
      case bmp
      case webp
      case unsupported
    }
    
    var path: String
    var filename: String?
    var attrs: [FileAttributeKey : Any]?
    var imageType: ImageType?
    var imageSize: CGSize?
    init(_ path: String) {
        self.path = path
        filename = URL(fileURLWithPath: path).lastPathComponent
    }
    
    func parse() throws {
        attrs = try FileManager.default.attributesOfItem(atPath: path)
        guard let fileHandle = FileHandle(forReadingAtPath: path) else {
            return
        }
        
        guard #available(OSX 10.15, *) else {
            return
        }
        
        guard let header = try fileHandle.read(upToCount: 512) else {
            return
        }
        
        /// \211PNG\r\n\032\n
        let png = Data([0x89, 0x50])
        /// \377\330
        let jpeg = Data([0xFF, 0xD8])
        /// RIFF(?m:....)WEBP
        let webp = "WEBP".data(using: .ascii)
        
        // detect image type and image size
        if ["GIF87a".data(using: .ascii), "GIF89a".data(using: .ascii)].contains(header[0...5]) {
            /// GIF
            imageType = .gif
            let s = try unpack("<HH", header[6...9])
            imageSize = CGSize(width: s[0] as! Int, height: s[1] as! Int)
        } else if png == header[0...1] && header[12...15] == "IHDR".data(using: .ascii) {
            /// PNGs
            imageType = .png
            let s = try unpack(">LL", header[16...23])
            imageSize = CGSize(width: s[0] as! Int, height: s[1] as! Int)
        } else if png == header[0...1] {
            /// older PNGs
            imageType = .png
            let s = try unpack(">LL", header[8...15])
            imageSize = CGSize(width: s[0] as! Int, height: s[1] as! Int)
        } else if jpeg == header[0...1] {
            /// jpeg
            imageType = .jpeg
            try fileHandle.seek(toOffset: 0)
            var b = try fileHandle.continueRead(2)
            b = try fileHandle.continueRead(1)
            while b.count > 0 && b[0] != 0xDA {
                print("\tb and ord(b) != 0xDA:", b[0])
                while b[0] != 0xFF {
                    b = try fileHandle.continueRead(1)
                    print("\t\twhile (ord(b) != 0xFF):", b[0])
                }
                while b[0] == 0xFF {
                    b = try fileHandle.continueRead(1)
                    print("\t\twhile (ord(b) == 0xFF):", b[0])
                }
                if b[0] >= 0xC0 && b[0] <= 0xC3 {
                    b = try fileHandle.continueRead(3)
                    b = try fileHandle.continueRead(4)
                    // opposite
                    let s = try unpack(">HH", b)
                    imageSize = CGSize(width: s[1] as! Int, height: s[0] as! Int)
                    break
                } else {
                    b = try fileHandle.continueRead(2)
                    let s = try unpack(">H", b)
                    let o = s[0]
                    print("\t\to:", o, " b: [ ", b[0], b[1], " ] s: ", s)
                    b = try fileHandle.continueRead(s[0] as! Int - 2)
                }
                b = try fileHandle.continueRead(1)
            }
        } else if webp == header[8...11] {
            /// webp
            imageType = .webp
            switch header[12...15] {
            case "VP8 ".data(using: .ascii):
                let s = try unpack("<HH", header[26...29])
                imageSize = CGSize(width: s[0] as! Int, height: s[1] as! Int)
            case "VP8L".data(using: .ascii):
                let s = try unpack("<l", header[21...24])
                let n = s[0] as! Int
                let w = (n & 0x3fff) + 1
                let h = (n >> 14 & 0x3fff) + 1
                imageSize = CGSize(width: w, height: h)
            default:
                // 'VP8X'
                let s = try unpack("<HBHB", header[24...29])
                let w16 = s[0] as! Int, w8 = s[1] as! Int, h16 = s[2] as! Int, h8 = s[3] as! Int
                let w = (w16 | w8 << 16) + 1
                let h = (h16 | h8 << 16) + 1
                imageSize = CGSize(width: w, height: h)
            }
        }
        
        print(filename!, imageType!, imageSize!, try fileHandle.offset())
        
        try fileHandle.close()
    }
}

extension FileHandle {
    func continueRead(_ count: Int) throws -> Data {
        if #available(OSX 10.15, *) {
            return try read(upToCount: count) ?? Data()
        } else {
            // Fallback on earlier versions
            return readData(ofLength: count)
        }
    }
}

