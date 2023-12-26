//
//  WebView.swift
//  gameAttack
//
//  Created by test on 2023/12/27.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }

    func updateUIView(_ view: WKWebView, context: UIViewRepresentableContext<WebView>) {

        let request = URLRequest(url: URL(string: "https://danziger.github.io/slotjs/")!)

        view.load(request)
    }
}

#Preview {
    WebView()
}
