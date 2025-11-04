//
//  UIView+.swift
//  SubwayWhen
//
//  Created by 이윤수 on 11/4/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
