import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false

    var body: some View {
        if isActive {
            // Navigate to the main ContentView once the splash screen is done
            ContentView()
        } else {
            ZStack {
                // Static background gradient
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color("primaryLightPink"), location: 0.0),
                        .init(color: Color("secondaryYellow"), location: 0.5),
                        .init(color: Color("primaryLightPink"), location: 1.0)
                    ]),
                    startPoint: .top, endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                // PiggyPal image at the center
                VStack {
                    Spacer()
                    Image("Piggy_Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                    Spacer()
                }
            }
            .onAppear {
                // Delay for 2 seconds before navigating to the main content
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
