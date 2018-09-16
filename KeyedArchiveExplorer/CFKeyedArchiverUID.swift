//
//  CFKeyedArchiverUID.swift
//  KeyedArchiveExplorer
//
//  Created by Matt Jacobson on 9/15/18.
//  Copyright © 2018 Matt Jacobson. All rights reserved.
//

struct CFKeyedArchiverUID {
	private let uidRef: CFKeyedArchiverUIDRef

	init?(_ object: Any) {
		if CFGetTypeID(object as AnyObject) == _CFKeyedArchiverUIDGetTypeID() {
			self.uidRef = unsafeBitCast((object as AnyObject), to: CFKeyedArchiverUIDRef.self)
		} else {
			return nil
		}
	}

	var intValue: Int {
		return Int(_CFKeyedArchiverUIDGetValue(uidRef))
	}
}
