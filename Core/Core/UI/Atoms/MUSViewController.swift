//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


open class MUSViewController<View: UIView>: UIViewController {
    public private(set) var v: View!
    public let disposeBag = DisposeBag()
    
    open override func loadView() {
        let v: View = makeView()
        self.v = v
        view = v
    }
    
    open func makeView() -> View {
        return View.loadFromNib()
    }
    
    open var hidesNavigationBar: Bool {
        return false
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(hidesNavigationBar, animated: animated)
    }
}
