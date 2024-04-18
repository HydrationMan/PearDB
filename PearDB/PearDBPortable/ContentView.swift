//
//  ContentView.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 18/01/24.
//

import SwiftUI

extension Color {
    static let PearCyan = Color("PearCyan")
}

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                TabView() {
                    HomeScreen()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    DeviceScreen()
                        .tabItem {
                            Label("Devices", systemImage: "archivebox")
                        }
                    SettingsScreen()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                }
            }
        }
        .compositingGroup()
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterialDark
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

extension View {
    func BackgroundBlurEffect() -> some View {
        self.background(BlurView())
    }
    
}

@available(iOS, introduced: 13, deprecated: 15, message: "Use .safeAreaInset() directly")
extension View {
  @ViewBuilder
  func bottomSafeAreaInset<OverlayContent: View>(_ overlayContent: OverlayContent) -> some View {
    if #available(iOS 15.0, *) {
      self.safeAreaInset(edge: .bottom, spacing: 0, content: { overlayContent })
    } else {
      self.modifier(BottomInsetViewModifier(overlayContent: overlayContent))
    }
  }
}

extension View {
  func readHeight(onChange: @escaping (CGFloat) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Spacer()
          .preference(
            key: HeightPreferenceKey.self,
            value: geometryProxy.size.height
          )
      }
    )
    .onPreferenceChange(HeightPreferenceKey.self, perform: onChange)
  }
}

private struct HeightPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct BottomInsetViewModifier<OverlayContent: View>: ViewModifier {
  @Environment(\.bottomSafeAreaInset) var ancestorBottomSafeAreaInset: CGFloat
  var overlayContent: OverlayContent
  @State var overlayContentHeight: CGFloat = 0

  func body(content: Self.Content) -> some View {
    content
      .environment(\.bottomSafeAreaInset, overlayContentHeight + ancestorBottomSafeAreaInset)
      .overlay(
        overlayContent
          .readHeight {
            overlayContentHeight = $0
          }
          .padding(.bottom, ancestorBottomSafeAreaInset)
        ,
        alignment: .bottom
      )
  }
}

struct BottomSafeAreaInsetKey: EnvironmentKey {
  static var defaultValue: CGFloat = 0
}

extension EnvironmentValues {
  var bottomSafeAreaInset: CGFloat {
    get { self[BottomSafeAreaInsetKey.self] }
    set { self[BottomSafeAreaInsetKey.self] = newValue }
  }
}

struct ExtraBottomSafeAreaInset: View {
  @Environment(\.bottomSafeAreaInset) var bottomSafeAreaInset: CGFloat

  var body: some View {
    Spacer(minLength: bottomSafeAreaInset)
  }
}

public extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()
}

class RemoteImageLoader: ObservableObject {
    @Published var data: Data = Data()
    init(imageURL: URL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async { self.data = data }
            }
        .resume()
        
    }
}
struct URLImage: View {
    @ObservedObject var remoteImageLoader: RemoteImageLoader
    init(_ imageUrl: URL) {
        remoteImageLoader = RemoteImageLoader(imageURL: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: UIImage(data: remoteImageLoader.data) ?? UIImage())
            .resizable()
            .renderingMode(.original)
    }
}

func buildNumber() -> String {
    var size = 0
    sysctlbyname("kern.osversion", nil, &size, nil, 0)
    var version = [CChar](repeating: 0,  count: size)
    sysctlbyname("kern.osversion", &version, &size, nil, 0)
    return String(cString: version)
}

