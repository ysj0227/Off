//
//  JHSnapKitTool.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit
import SnapKit

public struct AssociatedKeys {
    static var TapGestureKey: String = "TapGestureKey"
    static var JHButtonTouchUpKey: String = "JHButtonTouchUpKey"
}

public class JHSnapKitTool: NSObject {

   public typealias JHSnapMaker = (_ make: ConstraintMaker) -> Void
    
   public typealias JHTapGestureBlock = (_ block: Any) -> Void

   public typealias JHButtonBlock = (_ sender: UIButton) -> Void
}
