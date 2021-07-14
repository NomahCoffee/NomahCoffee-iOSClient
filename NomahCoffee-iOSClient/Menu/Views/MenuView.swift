//
//  MenuView.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit

protocol MenuViewDelegate {
    /// Triggers a logout action
    func logout()
    /// Triggers a new view controller to be presented
    /// - Parameter viewController: a `UIViewController` object that is to be presented
    func present(viewController: UIViewController)
    /// Triggers an add to cart action
    /// - Parameter coffee: the `Coffee` object that is to be added
    func add(_ coffee: Coffee)
}

class MenuView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, MenuCellDelegate {

    // MARK: Properties
    
    var delegate: MenuViewDelegate?
    
    var viewModel: MenuViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = MenuConstants.cellSize
        layout.sectionInset = MenuConstants.collectionViewInsets
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MenuCell.self,
                                forCellWithReuseIdentifier: MenuCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    private let logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.setTitle(MenuConstants.logoutButtonTitle, for: .normal)
        logoutButton.setTitleColor(.label, for: .normal)
        logoutButton.backgroundColor = .red
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return logoutButton
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        addSubviews([collectionView, logoutButton])
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(MenuConstants.logoutButtonHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc private func logoutButtonTapped() {
        delegate?.logout()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.coffees.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.reuseIdentifier,
                                                          for: indexPath) as? MenuCell,
            let coffee = viewModel?.coffees[indexPath.row]
        else {
            return UICollectionViewCell()
        }
        
        cell.coffee = coffee
        cell.delegate = self
        return cell
    }
        
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let coffee = viewModel?.coffees[indexPath.row] else { return }
        delegate?.present(viewController: ProductDetailViewController(coffee: coffee))
    }
    
    // MARK: MenuCellDelegate
    
    func add(coffee: Coffee) {
        delegate?.add(coffee)
    }
    
}
