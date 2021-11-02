import CoreGraphics
import CoreImage
import CoreImage.CIFilterBuiltins
import SnapshotTesting
import SwiftUI
import XCTest
@testable import MacSnapshottesting

final class MacSnapshottestingTests: XCTestCase {

  func testExample() throws {
    let view = MacSnapshottesting()
//    isRecording = true
    assertSnapshot(matching: view, as: .image)

  }

//  func testSameData() throws {
//    let ci = URL(string: "file:///Users/tillhainbach/GitHub/_temp/MacSnapshottesting/ci.png")!
//    let ref = URL(string: "file:///Users/tillhainbach/GitHub/_temp/MacSnapshottesting/ref.png")!
//
//    let ciData = try Data(contentsOf: ci)
//    let refData = try Data(contentsOf: ref)
//
//    XCTAssertEqual(ciData, refData)
//  }
//
//  func testBitPerComponent() throws {
//    let ci = URL(string: "file:///Users/tillhainbach/GitHub/_temp/MacSnapshottesting/ci.png")!
//    let ref = URL(string: "file:///Users/tillhainbach/GitHub/_temp/MacSnapshottesting/ref.png")!
//
//    let ciImage = NSImage(contentsOf: ci)!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
//    let refImage = NSImage(contentsOf: ref)!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
//
//    XCTAssertEqual(ciImage.bitsPerComponent, refImage.bitsPerComponent)
//    XCTAssertEqual(ciImage.bitsPerPixel, refImage.bitsPerPixel)
//    XCTAssertEqual(ciImage, refImage)
//  }
}

extension Snapshotting where Value: View, Format == NSImage {

  public static var image: Self {
    return SimplySnapshotting.image(precision: 1).asyncPullback { swiftUIView in
      let controller = NSHostingController(rootView: swiftUIView)
      let view = controller.view
//      let size = controller.sizeThatFits(in: .zero)
      let size = NSSize(width: 500, height: 300)
      view.frame.size = size
      view.appearance = NSAppearance(named: .aqua)


      return Async { callback in
        let bitmapRep = view.bitmapImageRepForCachingDisplay(in: view.bounds)!
        view.cacheDisplay(in: view.bounds, to: bitmapRep)
        let image =  NSImage(size: view.bounds.size)
        image.addRepresentation(bitmapRep)

        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let genericRGBColorSpace = CGColorSpace(name: CGColorSpace.genericRGBLinear)!
        let ciImage = CIImage(cgImage: cgImage).matchedFromWorkingSpace(to: genericRGBColorSpace)!
        let resizeFilter = CIFilter.bicubicScaleTransform()
        resizeFilter.scale = Float(size.width / ciImage.extent.width)
        resizeFilter.inputImage = ciImage
        let ouputImage = resizeFilter.outputImage!
        let context = CIContext(options: nil)
//          options: [
//            CIContextOption.workingFormat: CIFormat.RGB
//          ]
//        )
        let newCGImage = context.createCGImage(ouputImage, from: ouputImage.extent)!
        let genericImage = NSImage(
          cgImage: newCGImage,
          size: .init(width: newCGImage.width, height: newCGImage.height)
        )

        callback(genericImage)

      }

    }
  }

  public static func image(precision: Float = 1, size: CGSize? = nil) -> Snapshotting {
    return SimplySnapshotting.image(precision: precision).asyncPullback { swiftUIView in
      let controller = NSHostingController(rootView: swiftUIView)
      let window = NSWindow(contentViewController: controller)
      window.backgroundColor = .windowBackgroundColor
      window.colorSpace = .genericRGB
      let windowController = NSWindowController(window: window)

      return Async { callback in
        windowController.showWindow(self)
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(1))) {
          guard let image = takeSnapshot(from: windowController) else { return }
          callback(image)
        }
      }
    }
  }

  static private func takeSnapshot(from windowController: NSWindowController) -> NSImage? {
    guard let window = windowController.window else { return nil }

    var image = CGWindowListCreateImage(
      .null,
      .optionIncludingWindow, CGWindowID(window.windowNumber), [.shouldBeOpaque, .boundsIgnoreFraming])!
    let genericRGBColorSpace = CGColorSpace(name: CGColorSpace.genericRGBLinear)!
    image = image.copy(colorSpace: genericRGBColorSpace)!

    return NSImage(cgImage: image, size: .init(width: image.width, height: image.height))

  }


//  static private func convertToRGB(cgImage: CGImage) -> NSImage {
//    guard
//      let sourceImageFormat = vImage_CGImageFormat(cgImage: cgImage),
//      let rgbDestinationImageFormat = vImage_CGImageFormat(
//        bitsPerComponent: 8,
//        bitsPerPixel: 32,
//        colorSpace: CGColorSpaceCreateDeviceRGB(),
//        bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
//        renderingIntent: .defaultIntent)
//    else {
//      print("Unable to initialize cgImage or colorSpace.")
//      return nil
//    }
//
//    guard
//      let sourceBuffer = try? vImage_Buffer(cgImage: cgImage),
//      var rgbDestinationBuffer = try? vImage_Buffer(
//        width: Int(sourceBuffer.width),
//        height: Int(sourceBuffer.height),
//        bitsPerPixel: rgbDestinationImageFormat.bitsPerPixel)
//    else {
//      XCTFail("Error initializing source and destination buffers.")
//    }
//
//    defer {
//      sourceBuffer.free()
//      rgbDestinationBuffer.free()
//    }
//  }

}
