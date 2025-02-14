//
//  Bundle+RichTextKit.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-08-21.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

extension Bundle {

    /**
     The name of the package bundle, which may change in new
     Xcode versions.

     If the Xcode name convention changes, you can print the
     path like this and look for the bundle name in the text:

     ```
     Bundle(for: BundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
     ```
     */
    static let richTextKitBundleName = "RichTextKit_RichTextKit"

    /**
     This bundle lets us use resources from RichTextKit.

     Hopefully, Apple will fix this bundle bug to remove the
     need for this workaround.

     Inspiration from here:
     https://developer.apple.com/forums/thread/664295
     https://dev.jeremygale.com/swiftui-how-to-use-custom-fonts-and-images-in-a-swift-package-cl0k9bv52013h6bnvhw76alid
     */
    public static let richTextKit: Bundle = {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,
            // For command-line tools.
            Bundle.main.bundleURL,
            // Bundle should be present here when running previews from a different package
            // (this is the path to "…/Debug-iphonesimulator/").
            Bundle(for: BundleFinder.self)
                .resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent(),
            Bundle(for: BundleFinder.self)
                .resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent()
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(richTextKitBundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("Can't find custom bundle. See Bundle+RichTextKit.swift")
    }()

    func bundle(for locale: Locale) -> Bundle? {
        guard let bundlePath = bundlePath(for: locale) else { return nil }
        return Bundle(path: bundlePath)
    }

    func bundlePath(for locale: Locale) -> String? {
        if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
            bundlePath(named: locale.identifier) ?? bundlePath(named: locale.language.languageCode?.identifier)
        } else {
            bundlePath(named: locale.identifier) ?? bundlePath(named: locale.languageCode)
        }
    }

    func bundlePath(named name: String?) -> String? {
        path(forResource: name ?? "", ofType: "lproj")
    }
}

private extension Bundle {

    class BundleFinder {}
}
