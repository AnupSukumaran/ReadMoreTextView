//
//  NSLayoutManager+Ext.swift
//  ReadMoreText
//
//  Created by Manu Puthoor on 20/07/20.
//  Copyright © 2020 Manu Puthoor. All rights reserved.
//

import UIKit

extension NSLayoutManager {
    
    /**
     Returns characters range that completely fits into container.
     */
    public func characterRangeThatFits(textContainer container: NSTextContainer) -> NSRange {
        var rangeThatFits = self.glyphRange(for: container)
        rangeThatFits = self.characterRange(forGlyphRange: rangeThatFits, actualGlyphRange: nil)
        return rangeThatFits
    }
    
    /**
     Returns bounding rect in provided container for characters in provided range.
     */
    public func boundingRectForCharacterRange(range aRange: NSRange, inTextContainer container: NSTextContainer) -> CGRect {
        let glyphRange = self.glyphRange(forCharacterRange: aRange, actualCharacterRange: nil)
        let boundingRect = self.boundingRect(forGlyphRange: glyphRange, in: container)
        return boundingRect
    }
    
}
