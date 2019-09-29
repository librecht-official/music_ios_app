//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import Core


final class TestViewController: MUSViewController<TestView> {
    var data: [String] = ["1", "2"]
    
    override func makeView() -> TestView {
        TestView(frame: .zero, style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        v.dataSource = self
        v.delegate = self
        v.register(headerFooterViewType: TitleTableHeaderView.self)
        v.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension TestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

extension TestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(TitleTableHeaderView.self)
        header?.configure(title: "Recommended to you")
        return header
    }
}

final class TestView: UITableView {
}
