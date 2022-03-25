//
//  MainScreenViewController.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 25.03.22.
//

import SnapKit

class MainScreenViewController: UIViewController {
    
    var mainScreenVM: MainScreenViewModel?
    private let cellIdentifier = "MainScreenTableViewCell"
    
    override func viewDidLoad() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.size.equalToSuperview()
        }
    }
    
}

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainScreenVM?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell ?? UITableViewCell()
    }
    
}
