//
//  MView.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

@available(*, deprecated)
class MView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepareLayout() {
    }

    func configureViews() {
    }
}

@available(*, deprecated)
class LayoutView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        Layout.applyLayout(self)
    }
}

