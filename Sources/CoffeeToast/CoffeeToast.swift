import SwiftUI

/** Creates a Toast Notification

  - Parameters:
   - isShown: The boolean variable that triggers if the notification is shown
   - text: Text the notification is supposed to show
   - duration: How long is the notification supposed to show before dismissing
   - foregroundColor: The color of the text. This is optional and defaults to `Color.white`
   - backgroundColor: Background color of the notification and defaults to `Color.red`
*/
public struct Toast<Content: View>: View {
    @Binding var isShown: Bool

    var text: String
    var duration: Double
    var foregroundColor: Color
    var backgroundColor: Color

    private let content: Content

    public init(_ text: String,
                duration: Double = 2.0,
                foregroundColor: Color = .white,
                backgroundColor: Color = .red,
                isShown: Binding<Bool>,
                @ViewBuilder content: () -> Content) {
        self._isShown = isShown
        self.text = text
        self.duration = duration
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    public var body: some View {
        ZStack {
            content
            VStack {
                Spacer()
                Text(text)
                    .padding()
                    .background(backgroundColor)
                    .foregroundColor(foregroundColor)
                    .cornerRadius(10.0)
                    .offset(x: 0, y: isShown ? -10 : 100)
                    .animation(.default, value: isShown)
                    .onChange(of: isShown) { newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            self.isShown = false
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Toast("TOAST NOTIFICATION", isShown: .constant(true)) {
            Text("This is my awesome content")
        }
    }
}
