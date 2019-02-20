
import UIKit

class ImageReader: NSObject {
  static func readImage(named: String) -> [String] {
    guard let newImage = UIImage(named: named) else { return [String]() }
    guard let context = getContext(newImage) else { return [String]() }
    guard let newCGImage = newImage.cgImage else { return [String]() }
    let height = newCGImage.height
    let width = newCGImage.width
    var currentPixel = UnsafeMutableRawPointer(context.data)
    var allBits = [Bit]()

    for _ in 0..<height {
      for _ in 0..<width {
        guard let color = currentPixel?.bindMemory(to: RGBA32.self, capacity: 1) else { continue }
        if color.pointee.red & 0x01 != 0 {
          allBits.append(.one)
        } else {
          allBits.append(.zero)
        }

        currentPixel = currentPixel?.advanced(by: MemoryLayout<RGBA32>.size)
      }
    }

    return convertToString(from: allBits)
  }

  private static func getContext(_ inputImage: UIImage) -> CGContext? {
    guard let inputCGImage = inputImage.cgImage else { return nil }
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let width = inputCGImage.width
    let height = inputCGImage.height
    let bytesPerPixel = 4
    let bitsPerComponent = 8
    let bytesPerRow = bytesPerPixel * width
    let bitmapInfo = RGBA32.bitmapInfo

    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
      print("unable to create context")
      return nil
    }

    context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: CGFloat(width),height: CGFloat(height)))

    return context
  }

  private static func convertToString(from bits: [Bit]) -> [String] {
    let chunkBits = bits.chunk(8)
    let stop = Array<Bit>(repeating: .zero, count: 8)
    let etx: [Bit] = [.zero, .zero, .zero, .zero, .zero, .zero, .one, .one]
    var bytes = [UInt8]()
    var strings = [String]()

    for bits in chunkBits {
      if bits == stop {
        break
      }

      if bits == etx {
        if let string = String(bytes: bytes, encoding: .utf8) {
          strings.append(string)
          bytes.removeAll()
          continue
        }
      }

      let reverseBits = bits.reverseArray()
      let byte = convertToByte(from: reverseBits)
      bytes.append(byte)
    }

    return strings
  }

  private static func convertToByte(from bits: [Bit]) -> UInt8 {
    var binString = ""
    for bit in bits {
      binString += bit.description
    }

    let byte = binary2dec(num: binString)
    return byte
  }

  private static func binary2dec(num: String) -> UInt8 {
    var sum: UInt8 = 0
    for c in num {
      sum = sum * 2 + UInt8("\(c)")!
    }

    return sum
  }
}

enum Bit: UInt8, CustomStringConvertible {
  case zero, one

  var description: String {
    switch self {
    case .one:
      return "1"
    case .zero:
      return "0"
    }
  }
}

// MARK: Array extension
extension Array {
  func chunk(_ chunkSize: Int) -> [[Element]] {
    return stride(from: 0, to: self.count, by: chunkSize).map({ (startIndex) -> [Element] in
      let endIndex = (startIndex.advanced(by: chunkSize) > self.count) ? self.count-startIndex : chunkSize
      return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
    })
  }

  func reverseArray() -> [Element] {
    var reverse = [Element]()
    for arrayIndex in 0..<self.count {
      reverse.append(self[(self.count - 1) - arrayIndex])
    }

    return reverse
  }
}
