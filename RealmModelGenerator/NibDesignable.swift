import Cocoa

public protocol NibDesignableProtocol: NSObjectProtocol {
    /**
     Identifies the view that will be the superview of the contents loaded from
     the Nib. Referenced in setupNib().
     
     - returns: Superview for Nib contents.
     */
    var nibContainerView: NSView { get }
    // MARK: - Nib loading
    
    /**
    Called to load the nib in setupNib().
    
    - returns: NSView instance loaded from a nib file.
    */
    func loadNib() -> NSView
    /**
     Called in the default implementation of loadNib(). Default is class name.
     
     - returns: Name of a single view nib file.
     */
    func nibName() -> String
    
    func nibDidLoad()
    
    var nibLoaded:Bool {get set}
}

extension NibDesignableProtocol {
    // MARK: - Nib loading
    
    /**
    Called to load the nib in setupNib().
    
    - returns: NSView instance loaded from a nib file.
    */
    public func loadNib() -> NSView {
        let bundle = Bundle(for: type(of: self))
        let nib = NSNib(nibNamed: self.nibName(), bundle: bundle)
        var objects:NSArray?
        nib!.instantiate(withOwner: self, topLevelObjects: &objects!)
        return objects?.filter({$0 is NSView}).first as! NSView
    }
    
    // MARK: - Nib loading
    
    /**
    Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
    */
    // find better access modifier than public or private
    public func setupNib() {
        let view = self.loadNib()
        self.nibContainerView.addSubview(view)
        view.matchParent()
        nibLoaded = true
        nibDidLoad()
    }
}

extension NSView {
    public var nibContainerView: NSView {
        return self
    }
    /**
     Called in the default implementation of loadNib(). Default is class name.
     
     - returns: Name of a single view nib file.
     */
    public func nibName() -> String {
        return String(type(of: self).description().split(separator: ".").last!)//.componentsSeparatedByString(".").last!
    }
    
    public func nibDidLoad() {}
    
    // find better access modifier than public or private
    public func matchParent() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": self]
        self.superview!.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
        self.superview!.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
    }
}

@IBDesignable
public class NibDesignableView: NSView, NibDesignableProtocol {
    
    private(set) var isInterfaceBuilder:Bool = false
    public var nibLoaded:Bool = false
    
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.isInterfaceBuilder = true
    }
}

@IBDesignable
public class NibDesignableTableCellView: NSTableCellView, NibDesignableProtocol {
    
    private(set) var isInterfaceBuilder:Bool = false
    public var nibLoaded:Bool = false
    
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.isInterfaceBuilder = true
    }
}
