//
//  UIPickerViewExtension.swift
//  Let'sPlank
//
//  Created by Rin on 2020/12/28.
//

import UIKit

extension UIPickerView {
    func setPickerLabels(labels: [Int:UILabel]) { // [component number:label]
        
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = self.frame.size.width / CGFloat(self.numberOfComponents)
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0...self.numberOfComponents {
            
            if let label = labels[i] {
                label.frame = CGRect(x: labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                
                self.addSubview(label)
                print("ラベル", labels)
            }
        }
    }
}
