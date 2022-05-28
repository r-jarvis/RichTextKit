//
//  RichTextCoordinator+Subscriptions.swift
//  OribiRichTextKit
//
//  Created by Daniel Saidi on 2021-12-06.
//  Copyright © 2021 Oribi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI

extension RichTextCoordinator {

    func subscribeToContextChanges() {
        subscribeToIsUnderlined()
    }
}

private extension RichTextCoordinator {

    func subscribeToIsUnderlined() {
        context.$isUnderlined
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setIsUnderlined(to: $0) })
            .store(in: &cancellables)
    }
}

private extension RichTextCoordinator {

    func setIsUnderlined(to newValue: Bool) {
        let range = textView.selectedRange
        let styles = textView.richTextStyles(at: range)
        let isUnderlined = styles.hasStyle(.underlined)
        if newValue == isUnderlined { return }
        textView.setRichTextStyle(.underlined, to: newValue, at: range)
    }
}
#endif
