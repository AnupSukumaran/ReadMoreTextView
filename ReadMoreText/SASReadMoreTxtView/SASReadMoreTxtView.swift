//
//  SASReadMoreTxtView.swift
//  ReadMoreText
//
//  Created by Manu Puthoor on 20/07/20.
//  Copyright © 2020 Manu Puthoor. All rights reserved.
//

import UIKit

@objc public protocol TextViewTapActionProtocol: class {
    func tapAction()
}

@IBDesignable
public class SASReadMoreTxtView: UITextView {
    
    private var cachedIntrinsicContentHeight: CGFloat?
    
    
    @IBOutlet weak var readMoreDelegate: TextViewTapActionProtocol?
    
    
    @IBInspectable
    public var shouldTrim: Bool = false {
        didSet {
            guard shouldTrim != oldValue else { return }
            
            if shouldTrim {
                maximumNumberOfLines = _originalMaximumNumberOfLines
            } else {
                let _maximumNumberOfLines = maximumNumberOfLines
                maximumNumberOfLines = 0
                _originalMaximumNumberOfLines = _maximumNumberOfLines
            }
            cachedIntrinsicContentHeight = nil
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var maximumNumberOfLines: Int = 0 {
        didSet {
            _originalMaximumNumberOfLines = maximumNumberOfLines
            setNeedsLayout()
        }
    }
    
    /**The text to trim the original text. Setting this property resets `attributedReadMoreText`.*/
    @IBInspectable
    public var readMoreText: String? {
        get {
            return attributedReadMoreText?.string
        }
        set {
            if let text = newValue {
                attributedReadMoreText = attributedStringWithDefaultAttributes(from: text)
            } else {
                attributedReadMoreText = nil
            }
        }
    }
    
    private var _originalMaximumNumberOfLines: Int = 0
    public var readMoreTextPadding: UIEdgeInsets
    private var _originalAttributedText: NSAttributedString!
    private var _needsUpdateTrim = false
    
    private var _originalTextLength: Int {
       get {
           return _originalAttributedText?.string.length ?? 0
       }
    }
    
    public var attributedReadMoreText: NSAttributedString? {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        readMoreTextPadding = .zero
        //readLessTextPadding = .zero
        super.init(frame: frame, textContainer: textContainer)
        setupDefaults()
    }
    
    
    public convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        readMoreTextPadding = .zero
        //readLessTextPadding = .zero
        super.init(coder: coder)
        setupDefaults()
    }
    
    public override func layoutSubviews() {
       super.layoutSubviews()
       
       if _needsUpdateTrim {
           //reset text to force update trim
           attributedText = _originalAttributedText
           _needsUpdateTrim = false
       }
       
       needsTrim() ? showLessText() : showMoreText()
    }
    
    public override var text: String! {
        didSet {
            if let text = text {
                _originalAttributedText = attributedStringWithDefaultAttributes(from: text)
            } else {
                _originalAttributedText = nil
            }
        }
    }
    
    public override var attributedText: NSAttributedString! {
        willSet {
            if #available(iOS 9.0, *) { return }
            //on iOS 8 text view should be selectable to properly set attributed text
            if newValue != nil {
                isSelectable = true
            }
        }
        didSet {
            _originalAttributedText = attributedText
        }
    }
    
   
    
    
    public override var intrinsicContentSize : CGSize {
        textContainer.size = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        var intrinsicContentSize = layoutManager.boundingRect(forGlyphRange: layoutManager.glyphRange(for: textContainer), in: textContainer).size
        intrinsicContentSize.width = UIView.noIntrinsicMetric
        intrinsicContentSize.height += (textContainerInset.top + textContainerInset.bottom)
        intrinsicContentSize.height = ceil(intrinsicContentSize.height)
        return intrinsicContentSize
    }
    
    
    func setupDefaults() {
        let defaultReadMoreText = NSLocalizedString("ReadMoreTextView.readMore", value: "more", comment: "")
        let attributedReadMoreText = NSMutableAttributedString(string: "... ")

        readMoreTextPadding = .zero
        //readLessTextPadding = .zero
        isScrollEnabled = false
        isEditable = false
        
        let attributedDefaultReadMoreText = NSAttributedString(string: defaultReadMoreText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14)
        ])
        attributedReadMoreText.append(attributedDefaultReadMoreText)
        self.attributedReadMoreText = attributedReadMoreText
    }
        
    private func attributedStringWithDefaultAttributes(from text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: textColor ?? UIColor.black
        ])
    }
    
    private func needsTrim() -> Bool {
        return shouldTrim && readMoreText != nil
    }
    
    private func showLessText() {
        if let readMoreText = readMoreText, text.hasSuffix(readMoreText) { return }
        
        shouldTrim = true
        textContainer.maximumNumberOfLines = maximumNumberOfLines
        let nsRange =  layoutManager.characterRangeThatFits(textContainer: textContainer)
        layoutManager.invalidateLayout(forCharacterRange: nsRange, actualCharacterRange: nil)
       
        textContainer.size = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)

        if let text = attributedReadMoreText {
            let range = rangeToReplaceWithReadMoreText()
            guard range.location != NSNotFound else { return }

            textStorage.replaceCharacters(in: range, with: text)
        }

        invalidateIntrinsicContentSize()
        //invokeOnSizeChangeIfNeeded()
    }
    
    private func showMoreText() {
        //if  text.hasSuffix(readLessText) { return }
        
        shouldTrim = false
        textContainer.maximumNumberOfLines = 0

        if let originalAttributedText = _originalAttributedText?.mutableCopy() as? NSMutableAttributedString {
            attributedText = _originalAttributedText
//            let range = NSRange(location: 0, length: text.length)
//            if let attributedReadLessText = attributedReadLessText {
//                originalAttributedText.append(attributedReadLessText)
//            }
            //textStorage.replaceCharacters(in: range, with: originalAttributedText)
        }
        
        invalidateIntrinsicContentSize()
       // invokeOnSizeChangeIfNeeded()
    }
    
    private func rangeToReplaceWithReadMoreText() -> NSRange {
        let rangeThatFitsContainer = layoutManager.characterRangeThatFits(textContainer: textContainer)
        if NSMaxRange(rangeThatFitsContainer) == _originalTextLength {
            return NSMakeRange(NSNotFound, 0)
        }
        else {
            let lastCharacterIndex = characterIndexBeforeTrim(range: rangeThatFitsContainer)
            if lastCharacterIndex > 0 {
                return NSMakeRange(lastCharacterIndex, textStorage.string.length - lastCharacterIndex)
            }
            else {
                return NSMakeRange(NSNotFound, 0)
            }
        }
    }
    
    private func characterIndexBeforeTrim(range rangeThatFits: NSRange) -> Int {
        if let text = attributedReadMoreText {
            let readMoreBoundingRect = attributedReadMoreText(text: text, boundingRectThatFits: textContainer.size)
            let lastCharacterRect = layoutManager.boundingRectForCharacterRange(range: NSMakeRange(NSMaxRange(rangeThatFits)-1, 1), inTextContainer: textContainer)
            var point = lastCharacterRect.origin
            point.x = textContainer.size.width - ceil(readMoreBoundingRect.size.width)
            let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer, fractionOfDistanceThroughGlyph: nil)
            let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
            return characterIndex - 1
        } else {
            return NSMaxRange(rangeThatFits) - readMoreText!.length
        }
    }
    
    private func attributedReadMoreText(text aText: NSAttributedString, boundingRectThatFits size: CGSize) -> CGRect {
        let textContainer = NSTextContainer(size: size)
        let textStorage = NSTextStorage(attributedString: aText)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        let readMoreBoundingRect = layoutManager.boundingRectForCharacterRange(range: NSMakeRange(0, text.length), inTextContainer: textContainer)
        return readMoreBoundingRect
    }
    
    //MARK: Action Part
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        readMoreDelegate?.tapAction()
        return self
    }
    
}
