//
//  PickAndChoose.swift
//  PickAndChoose
//
//  Created by Brent Michalski on 1/19/19.
//  Copyright © 2019 Perlguy, Inc. All rights reserved.
//

import UIKit

public typealias PickAndChooseData = [String]

public protocol PickAndChooseDelegate {
    var pickAndChooseData: PickAndChooseData? { get }
    
    func pickAndChoose(_ picker: PickAndChoose, titleForRow row: Int, forComponent component: Int) -> String?
    func numberOfComponents(in picker: PickAndChoose) -> Int
    func pickAndChoose(_ picker: PickAndChoose, numberOfRowsInComponent component: Int) -> Int
    func pickAndChoose(_ picker: PickAndChoose, addItemToDataSource item: String)
}


@IBDesignable
public class PickAndChoose: UIView {
    var currentlySelectedIndex: PickerViewViewController.Index?
    
    private var currentlySelected: String = "" {
        didSet {
            pickerLabel.textColor = fontColor?.withAlphaComponent(1.0)
            pickerLabel.text      = currentlySelected
            
            if let foo = delegate?.pickAndChooseData?.index(of: currentlySelected) {
                currentlySelectedIndex = (column: 0, row: foo + 1)
            }
        }
    }
    
    public var delegate:   PickAndChooseDelegate?
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var pickerLabel: PaddedLabel!
    @IBOutlet weak var pickerImageView: UIImageView!
    
