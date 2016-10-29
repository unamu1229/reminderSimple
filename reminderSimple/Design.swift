//
//  Design.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/08/15.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//
import UIKit

@IBDesignable class CustomButton: UIButton {
    
    // 角丸の半径(0で四角形)
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
    // 枠
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        // 角丸
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = (cornerRadius > 0)
        
        // 枠線
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
        super.draw(rect)
    }
}

@IBDesignable class CustomTextView: UITextView {
    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        // 角丸
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = (cornerRadius > 0)
        
        // 枠線
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
        super.draw(rect)
    }
}
