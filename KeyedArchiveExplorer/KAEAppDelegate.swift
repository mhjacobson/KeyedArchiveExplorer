//
//  KAEAppDelegate.swift
//  KeyedArchiveExplorer
//
//  Created by Matt Jacobson on 9/15/18.
//  Copyright © 2018 Matt Jacobson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class KAEAppDelegate: NSObject, NSApplicationDelegate {
	func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
		return false
	}
}

