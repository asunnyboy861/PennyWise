//
//  PennyWiseWidgetBundle.swift
//  PennyWiseWidget
//
//  Created by MacMini4 on 2026/3/15.
//

import WidgetKit
import SwiftUI

@main
struct PennyWiseWidgetBundle: WidgetBundle {
    var body: some Widget {
        PennyWiseWidget()
        PennyWiseWidgetControl()
        PennyWiseWidgetLiveActivity()
    }
}
