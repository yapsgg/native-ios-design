import SwiftUI
import UIKit

/// The app's colors, in one place.
///
/// Prefer system colors, which already adapt to Dark Mode and Increase Contrast. Status text colors are darker in
/// light mode because system orange, green, and blue text measure about 2:1 to 3.4:1 on white, under the 4.5:1
/// minimum; in Dark Mode the system colors pass. Rename and prune these roles to fit the app.
extension Color {
    // MARK: Surfaces

    /// Cards and incoming content.
    static let surface = Color(uiColor: .secondarySystemBackground)
    /// Text fields and other inputs drawn on a surface.
    static let fieldFill = Color(uiColor: .tertiarySystemFill)
    /// The user's own content, like sent messages: black in light mode, raised gray in Dark Mode. Text on it is white.
    static let ownContent = Color(light: .black, dark: UIColor(white: 0.27, alpha: 1))
    /// The near-black square behind a tinted icon tile, in both appearances.
    static let iconTile = Color(white: 0.1)
    /// The hairline around a tinted icon tile, so it keeps its edge on black.
    static let iconTileBorder = Color.white.opacity(0.14)

    // MARK: Status text

    /// Something done or added.
    static let success = Color(light: UIColor(red: 0.11, green: 0.45, blue: 0.19, alpha: 1), dark: .systemGreen)
    /// Something that needs attention.
    static let warning = Color(light: UIColor(red: 0.64, green: 0.29, blue: 0, alpha: 1), dark: .systemOrange)
    /// Neutral information.
    static let info = Color(light: UIColor(red: 0, green: 0.35, blue: 0.72, alpha: 1), dark: .systemBlue)

    /// A color that switches with the appearance.
    init(light: UIColor, dark: UIColor) {
        self.init(uiColor: UIColor { $0.userInterfaceStyle == .dark ? dark : light })
    }
}

#Preview("Colors") {
    VStack(alignment: .leading, spacing: 12) {
        Text("Sent").foregroundStyle(.white).padding(10).background(Color.ownContent, in: .rect(cornerRadius: 16))
        Text("Received").padding(10).background(Color.surface, in: .rect(cornerRadius: 16))
        Text("Field").padding(10).frame(maxWidth: .infinity).background(Color.fieldFill, in: .rect(cornerRadius: 16))
        Label("Added", systemImage: "checkmark").foregroundStyle(Color.success)
        Label("Needs your approval", systemImage: "hand.raised.fill").foregroundStyle(Color.warning)
        Label("Info", systemImage: "info.circle").foregroundStyle(Color.info)
    }
    .padding()
}
