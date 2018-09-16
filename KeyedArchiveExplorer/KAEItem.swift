//
//  KAEItem.swift
//  KeyedArchiveExplorer
//
//  Created by Matt Jacobson on 9/15/18.
//  Copyright © 2018 Matt Jacobson. All rights reserved.
//

import Foundation

// This is an NSObject in order to support KVO/KVC for bindings.
class KAEItem: NSObject {
	private let key: String
	private let value: Any
	private unowned var document: KAEDocument

	init(key: String, value: Any, document: KAEDocument) {
		self.key = key
		self.value = value
		self.document = document
	}

	@objc var keyDescription: String {
		return key
	}

	@objc lazy var typeDescription: String = {
		if let uid = CFKeyedArchiverUID(value) {
			// It's a reference.  See if it's a reference to an object or a value type.
			let referent = document.objectForUID(uid)

			if let dictionary = referent as? Dictionary<String, Any> {
				// Object.  Return $classname.
				let classUID = CFKeyedArchiverUID(dictionary["$class"]!)!
				let classDictionary = document.objectForUID(classUID) as! Dictionary<String, Any>
				let className = classDictionary["$classname"] as! String

				return className
			} else if let nsObject = value as? NSObject {
				// Reference to NSObject directly.
				return NSStringFromClass(type(of: nsObject))
			} else {
				return "unknown reference"
			}
		} else if value is NSArray {
			return "array data"
		} else if let nsObject = value as? NSObject {
			// NSObject directly.
			return NSStringFromClass(type(of: nsObject))
		} else {
			return "unknown value type"
		}
	}()

	@objc lazy var valueDescription: String = {
		if let uid = CFKeyedArchiverUID(value) {
			// It's a reference.  See if it's a reference to an object or to a value type.
			let referent = document.objectForUID(uid)

			if referent is Dictionary<String, Any> {
				return "object (uid \(uid.intValue))"
			} else if let nsObject = referent as? NSObject {
				// Reference to NSObject directly.  Return its description.
				return nsObject.description.replacingOccurrences(of: "\n", with: "")
			} else {
				return "unknown reference"
			}
		} else if let nsArray = value as? NSArray {
			return "array data with \(nsArray.count) items"
		} else if let nsObject = value as? NSObject {
			// NSObject directly.
			return nsObject.description
		} else {
			return "unknown value type"
		}
	}()

	lazy var subitems: [KAEItem] = {
		if let uid = CFKeyedArchiverUID(value) {
			let referent = document.objectForUID(uid)

			if let dictionary = referent as? Dictionary<String, Any> {
				return dictionary.compactMap({ (key, value) in
					if key != "$classname" && key != "$classes" && key != "$class" {
						return KAEItem(key: key, value: value, document: document)
					} else {
						return nil
					}
				})
			}
		} else if let nsArray = value as? NSArray {
			return nsArray.enumerated().map({ (index, arrayObject) in
				return KAEItem(key: "\(index)", value: arrayObject, document: document)
			})
		}

		return []
	}()
}
