//
//  UIResponder+Extensions.swift
//  SnapPop
//
//  Created by 이인호 on 8/28/24.
//

import UIKit

extension UIResponder {
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static var currentResponder: UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}
