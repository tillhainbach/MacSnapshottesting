import SnapshotTesting
import SwiftUI
import XCTest
@testable import MacSnapshottesting

final class MacSnapshottestingTests: XCTestCase {
  func testExample() throws {
    let view = MacSnapshottesting()

    assertSnapshot(matching: view, as: .image)

  }
}

extension Snapshotting where Value: SwiftUI.View, Format == NSImage {
  static var image: Self {
    Snapshotting<NSView, NSImage>.image()
      .pullback { swiftUIView in
        let controller = NSHostingController(rootView: swiftUIView)
        let view = controller.view
        view.window?.colorSpace = .genericCMYK
        view.frame.size = .init(width: 500, height: 300)
        view.window?.convertToBacking(view.frame)
        view.window?.backgroundColor = .darkGray


        return view
      }
  }

}
