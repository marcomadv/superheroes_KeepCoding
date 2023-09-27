//
//  PrincipalTableViewController.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 23/9/23.
//

import UIKit

class PrincipalTableViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    private var data: [HeroeAndTransformationProtocol] = []
    private var dataProvider: ListDataProviderProtocol
    
    init(dataProvider: ListDataProviderProtocol) {
        self.dataProvider  = dataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        title = dataProvider.title
        self.dataProvider.refreshData { data in
            self.data = data
            self.tableView.reloadData()
        }
        
        configureTableview()
    }
    
    func configureTableview() {
        tableView.rowHeight = 132
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: HeroesCell.identifier, bundle: nil), forCellReuseIdentifier: HeroesCell.identifier)
    }
}

// MARK: - Table View Datasource
extension PrincipalTableViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return data.count
        }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroesCell.identifier) as? HeroesCell
        let data = data[indexPath.row]
        cell?.configure(with: data)
        cell?.accessoryType = .disclosureIndicator
        return cell ?? UITableViewCell()
    }
}
// MARK: - Table View Delegate
extension PrincipalTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        let dataDetail = DetailHeroProvider.init(detailInfo: data[indexPath.row])
        let detailViewController = DetailViewController(data: dataDetail)
        navigationController?.show(detailViewController, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

 
