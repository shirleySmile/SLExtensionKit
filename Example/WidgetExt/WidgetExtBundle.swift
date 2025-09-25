//
//  WidgetExtBundle.swift
//  WidgetExt
//
//  Created by muwa on 2025/9/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtBundle: WidgetBundle {
    var body: some Widget {
        WidgetExt()
        WidgetExtControl()
        WidgetExtLiveActivity()
    }
}
