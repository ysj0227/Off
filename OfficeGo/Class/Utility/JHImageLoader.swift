//
//  JHImageLoader.swift
//  JHToolsModule_Swift
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit

public class JHImageLoader{
    static var bundle: Bundle = {
        let bundle = Bundle.init(for: JHImageLoader.self)
        return bundle
    }()
    
    public static func loadToolsImage(with name: String) -> UIImage? {
        var image = UIImage.init(named: name, in: bundle, compatibleWith: nil)
        if image == nil {
            image = UIImage(named: name)
        }
        return image
    }
}
