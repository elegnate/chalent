//
//  Design.swift
//  trada
//
//  Created by jwan on 2018. 8. 22..
//  Copyright © 2018년 jwan. All rights reserved.
//

import Foundation
import UIKit


struct ThemaColor {
    static let lightGray = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
    static let gray = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
    static let darkgray = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
    static let black = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
    static let red = UIColor(red:1.00, green:0.27, blue:0.53, alpha:1.0)
    static let blue = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
    static let whiteTras90 = UIColor.white.withAlphaComponent(0.90)
    static let yellow = UIColor(red:0.95, green:0.70, blue:0.24, alpha:1.0)
    static let bluelightgray = UIColor(red:0.92, green:0.92, blue:0.95, alpha:1.0)
    static let grayNavigation = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
}


extension UIViewController {
    
    func getNaviBarItem(image: UIImage, action: Selector, imageInsets: UIEdgeInsets? = nil) -> UIBarButtonItem {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.addTarget(self, action: action, for: .touchUpInside)
        if let insets = imageInsets {
            btn.imageEdgeInsets = insets
        }
        btn.setImage(image, for: .normal)
        return UIBarButtonItem(customView: btn)
    }
    /*
    func setTitleImage(_ image: UIImage) {
        let imageviewTitle = UIImageView(image: image)
        imageviewTitle.contentMode = .scaleAspectFit
        navigationItem.titleView = imageviewTitle
    }
     */
}


extension UITableView {
    
    func initDesign() {
        backgroundColor = ThemaColor.bluelightgray
        contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }
}


extension UIView {
    
    func anchorSideEqualToConstant(view: UIView, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        return anchorSideEqualToConstant(view: view,
                                         top: constant, bottom: constant, leading: constant, trailing: constant)
    }
    
    func anchorSideEqualToConstant(view: UIView, top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) -> [NSLayoutConstraint] {
        var ret:[NSLayoutConstraint] = []
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if top != -999 {
            let const = self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: top)
            const.identifier = "customTop"
            const.isActive = true
            ret.append(const)
        }
        if bottom != -999 {
            let const = self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottom)
            const.identifier = "customBottom"
            const.isActive = true
            ret.append(const)
        }
        if leading != -999 {
            let const = self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leading)
            const.identifier = "customLeading"
            const.isActive = true
            ret.append(const)
        }
        if trailing != -999 {
            let const = self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailing)
            const.identifier = "customTrailing"
            const.isActive = true
            ret.append(const)
        }
        
        return ret
    }
    
    func anchorBalanceEqualToConstant(view: UIView, constant: CGFloat = 0) {
        anchorBalanceEqualToConstant(view: view, horizontal: constant, vertical: constant)
    }
    
    func anchorBalanceEqualToConstant(view: UIView, horizontal: CGFloat, vertical: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if horizontal != -999 { self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: horizontal).isActive = true }
        if vertical != -999 { self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: vertical).isActive = true }
    }
}


extension UITextField {
    
    func changePlaceHolderColor(color: UIColor, backgroundColor: UIColor = UIColor.clear) {
        let attribute = NSAttributedString(string: placeholder!, attributes: [.foregroundColor: color, .backgroundColor: backgroundColor])
        attributedPlaceholder = attribute
    }
}


extension UILabel {
    
    func changeTextDesign(findText: String, color: UIColor, backgroundColor: UIColor, weight: UIFont.Weight, size: CGFloat, isOverlap: Bool = false) {
        let strNumber = self.text! as NSString
        let range = strNumber.range(of: findText)
        let attribute = isOverlap ?
            NSMutableAttributedString(attributedString: attributedText!) :
            NSMutableAttributedString(string: text!)
        
        attribute.addAttribute(NSAttributedStringKey.backgroundColor, value: backgroundColor, range: range)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        attribute.addAttribute(NSAttributedStringKey.font, value: customFont(weight: weight, size: size), range: range)
        self.attributedText = attribute
    }
    
    func changeLineHeight(lineHeight: CGFloat) {
        let attribute = NSMutableAttributedString(string: text!)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineHeight
        attribute.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attribute.length))
        self.attributedText = attribute
    }
}


extension LocationCell {
    
    func cellSelectedDesign(hightlightColor: UIColor = ThemaColor.black) {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.white
        view.layer.addBorder([.top, .bottom], color: ThemaColor.darkgray, width: 0.5)
        labelTitle.highlightedTextColor = hightlightColor
        selectedBackgroundView = view
    }
}


extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}


func customFont(weight: UIFont.Weight = .regular, size: CGFloat = 15) -> UIFont {
    var descriptor = UIFontDescriptor(name: "NanumSquare", size: size)
    descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : weight]])
    return UIFont(descriptor: descriptor, size: size)
}


@IBDesignable
class DesignableView: UIView {}
class GradientView: DesignableView {
    var startColor = UIColor(red:0.85, green:0.19, blue:0.42, alpha:1.0)
    var endColor   = UIColor(red:0.74, green:0.31, blue:0.61, alpha:1.0)
    var horizontalMode =  false
    var diagonalMode   =  true
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}

@IBDesignable
class DesignableButton: UIButton {}
class AlertButton: DesignableButton {
    
    var backgroundInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 0)
    
    override func backgroundRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.backgroundRect(forBounds: bounds)
        contentEdgeInsets = backgroundInsets
        return UIEdgeInsetsInsetRect(rect, backgroundInsets)
    }
}

@IBDesignable
class DesignableImageView: UIImageView {}

@IBDesignable
class DesignableScrollView: UIScrollView {}

@IBDesignable
class DesignableLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}

extension DesignableLabel {
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}

@IBDesignable
class DesignableTextField: UITextField {}

@IBDesignable
class DesignableSegmentedControl: UISegmentedControl {}

@IBDesignable
class DesignableTextView: UITextView {}

@IBDesignable
class DesignableTableView: UITableView {}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