    @IBOutlet weak public var pickerImageViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            pickerImageView.size = CGSize(width: pickerImageViewHeightConstraint.constant, height: pickerImageViewHeightConstraint.constant)
        }
    }
    
    @IBOutlet weak var pickerImageViewLeadingConstraint: NSLayoutConstraint!
    
    public var currentValue: String? {
        return pickerLabel.text
    }
    
    
    // MARK: - Setup The View
    func setupView() {
        pickerLabel.leftInset = 8.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.numberOfTapsRequired = 1
        
        self.containerView.addGestureRecognizer(tap)
        pickerImageView.clipsToBounds            = true
        pickerImageViewHeightConstraint.constant = 0
        
        pickerImageView.backgroundColor = .clear
        placeholderText                 = "Placeholder Text"
    }

    
    public func setSelectedValue(to value: String) {
        currentlySelected = value
    }
    
    
    @objc func viewTapped(_ sender: Any) {
        
        let titleText   = "Select \(fieldName)"
        let messageText = allowsAddingValues ? "or choose \"Create\" to create a new \(fieldName)." : nil
        
        // Show Picker View
        let alert       = UIAlertController(style: .actionSheet, title: titleText, message: messageText)
        let titleFont   = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        let messageFont = UIFont.systemFont(ofSize: 16.0, weight: .light)
        
        alert.setMessage(font: messageFont, color: .black)
        alert.setTitle(font: titleFont, color: .black)
        
        if let pickAndChooseData = delegate?.pickAndChooseData {
            
            // Adds a blank to the beginning of the data
            var displayData = pickAndChooseData
            displayData.insert("", at: 0)
            
            alert.addPickerView(values: [displayData], initialSelection: self.currentlySelectedIndex) { (vc, picker, index, values) in
                self.setSelectedValue(to: self.delegate?.pickAndChoose(self, titleForRow: index.row - 1, forComponent: index.column) ?? "")
            }
        }

        // If adding new values is allowed.
        if allowsAddingValues {
            alert.addAction(image: nil, title: "Create", color: nil, style: UIAlertAction.Style.destructive, isEnabled: true) { (action) in
                self.addNewValueAction()
            }
        }
        
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    
    func addNewValueAction() {
        var valueText: String = ""
        
        let alert = UIAlertController(style: .alert, title: "Add New \(self.fieldName)")
        
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor          = .black
            textField.placeholder        = "New \(self.fieldName)"
            textField.leftViewPadding    = 12
            textField.borderWidth        = 1
            textField.cornerRadius       = 8
            textField.borderColor        = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor    = nil
            textField.keyboardAppearance = .default
            textField.keyboardType       = .default
            textField.returnKeyType      = .done
            
            textField.action { textField in
                if let itemName = textField.text {
                    valueText = itemName
                }
            }
        }
        
        alert.addOneTextField(configuration: config)
        
        alert.addAction(image: nil, title: "OK", color: nil, style: .default, isEnabled: true) { (action) in
            self.delegate?.pickAndChoose(self, addItemToDataSource: valueText)
        }
        
        alert.addAction(title: "Cancel", style: .cancel)
        alert.show()
    }
    
    
    // MARK: - IBInspectable Variables
    @IBInspectable
    public var myImage: UIImage? {
        didSet {
            if let image = myImage {
                pickerImageViewLeadingConstraint.constant = 8.0
                pickerImageView.image                     = image
            }
            else {
                pickerImageViewHeightConstraint.constant  = 0
                pickerImageViewLeadingConstraint.constant = 0
            }
        }
    }
    
    @IBInspectable public var allowsAddingValues: Bool = false
    
    // Used for the title of the Add New value
    @IBInspectable public var fieldName: String = ""

    @IBInspectable
    public var bgColor: UIColor = .white {
        didSet {
            containerView.backgroundColor = bgColor
        }
    }


    
    // MARK: - Control Outer Border
    @IBInspectable
    public var controlBorderColor: UIColor? {
        didSet {
            containerView.borderColor = controlBorderColor
        }
    }

    @IBInspectable
    public var controlBorderWidth: CGFloat = 0 {
        didSet {
            containerView.borderWidth = controlBorderWidth
        }
    }
    
    @IBInspectable
    public var controlBorderCornerRadius: CGFloat = 0 {
        didSet {
            containerView.layer.cornerRadius = controlBorderCornerRadius
        }
    }
    
    
    // MARK: - Image settings and border
    @IBInspectable
    public var imageBorderColor: UIColor? {
        didSet { pickerImageView.borderColor = imageBorderColor
        }
    }

    @IBInspectable
    public var imageBorderWidth: CGFloat = 0 {
        didSet {
            pickerImageView.borderWidth = imageBorderWidth
        }
    }
    
    @IBInspectable
    public var imageBorderCornerRadius: CGFloat = 0 {
        didSet {
            pickerImageView.layer.cornerRadius = imageBorderCornerRadius
        }
    }

    @IBInspectable
    public var imageHeight: CGFloat = 40 {
        didSet {
            pickerImageView.size = CGSize(width: imageHeight, height: imageHeight)
            pickerImageViewHeightConstraint.constant = imageHeight
        }
    }

    
    // MARK: - Label font and border settings
    @IBInspectable
    public var labelBorderColor: UIColor? {
        didSet { pickerLabel.borderColor = labelBorderColor }
    }
    
    @IBInspectable
    public var labelBorderWidth: CGFloat = 0 {
        didSet {
            pickerLabel.borderWidth = labelBorderWidth
        }
    }

    @IBInspectable
    public var labelBorderCornerRadius: CGFloat = 0 {
        didSet {
            pickerLabel.layer.cornerRadius = labelBorderCornerRadius
        }
    }
    
    @IBInspectable
    public var placeholderText: String? {
        didSet {
            pickerLabel.textColor = fontColor?.withAlphaComponent(0.6)
            pickerLabel.text      = placeholderText
        }
    }
    
    @IBInspectable
    public var fontSize: CGFloat = 16 {
        didSet {
            pickerLabel.font = pickerLabel.font.withSize(fontSize)
        }
    }
    
    @IBInspectable
    public var fontColor: UIColor? {
        didSet { pickerLabel.textColor = fontColor }
    }
    
    
    // MARK: - Interface Builder
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    
    // MARK: - Methods to make the control load properly.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }
    
    private func initNib() {
        if !self.subviews.isEmpty { return }
        
        let bundle = Bundle(for: PickAndChoose.self)
        bundle.loadNibNamed(String(describing: PickAndChoose.self), owner: self, options: nil)
        
        self.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        
        setupView()
        
        clipsToBounds = true
    }
    
}
