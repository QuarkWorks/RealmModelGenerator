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
}

extension NibDesignableProtocol {
    // MARK: - Nib loading
    
    /**
    Called to load the nib in setupNib().
    
    - returns: NSView instance loaded from a nib file.
    */
    public func loadNib() -> NSView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = NSNib(nibNamed: self.nibName(), bundle: bundle)
        var objects:NSArray?
        nib!.instantiateWithOwner(self, topLevelObjects: &objects)
        return objects?.filter({$0 is NSView}).first as! NSView
    }
    
    // MARK: - Nib loading
    
    /**
    Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
    */
    private func setupNib() {
        let view = self.loadNib()
        self.nibContainerView.addSubview(view)
        view.matchParent()
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
        return self.dynamicType.description().componentsSeparatedByString(".").last!
    }
    
    public func nibDidLoad() {}
    
    private func matchParent() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": self]
        self.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[view]|", options:[], metrics:nil, views: bindings))
        self.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[view]|", options:[], metrics:nil, views: bindings))
    }
}

@IBDesignable
public class NibDesignableView: NSView, NibDesignableProtocol {
    
    var isInterfaceBuilder:Bool = false
    
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
    
    var isInterfaceBuilder:Bool = false
    
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