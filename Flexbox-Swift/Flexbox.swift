//
//  Flexbox.swift
//  Flexbox-Swift
//
//  Created by Jerry on 2018/5/22.
//  Copyright © 2018年 com.jerry. All rights reserved.
//

class Flexbox {
    
    var debugTag: String?
    
    init(delegate: FlexboxDelegate) {
        self.delegate = delegate
    }
    
    func layout(_ items: [FlexboxItem], size: FlexboxSize, isMeasuring: Bool = false) -> [FlexboxItem] {
        
        Logger.debugLog(tag: debugTag, msg: "begin to \(isMeasuring ? "measure" : "layout") \(debugTag ?? "")")
        
        let intermediate = FlexboxIntermediate(direction: flexDirection, alignItems: alignItems, alignContent:alignContent, wrap: flexWrap, justifyContent: justifyContent, containerDimension: size, debugTag: debugTag, isMeasuring: isMeasuring)
        let ret = intermediate.layout(items)
        
        Logger.debugLog(tag: debugTag, msg: "layout end \(ret)")
        intrinsicSize = intermediate.intrinsicSize
        return ret
    }
    
    var flexFlow:(direction: Direction, wrap: Wrap) {
        get {
            return (flexDirection, flexWrap)
        }
        
        set {
            flexDirection = newValue.direction
            flexWrap = newValue.wrap
        }
    }
    
    weak var delegate: FlexboxDelegate?
    
    private(set) var intrinsicSize = FlexboxSize.zero {
        didSet {
            if oldValue != intrinsicSize {
                delegate?.invalidateIntrinsicContentSize()
            }
        }
    }
    
    var flexDirection = Direction.row {
        didSet {
            if oldValue != flexDirection {
                delegate?.setNeedsLayout()
            }
        }
    }
    
    var flexWrap = Wrap.nowrap {
        didSet {
            if oldValue != flexWrap {
                delegate?.setNeedsLayout()
            }
        }
    }
    
    var justifyContent = JustifyContent.start {
        didSet {
            if oldValue != justifyContent {
                delegate?.setNeedsLayout()
            }
        }
    }
    
    var alignItems = AlignItems.stretch {
        didSet {
            if oldValue != alignItems {
                delegate?.setNeedsLayout()
            }
        }
    }
    
    var alignContent = AlignContent.stretch {
        didSet {
            if oldValue != alignContent {
                delegate?.setNeedsLayout()
            }
        }
    }
    
    enum Direction {
        
        case row
        
        case rowReverse
        
        case column
        
        case columnReverse
        
    }
    
    enum Wrap {
        
        case nowrap
        
        case wrap
        
        case wrapReverse
        
        var isWrapEnabled: Bool {
            get {
                return self != .nowrap
            }
        }
    }
    
    enum JustifyContent {
        
        case start
        
        case end
        
        case center
        
        case spaceBetween
        
        case spaceAround
        
    }
    
    enum AlignItems {
        
        case start
        
        case end
        
        case center
        
        @available(*, unavailable)
        case baseline
        
        case stretch
        
    }
    
    enum AlignContent {
        
        case start
        
        case end
        
        case center
        
        case spaceBetween
        
        case spaceAround
        
        case stretch
        
    }
    
    enum AlignSelf {
        
        case auto
        
        case start
        
        case end
        
        case center
        
        @available(*, unavailable)
        case baseline
        
        case stretch
        
        func toAlignItems() -> AlignItems? {
            switch self {
            case .auto: return nil
            case .start: return .start
            case .end: return .end
            case .center: return .center
            case .stretch: return .stretch
            default: return nil
            }
        }
    }
    
    struct Context {
        
        private static var mDirection = Direction.row
        
        static var direction: Direction {
            get {
                return mDirection
            }
            
            set {
                mDirection = newValue
            }
        }
    }
    
    struct Logger {
        
        #if DEBUG
        private static var tags =  Set<String>()
        #endif
        
        static func addDebugTag(_ tag: String) {
            #if DEBUG
                tags.insert(tag)
            #endif
        }
        
        static func debugLog(tag: String?, msg: @autoclosure () -> String) {
            #if DEBUG
                if let tag = tag, tags.contains(tag) {
                    print("<-----", msg(), "----->")
                }
            #endif
        }
    }
    
    static let dimensionThreshold = Float(0.5)
}

protocol FlexboxDelegate: class {
    
    func setNeedsLayout()
    
    func invalidateIntrinsicContentSize()
}
