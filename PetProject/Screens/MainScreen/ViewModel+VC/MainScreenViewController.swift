//
//  MainScreenViewController.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 25.03.22.
//

import SnapKit
import Combine

protocol MainScreenDelegate {
    func chooseStore(_ store: StoreModel)
}

class MainScreenViewController: UIViewController {
    
    var mainScreenVM: MainScreenViewModel!
    typealias MainScreenViewControllerDelegate = (AlertShowable & MainScreenDelegate)
    var delegate: MainScreenViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        styleUI()
        setupTableView()
        makeConstraints()
        makeViewModelObserving()
    }
    
    private func styleUI() {
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { maker in
            maker.size.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StoreCell.self, forCellReuseIdentifier: StoreCell.identifier)
    }
    
    // MARK: - Observing
    
    private func makeViewModelObserving() {
        
        mainScreenVM.$stores.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        mainScreenVM.$error.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                guard
                    let self = self,
                    error != nil
                else { return }
                self.delegate?.showErrorAlert(withErrorMessage: "Unable to get stores information".localized)
            })
            .store(in: &cancellables)
        
        mainScreenVM.$storesLogos.receive(on: DispatchQueue.main)
            .delay(for: .seconds(2), scheduler: RunLoop.main, options: .none)
            .sink { [weak self] storeLogos in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainScreenVM?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreCell.identifier) as? StoreCell
        else { return UITableViewCell() }
        let store = mainScreenVM.stores[indexPath.row]
        cell.storeNameLabel.text = store.storeName
        let defaultImage = UIImage(systemName: "cart.fill")?.withTintColor(.systemBlue)
        cell.logoImage.image = mainScreenVM.storesLogos[store.storeID] ?? defaultImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.chooseStore(mainScreenVM.stores[indexPath.row])
    }
}
