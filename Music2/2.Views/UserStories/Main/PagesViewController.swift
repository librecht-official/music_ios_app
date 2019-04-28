//
//  PagesViewController.swift
//  Music2
//
//  Created by Vladislav Librecht on 21.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

struct PageTransition {
    let fromPageIndex: Int
    let targetPageIndex: Int
    let progress: CGFloat
}

class PagesTopView: UIView {
    typealias Content = PagesViewController.Content.TopPreview
    var content: [Content] = [] {
        didSet {
            for c in content {
                switch c {
                case .title(let text):
                    let label = UILabel()
                    label.text = text
                    label.font = Font.bold(20).uiFont
                    label.textAlignment = .center
                    label.translatesAutoresizingMaskIntoConstraints = false
                    stackView.addArrangedSubview(label)
                case .icon(let image):
                    let imageView = UIImageView()
                    imageView.clipsToBounds = true
                    imageView.image = image
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    AutoLayout.constraint(imageView, .height, with: imageView, .width)
                    stackView.addArrangedSubview(imageView)
                }
            }
        }
    }
    
    private lazy var highligtingView = UIView()
    private lazy var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.white.uiColor
        
        highligtingView.translatesAutoresizingMaskIntoConstraints = false
        highligtingView.backgroundColor = Color.primaryBlue.uiColor
        addSubview(highligtingView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        AutoLayout.constraints(
            stackView, with: self, [.top, .leadingConst(20), .trailingConst(-20), .bottom]
        )
    }
    
    func updatePage(transition: PageTransition) {
        let fromIndex = transition.fromPageIndex
        let targetIndex = transition.targetPageIndex
        guard 0 <= fromIndex && fromIndex < stackView.arrangedSubviews.count else { return }
        guard 0 <= targetIndex && targetIndex < stackView.arrangedSubviews.count else { return }
        
        let p = transition.progress
        if p != 0 {
            let fromView = stackView.arrangedSubviews[fromIndex]
            let toView = stackView.arrangedSubviews[targetIndex]
            let fromFrame = calcHighligtingViewFrame(
                rawFrame: fromView.frame, highligtingIndex: fromIndex
            )
            let toFrame = calcHighligtingViewFrame(
                rawFrame: toView.frame, highligtingIndex: targetIndex
            )
            let frame = fromFrame.interpolate(toFrame: toFrame, p: p)
            setHighligtingView(frame: frame)
        }
        if p > 0.9 {
            updateLabels(highlighted: targetIndex)
        }
    }
    
    func set(highlightedViewIndex i: Int) {
        let view = stackView.arrangedSubviews[i]
        let frame = calcHighligtingViewFrame(rawFrame: view.frame, highligtingIndex: i)
        setHighligtingView(frame: frame)
        updateLabels(highlighted: i)
    }
    
    private func setHighligtingView(frame: CGRect) {
        highligtingView.frame = frame
        highligtingView.layer.cornerRadius = highligtingView.frame.height / 2
    }
    
    private func calcHighligtingViewFrame(rawFrame: CGRect, highligtingIndex i: Int) -> CGRect {
        let inset: (dx: CGFloat, dy: CGFloat)
        switch content[i] {
        case .title: inset = (dx: -6, dy: -4)
        case .icon: inset = (dx: -2, dy: -2)
        }
        let rect = convert(rawFrame, from: stackView)
        return rect.insetBy(dx: inset.dx, dy: inset.dy)
    }
    
    private func updateLabels(highlighted: Int) {
        for (i, view) in stackView.arrangedSubviews.enumerated() {
            if let label = view as? UILabel {
                label.textColor = i == highlighted ? Color.white.uiColor : Color.black.uiColor
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PagesViewController: UIViewController {
    private lazy var topView = PagesTopView()
    private lazy var scrollView = UIScrollView()
    private lazy var stackView = UIStackView()
    
    struct Content {
        enum TopPreview {
            case title(String)
            case icon(UIImage)
        }
        let preview: TopPreview
        let controller: UIViewController
    }
    private lazy var contentControllers = [
        Content(preview: .title(L10n.Main.Pages.Top.explore), controller: UIViewController()),
        Content(preview: .title(L10n.Main.Pages.Top.playlists), controller: UIViewController()),
        Content(preview: .title(L10n.Main.Pages.Top.favorites), controller: UIViewController()),
        Content(preview: .icon(Asset.profileMock.image), controller: UIViewController()),
    ]
    var viewControllers: [UIViewController] {
        return contentControllers.map { $0.controller }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // TODO: remove
        contentControllers[0].controller.view.backgroundColor = UIColor.red
        contentControllers[1].controller.view.backgroundColor = UIColor.green
        contentControllers[2].controller.view.backgroundColor = UIColor.blue
        
        topView.content = contentControllers.map { $0.preview }
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        AutoLayout.constraints(topView, with: view, [.top, .leading, .trailing])
        AutoLayout.constraint(topView, .height(64))
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        AutoLayout.constraint(scrollView, .top, with: topView, .bottom)
        AutoLayout.constraints(scrollView, with: view, [.leading, .trailing, .bottom])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        AutoLayout.constraints(scrollView, with: stackView, [.top, .leading, .trailing, .bottom])
        AutoLayout.constraint(stackView, .height, with: scrollView, .height)
        
        for content in contentControllers {
            let vc = content.controller
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(vc.view)
            AutoLayout.constraint(vc.view, .width, with: view, .width)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        topView.set(highlightedViewIndex: 0)
    }
}

// MARK: - UIScrollViewDelegate

extension PagesViewController: UIScrollViewDelegate {
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
        
        topView.updatePage(transition: PageTransition(
            fromPageIndex: from,
            targetPageIndex: target,
            progress: progress)
        )
    }
}
