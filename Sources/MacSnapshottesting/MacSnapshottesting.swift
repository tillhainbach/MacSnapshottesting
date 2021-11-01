import SwiftUI

struct MacSnapshottesting: View {

  var body: some View {
    Text("My Test View")
  }
}

struct MacSnapshottesting_Previews: PreviewProvider {

  static var previews: some View {
    MacSnapshottesting()
      .frame(width: 500, height: 300)
      .background(Color(NSColor.windowBackgroundColor))
  }
}
