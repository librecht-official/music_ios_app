//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import Core


struct TabItem {
    enum TabKind {
        case title(String)
        case icon(UIImage)
    }
    let tab: TabKind
    let controller: UIViewController
}

final class TabsViewController: MUSViewController<TabsView> {
    func set(tabItems: [TabItem]) {
        loadViewIfNeeded()
        
        v.topView.content = tabItems.map { $0.tab }
        v.topView.set(highlightedViewIndex: 0)

        for tabItem in tabItems {
            let vc = tabItem.controller
            embed(child: vc) { view in
                v.addContentView(view)
            }
        }
    }
}

final class TabsView: UIView {
    private(set) lazy var topView = TabsTopView()
    @IBOutlet private(set) var topViewContainer: UIStackView!
    @IBOutlet private(set) var scrollView: UIScrollView!
    @IBOutlet private(set) var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topViewContainer.addArrangedSubview(topView)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    }
    
    func addContentView(_ view: UIView) {
        stackView.addArrangedSubview(view)
        AutoLayout.constrain(self, .width, with: view, .width)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}

// MARK: - UIScrollViewDelegate

extension TabsView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let pageWidth = scrollView.bounds.size.width
        let i = Int(x / pageWidth)
        topView.set(highlightedViewIndex: i)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let pageWidth = scrollView.bounds.size.width
        let i = Int(x / pageWidth)
        
        var from: Int
        var target: Int
        var progress = (x - CGFloat(i) * pageWidth) / pageWidth
        
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x < 0 {
            from = i
            target = i + 1
        } else {
            from = i + 1
            target = i
            progress = 1 - progress
        }
        
        let t = TabTransition(
            fromTabIndex: from,
            targetTabIndex: target,
            progress: progress
        )
        topView.performTabTransition(t)
        endEditing(false)
    }
}
