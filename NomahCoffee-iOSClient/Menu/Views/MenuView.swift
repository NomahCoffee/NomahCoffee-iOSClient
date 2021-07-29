//
//  MenuView.swift
//  NomahCoffee-iOSClient
//
//  Created by Caleb Rudnicki on 7/11/21.
//

import UIKit
import NCUtils

protocol MenuViewDelegate {
    /// Triggers a new view controller to be presented
    /// - Parameter viewController: a `UIViewController` object that is to be presented
    func present(viewController: UIViewController)
    /// Triggers an add to cart action
    /// - Parameter coffee: the `Coffee` object that is to be added
    /// - Parameter quantity: an `Int` for the number of coffee items
    func add(_ coffee: Coffee, with quantity: Int)
}

class MenuView: UIScrollView, UICollectionViewDelegate, UICollectionViewDataSource, CartProtocol {

    // MARK: Properties
    
    var menuViewDelegate: MenuViewDelegate?
    
    var viewModel: MenuViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        return backgroundView
    }()
        
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = MenuConstants.navigationBarTitle
        titleLabel.font = Fonts.Oxygen.header1
        return titleLabel
    }()
    
    private let settingsButton: UIButton = {
        let settingsButton = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24)
        settingsButton.setImage(UIImage(systemName: "gearshape.fill",
                                        withConfiguration: symbolConfig),
                                for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        settingsButton.tintColor = .black
        settingsButton.contentHorizontalAlignment = .right
        return settingsButton
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = MenuConstants.cellSize
        layout.sectionInset = MenuConstants.collectionViewInsets
        layout.minimumLineSpacing = 24
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MenuCell.self,
                                forCellWithReuseIdentifier: MenuCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = Colors.shadow
        
        backgroundView.addSubviews([titleLabel, settingsButton, collectionView])
        addSubview(backgroundView)
                
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(24)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(settingsButton.snp.leading)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(MenuConstants.cellSize.height)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    @objc private func settingsButtonTapped() {
        menuViewDelegate?.present(viewController: SettingsViewController())
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
        menuViewDelegate?.present(viewController: ProductDetailViewController(coffee: coffee))
    }
    
    // MARK: MenuCellDelegate
    
    func add(coffee: Coffee, with quantity: Int) {
        menuViewDelegate?.add(coffee, with: quantity)
    }
    
}
