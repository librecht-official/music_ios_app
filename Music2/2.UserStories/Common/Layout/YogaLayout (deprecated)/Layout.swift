//
//  Layout.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.03.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import YogaKit

@available(*, deprecated)
protocol LayoutNode {
    @discardableResult
    func configureLayout() -> UIView
}

@available(*, deprecated)
protocol LayoutComponent {
    func render() -> LayoutNode
}

@available(*, deprecated, message: "Yoga Layout is deprecated and will be removed later")
enum Layout {
    
    // MARK: Composite Node
    
    struct Composite<View: UIView>: LayoutNode {
        let view: View
        let style: Style<View>
        let children: [LayoutNode]
        
        init(_ view: View, style: Style<View>, _ children: [LayoutNode] = []) {
            self.view = view
            self.style = style
            self.children = children
        }
        
        @discardableResult
        func configureLayout() -> UIView {
            let childrenViews = children.map { $0.configureLayout() }
            childrenViews.forEach { view.addSubview($0) }
            style.styling?(view)
            view.configureLayout(block: style.layout)
            
            return view
        }
    }
    
    // MARK: Leaf Node
    
    struct Leaf<View: UIView>: LayoutNode {
        let view: View
        let style: Style<View>
        
        init(_ view: View, style: Style<View> = .empty()) {
            self.view = view
            self.style = style
        }
        
        @discardableResult
        func configureLayout() -> UIView {
            style.styling?(view)
            view.configureLayout(block: style.layout)
            
            return view
        }
    }
    
    // MARK: - Special Component Node (Sublayout)
    
    struct Component: LayoutNode {
        let component: LayoutComponent
        
        init(_ component: LayoutComponent) {
            self.component = component
        }
        
        func configureLayout() -> UIView {
            return component.render().configureLayout()
        }
    }
    
    // MARK: Common Nodes
    
    typealias Label = Leaf<UILabel>
    typealias Button = Leaf<UIButton>
    typealias Image = Leaf<UIImageView>
    // TODO: BackgroundImage
    typealias TextField = Leaf<UITextField>
    typealias TextView = Leaf<UITextView>
    typealias TableView = Leaf<UITableView>
    typealias CollectionView = Leaf<UICollectionView>
    
    // MARK: Style
    
    struct Style<V: UIView> {
        typealias LayoutFunction = (YGLayout) -> ()
        typealias StylingFunction<V> = (V) -> ()
        
        let layout: LayoutFunction
        let styling: StylingFunction<V>?
        
        init(layout: LayoutFunction? = nil, styling: StylingFunction<V>? = nil) {
            self.layout = {
                $0.isEnabled = true
                layout?($0)
            }
            self.styling = styling
        }
        
        static func empty<V: UIView>() -> Style<V> { return Style<V>() }
    }
    
    // MARK: Rendering
    
    /// Configure and apply layout
    static func render(rootNode: LayoutNode) -> UIView {
        let rootView = rootNode.configureLayout()
        rootView.yoga.applyLayout(preservingOrigin: true)
        
        return rootView
    }
}

// MARK: - Helpers

extension Layout {
    static func configureLayout(rootNode: LayoutNode) {
        rootNode.configureLayout()
    }
    
    static func applyLayout(_ view: UIView) {
        view.yoga.applyLayout(preservingOrigin: true)
    }
    
    static func updateViewLayout(_ view: UIView, to size: CGSize) {
        view.configureLayout { (layout) in
            layout.width = YGValue(size.width)
            layout.height = YGValue(size.height)
        }
        view.yoga.applyLayout(preservingOrigin: true)
    }
    
    static func updateViewLayoutAnimated(
        _ view: UIView, to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        view.configureLayout { (layout) in
            layout.width = YGValue(size.width)
            layout.height = YGValue(size.height)
        }
        coordinator.animate(alongsideTransition: { _ in
            view.yoga.applyLayout(preservingOrigin: true)
        }, completion: nil)
    }
}

/*
class ComponentView: UIView {
    convenience init(component: LayoutComponent) {
        self.init(frame: .zero)
        Layout.Composite(self, style: Styles.Common.container, [
            Layout.Component(component)
        ])
        .configureLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Layout.applyLayout(self)
    }
}

class PlaybackProgressView: ComponentView {
    convenience init() {
        self.init(component: PlaybackProgress())
    }
}
*/
