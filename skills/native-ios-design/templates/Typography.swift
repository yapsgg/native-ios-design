import SwiftUI
import UIKit

/// The app's type scale, in one place.
///
/// Every style is a system text style, so text scales with Dynamic Type and Bold Text and keeps the system's
/// leading and tracking. Styles never go below Caption 1 for reading text and never use Ultralight, Thin, or Light.
///
/// Name styles by role, not by size, and add a new role here rather than writing `.font(.subheadline)` in a view.
/// Rename and prune these roles to fit the app.
extension Font {
    // MARK: Titles

    /// The name on a detail screen.
    static let detailTitle = Font.title2.bold()
    /// A title in a custom toolbar control.
    static let toolbarTitle = Font.headline

    // MARK: Lists

    /// The main line of a list row.
    static let rowTitle = Font.headline
    /// The secondary line of a list row, like a preview.
    static let rowSubtitle = Font.subheadline
    /// Trailing metadata in a row, like a timestamp.
    static let rowDetail = Font.subheadline

    // MARK: Reading

    /// Body text, like messages or articles.
    static let bodyText = Font.body
    /// A short note under content, like a timestamp header.
    static let note = Font.footnote

    // MARK: Cards and labels

    /// The main line of a card.
    static let cardTitle = Font.body.weight(.medium)
    /// Supporting text in a card.
    static let cardDetail = Font.subheadline
    /// A small heading above a group of content.
    static let sectionLabel = Font.subheadline.weight(.semibold)
    /// The label of a large, full-width button.
    static let buttonLabel = Font.headline
    /// Counts and tags in capsules. Cap the badge at `.accessibility1`.
    static let badge = Font.caption.weight(.semibold)
    /// Machine-readable identifiers. Pair with `.truncationMode(.middle)`.
    static let identifier = Font.subheadline.monospaced()

    // MARK: Symbols
    // SF Symbols take their size and weight from the font, so these scale with Dynamic Type too.

    /// A prominent standalone symbol, like a floating plus button.
    static let symbolLarge = Font.title3
    /// A symbol inside a control, like a chevron or checkmark.
    static let symbol = Font.body.weight(.semibold)
    /// A symbol on a filled button, like Send.
    static let symbolEmphasized = Font.body.weight(.bold)
    /// The smallest symbol, on a compact badge in a corner.
    static let symbolTiny = Font.caption2.weight(.heavy)
}

extension UIFont {
    /// `Font.bodyText` for UIKit text views. Set `adjustsFontForContentSizeCategory` so it follows Dynamic Type.
    static var bodyText: UIFont {
        .preferredFont(forTextStyle: .body)
    }

    /// Semibold body text that still scales, for styled runs like mentions.
    static var bodyTextSemibold: UIFont {
        let semibold = bodyText.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]])
        return UIFont(descriptor: semibold, size: 0)
    }
}

#Preview("Type scale") {
    List {
        Text("Detail title").font(.detailTitle)
        Text("Row title").font(.rowTitle)
        Text("Row subtitle").font(.rowSubtitle)
        Text("Body text that wraps onto a second line to show leading.").font(.bodyText)
        Text("Section label").font(.sectionLabel)
        Text("model/identifier-name").font(.identifier)
    }
}

#Preview("Largest size") {
    List {
        Text("Row title").font(.rowTitle)
        Text("Body text that wraps onto several lines at this size.").font(.bodyText)
    }
    .environment(\.dynamicTypeSize, .accessibility5)
}
