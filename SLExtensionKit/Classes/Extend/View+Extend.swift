//
//  View+Extend.swift
//  SWToolKit
//
//  Created by shirley on 2022/3/14.
//

import Foundation
import UIKit
import SwiftUI


extension View {
        
    ///将当前视图转为UIImage
    public func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    

}





