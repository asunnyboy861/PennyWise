//
//  PennyWiseWidgetLiveActivity.swift
//  PennyWiseWidget
//
//  Created by MacMini4 on 2026/3/15.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PennyWiseWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PennyWiseWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PennyWiseWidgetAttributes.self) { context in
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

extension PennyWiseWidgetAttributes {
    fileprivate static var preview: PennyWiseWidgetAttributes {
        PennyWiseWidgetAttributes(name: "World")
    }
}

extension PennyWiseWidgetAttributes.ContentState {
    fileprivate static var smiley: PennyWiseWidgetAttributes.ContentState {
        PennyWiseWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PennyWiseWidgetAttributes.ContentState {
         PennyWiseWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PennyWiseWidgetAttributes.preview) {
   PennyWiseWidgetLiveActivity()
} contentStates: {
    PennyWiseWidgetAttributes.ContentState.smiley
    PennyWiseWidgetAttributes.ContentState.starEyes
}
