//
//  PickAndChoose.swift
//  PickAndChoose
//
//  Created by Brent Michalski on 1/19/19.
//  Copyright © 2019 Perlguy, Inc. All rights reserved.
//

import UIKit

public typealias PickAndChooseData = [String]


public protocol PickAndChooseDataSource {
    var pickAndChooseData: PickAndChooseData? { get set }
    
    func numberOfComponents(in picker: PickAndChoose) -> Int
    func pickAndChoose(_ picker: PickAndChoose, numberOfRowsInComponent component: Int) -> Int
    func pickAndChoose(_ picker: PickAndChoose, addItemToDataSource item: String)
}


public protocol PickAndChooseDelegate {
    func pickAndChoose(_ picker: PickAndChoose, titleForRow row: Int, forComponent component: Int) -> String?
    
//    func setDefaultValue(to defaultValue: String)
//    func setSelectedValue(to selectedValue: String)
//    func selectionChanged()
}


@IBDesignable
public class PickAndChoose: UIView {
    let defaultSelectedText = "Appointment"

    var currentlySelectedIndex: PickerViewViewController.Index?
    
    private var currentlySelected: String = "" {
        didSet {
            pickerLabel.text = currentlySelected
            
            if let foo = dataSource?.pickAndChooseData?.index(of: currentlySelected) {
                currentlySelectedIndex = (column: 0, row: foo + 1)
            }
        }
    }
    
    public var delegate:   PickAndChooseDelegate?
    public var dataSource: PickAndChooseDataSource?
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var pickerLabel: PaddedLabel!
    @IBOutlet weak var pickerImageView: UIImageView!
    
    @IBOutlet weak public var pickerImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerImageViewLeadingConstraint: NSLayoutConstraint!
    
    @IBInspectable
    public var myImage: UIImage? {
        didSet {
            if let image = myImage {
                pickerImageViewHeightConstraint.constant  = containerView.height - 10.0
                pickerImageViewLeadingConstraint.constant = 8.0
                pickerImageView.image                     = image
            }
            else {
                pickerImageViewHeightConstraint.constant  = 0
                pickerImageViewLeadingConstraint.constant = 0
            }
        }
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
        
        if let pickAndChooseData = dataSource?.pickAndChooseData {
            
            // Adds a blank to the beginning of the data
            var displayData = pickAndChooseData
            displayData.insert("", at: 0)
            
            alert.addPickerView(values: [displayData], initialSelection: self.currentlySelectedIndex) { (vc, picker, index, values) in
                self.setSelectedValue(to: self.delegate?.pickAndChoose(self, titleForRow: index.row - 1, forComponent: index.column) ?? "")
//                self.currentlySelectedIndex = index
//                self.currentlySelected      = self.delegate?.pickAndChoose(self, titleForRow: index.row - 1, forComponent: index.column) ?? ""
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
            self.dataSource?.pickAndChoose(self, addItemToDataSource: valueText)
        }
        
        alert.addAction(title: "Cancel", style: .cancel)
        
        alert.show()
    }
    
    
    @IBInspectable
    public var allowsAddingValues: Bool = false
    
    // Used for the title of the Add New value
    @IBInspectable
    public var fieldName: String = ""

    
    @IBInspectable
    public var bgColor: UIColor? {
        get { return containerView.backgroundColor }
        set { containerView.backgroundColor = newValue }
    }

    
    @IBInspectable
    public var placeholderText: String? {
        get { return pickerLabel.text }
        set { pickerLabel.text = newValue }
    }
    
    
    @IBInspectable
    public var fontSize: CGFloat = 16 {
        didSet {
            pickerLabel.font = pickerLabel.font.withSize(fontSize)
        }
    }

    
    @IBInspectable
    public var fontColor: UIColor? {
        get { return pickerLabel.textColor }
        set { pickerLabel.textColor = newValue }
    }


    
    // Overall border
    @IBInspectable
    public var controlBorderColor: UIColor? {
        get { return containerView.borderColor }
        set { containerView.borderColor = newValue }
    }

    @IBInspectable
    public var controlBorderWidth: CGFloat {
        get { return containerView.borderWidth }
        set { containerView.borderWidth = newValue }
    }

    @IBInspectable
    public var controlBorderCornerRadius: CGFloat {
        get { return containerView.layer.cornerRadius }
        set { containerView.layer.cornerRadius = newValue }
    }
    
    
    // Image border
    @IBInspectable
    public var imageBorderColor: UIColor? {
        get { return pickerImageView.borderColor }
        set { pickerImageView.borderColor = newValue }
    }

    @IBInspectable
    public var imageBorderWidth: CGFloat {
        get { return pickerImageView.borderWidth }
        set { pickerImageView.borderWidth = newValue }
    }
    
    @IBInspectable
    public var imageBorderCornerRadius: CGFloat {
        get { return pickerImageView.layer.cornerRadius }
        set { pickerImageView.layer.cornerRadius = newValue }
    }

    
    
    // Label border
    @IBInspectable
    public var labelBorderColor: UIColor? {
        get { return pickerLabel.borderColor }
        set { pickerLabel.borderColor = newValue }
    }
    
    @IBInspectable
    public var labelBorderWidth: CGFloat {
        get { return pickerLabel.borderWidth }
        set { pickerLabel.borderWidth = newValue }
    }

    @IBInspectable
    public var labelBorderCornerRadius: CGFloat {
        get { return pickerLabel.layer.cornerRadius }
        set { pickerLabel.layer.cornerRadius = newValue }
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
