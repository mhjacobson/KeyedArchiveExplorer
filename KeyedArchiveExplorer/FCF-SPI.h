//
//  FCF-SPI.h
//  KeyedArchiveExplorer
//
//  Created by Matt Jacobson on 9/15/18.
//  Copyright © 2018 Matt Jacobson. All rights reserved.
//

#import <stdint.h>
#import <CoreFoundation/CoreFoundation.h>

// Below excerpted from swift-corelibs-foundation/CoreFoundation/Base.subproj/ForSwiftFoundationOnly.h @ b610bd5605.

// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

typedef const struct __CFKeyedArchiverUID *CFKeyedArchiverUIDRef;
extern CFTypeID _CFKeyedArchiverUIDGetTypeID(void);
extern uint32_t _CFKeyedArchiverUIDGetValue(CFKeyedArchiverUIDRef uid);
