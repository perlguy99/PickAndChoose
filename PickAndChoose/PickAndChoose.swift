//
//  PickAndChoose.swift
//  PickAndChoose
//
//  Created by Brent Michalski on 1/19/19.
//  Copyright © 2019 Perlguy, Inc. All rights reserved.
//

import UIKit

public typealias PickAndChooseData = [[String]]


public protocol PickAndChooseDataSource {
    var pickAndChooseData: PickAndChooseData { get set }
//    var pickAndChooseDataDefaultValue: String { get set }
    
    func addItemToDataSource(_ newItem: String)
    
}


public protocol PickAndChooseDelegate {
    func setDefaultValue(to defaultValue: String)
    func setSelectedValue(to selectedValue: String)
    func selectionChanged()
}


@IBDesignable
public class PickAndChoose: UIView {

    public var delegate:   PickAndChooseDelegate?
    public var dataSource: PickAndChooseDataSource?
    
    // Used for the popup text
    public var fieldName: String = ""
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerLabel: UILabel!
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
    
    
    
    @objc func viewTapped(_ sender: Any) {
        print("\nTap!\n")
        
        let defaultPickerValues = [["Emergency", "Complaint", "Appointment", "Information"]]
        let defaultSelectedText = "Appointment"
        
        
        // Show Picker View
//        let alert = UIAlertController(style: .actionSheet, title: "Select \(fieldName)", message: "or choose \"Create\" to create a new \(fieldName).")
//        
//        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: defaultPickerValues[0].index(of: defaultSelectedText) ?? 0)
//        
//        self.placeholderText = defaultSelectedText
//        
//        alert.addPickerView(values: defaultPickerValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
//            self.placeholderText = values[0][index.row]
//        }
//        
//        alert.addAction(title: "OK", style: .default)
//        
//        alert.addAction(image: nil, title: "New \(fieldName)", color: nil, style: UIAlertAction.Style.destructive, isEnabled: true) { (action) in
//            
//            
////            let categoryImage = UIImage.fontAwesomeIcon(name: .clipboardList, style: .regular, textColor: .black, size: CGSize(width: 25.0, height: 25.0))
//            let alert = UIAlertController(style: .alert, title: "New \(self.fieldName)")
//            let config: TextField.Config = { textField in
//                textField.becomeFirstResponder()
//                textField.textColor          = .black
//                textField.placeholder        = "New \(self.fieldName) Name"
////                textField.left(image: categoryImage, color: .black)
//                textField.leftViewPadding    = 12
//                textField.borderWidth        = 1
//                textField.cornerRadius       = 8
//                textField.borderColor        = UIColor.lightGray.withAlphaComponent(0.5)
//                textField.backgroundColor    = nil
//                textField.keyboardAppearance = .default
//                textField.keyboardType       = .default
//                textField.returnKeyType      = .done
//                
//                textField.action { textField in
//                    
//                    // This is where we can ADD an item
//                    if let itemName = textField.text {
//                        
//                        print("\n\n")
//                        print("***************************")
//                        print(itemName)
//                        print("***************************")
//                        print("\n\n")
//                        
//                    }
//                }
//            }
//            
//            alert.addOneTextField(configuration: config)
//            alert.addAction(title: "OK", style: .cancel)
//            alert.show()
//        }
//        
//        alert.addAction(title: "Done", style: .cancel)
//        alert.show()
        
    }
    
    
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
    

    
    func setupView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.numberOfTapsRequired = 1
        self.containerView.addGestureRecognizer(tap)
        
//        fontSize = 20.0
//        fontColor = .green
//
//        controlBorderWidth = 1.0
//        controlBorderColor = .red
//
//        imageBorderWidth = 2.0
//        imageBorderColor = .green
//
//        labelBorderWidth = 1.5
//        labelBorderColor = .brown
        
        pickerImageView.clipsToBounds = true
        pickerImageViewHeightConstraint.constant = 0
        
//        pickerImageView.tintColor = .red
//        containerBackgroundColor = .orange
//        myImage = UIImage(named: "image")
        
        pickerImageView.backgroundColor = .clear
        placeholderText = "Placeholder Text"
    }
    
    
    // MARK: - Interface Builder
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
//        setupView()
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
