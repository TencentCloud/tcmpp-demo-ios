//
//  TCMPPMenuView.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/14.
//

import UIKit

class TCMPPMenuItem: NSObject {
    var title: String?
    var icon: UIImage?
    var block: (() -> Void)?
}

class TCMPPMenuView: UIView {
    var menuItems: [TCMPPMenuItem] = []
    
    init(menuItems: [TCMPPMenuItem]) {
        super.init(frame: .zero)
        self.menuItems = menuItems
        self.backgroundColor = UIColor.tcmpp_color(withHex: "#4C4C4C")
        for (idx, obj) in menuItems.enumerated() {
            let content = UIView(frame: CGRect(x: 0, y: 50 * idx, width: 130, height: 50))
            content.tag = idx
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            content.addGestureRecognizer(tap)
            self.addSubview(content)
            
            let iv = UIImageView(frame: CGRect(x: 13, y: 13, width: 24, height: 24))
            iv.image = obj.icon
            content.addSubview(iv)
            
            let title = UILabel(frame: CGRect(x: iv.frame.maxX + 10, y: 13, width: 130 - 13 - 10 - 24, height: 24))
            title.font = UIFont.systemFont(ofSize: 15)
            title.textColor = .white
            title.text = obj.title
            content.addSubview(title)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTapGesture(_ tap: UITapGestureRecognizer) {
        self.menuItems[tap.view!.tag].block?()
        dismiss()
    }
    
    func dismiss() {
        removeFromSuperview()
    }
}
