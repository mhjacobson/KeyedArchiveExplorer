//
//  KAEDocument.swift
//  KeyedArchiveExplorer
//
//  Created by Matt Jacobson on 9/15/18.
//  Copyright © 2018 Matt Jacobson. All rights reserved.
//

import Cocoa

class KAEDocument: NSDocument {
	var objects: Array<Any>!
	var topItems: Array<KAEItem>!

	@IBOutlet weak var outlineView: NSOutlineView?

	override class var autosavesInPlace: Bool {
		return false
	}

	override var windowNibName: NSNib.Name? {
		return NSNib.Name("KAEDocument")
	}

	override func data(ofType typeName: String) throws -> Data {
		fatalError()
	}

	override var isInViewingMode: Bool {
		return true
	}

	override func read(from data: Data, ofType typeName: String) throws {
		let plist = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)

		guard let dictionary = plist as? NSDictionary else {
			fatalError("nope")
		}

		let top = dictionary["$top"] as! Dictionary<String, Any>
		topItems = top.map { (key, value) in
			return KAEItem(key: key, value: value, document: self)
		}

		objects = (dictionary["$objects"] as! Array<Any>)

		outlineView?.reloadData()
	}
}

extension KAEDocument {
	func objectForUID(_ uid: CFKeyedArchiverUID) -> Any {
		return objects[uid.intValue]
	}
}

extension KAEDocument: NSOutlineViewDataSource {
	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		guard let item = item as? KAEItem else {
			fatalError()
		}

		return item.subitems.count > 0
	}

	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		if topItems != nil && objects != nil {
			if item == nil {
				return topItems.count
			} else {
				guard let item = item as? KAEItem else {
					fatalError()
				}

				return item.subitems.count
			}
		} else {
			return 0
		}
	}

	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		if item == nil {
			return topItems[index]
		} else {
			guard let item = item as? KAEItem else {
				fatalError()
			}

			return item.subitems[index]
		}
	}

	func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
		return item
	}
}

