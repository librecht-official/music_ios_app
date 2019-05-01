//
//  ImageAssetExt.swift
//  Music2
//
//  Created by Vladislav Librecht on 02.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

extension UIImage {
    final var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
}
