//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import Reusable
import Layout


public final class SectionTitleView: UIView {
    // MARK: Properties
    private let titleLabel = MUSLabel()
    
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private lazy var layout = Component(
        titleLabel, .h1(leading: 16, trailing: 16), .v1(top: 8, bottom: 8)
    )
    
    public override func layoutSubviews() {
        stylesheet().view.background(self)
        stylesheet().text.majorTitle2(titleLabel)
        super.layoutSubviews()
        layout.performLayout(inFrame: bounds)
    }
}


public final class TitleTableHeaderView: UITableViewHeaderFooterView, Reusable {
    private let view = SectionTitleView()
    
    public func configure(title: String) {
        view.title = title
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundView = UIView()
        addSubview(view)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
