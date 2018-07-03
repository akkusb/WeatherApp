//
//  LibraryExtensions.swift
//  
//
//  Created by Burhan on 25/05/2018.
//  Copyright © 2018 Burhan. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class LibraryExtensions: NSObject {

}

extension AbstractActionSheetPicker
{
    func configure() -> Void
    {
        self.setDoneButton(self.getDoneBarButton())
        self.setCancelButton(self.getCancelBarButton())
    }
    
    func getDoneBarButton() -> UIBarButtonItem {
        let doneButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 35))
        doneButton.setTitle("Tamam", for: .normal)
        doneButton.contentHorizontalAlignment = .right
        doneButton.contentVerticalAlignment = .fill
        
        return UIBarButtonItem.init(customView: doneButton)
    }
    
    func getCancelBarButton() -> UIBarButtonItem {
        let cancelButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 35))
        cancelButton.setTitle("İptal", for: .normal)
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.contentVerticalAlignment = .fill
        return UIBarButtonItem.init(customView: cancelButton)
    }
    
}

extension ActionSheetDatePicker{
    open override func show() {
        self.configure()
        super.show()
    }
}

extension ActionSheetCustomPicker{
    open override func show() {
        self.configure()
        super.show()
    }
}

extension ActionSheetStringPicker{
    open override func show() {
        self.configure()
        super.show()
    }
}


