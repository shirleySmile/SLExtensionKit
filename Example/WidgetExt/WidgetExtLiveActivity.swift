//
//  WidgetExtLiveActivity.swift
//  WidgetExt
//
//  Created by muwa on 2025/9/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetExtAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetExtLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetExtAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetExtAttributes {
    fileprivate static var preview: WidgetExtAttributes {
        WidgetExtAttributes(name: "World")
    }
}

extension WidgetExtAttributes.ContentState {
    fileprivate static var smiley: WidgetExtAttributes.ContentState {
        WidgetExtAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetExtAttributes.ContentState {
         WidgetExtAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetExtAttributes.preview) {
   WidgetExtLiveActivity()
} contentStates: {
    WidgetExtAttributes.ContentState.smiley
    WidgetExtAttributes.ContentState.starEyes
}
