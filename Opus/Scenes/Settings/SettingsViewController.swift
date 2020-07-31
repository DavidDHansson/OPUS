//
//  SettingsViewController.swift
//  Opus
//
//  Created by David Hansson on 26/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol SettingsDisplayLogic: class {
    func displaySomething(viewModel: Settings.Something.ViewModel)
}

class SettingsViewController: UIViewController, SettingsDisplayLogic {
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing)?
    
    var data = [
        [
            SettingsItem(title: "Test 1", type: .onOffSwitch(isOn: true)),
            SettingsItem(title: "Test 2", type: .onOffSwitch(isOn: false)),
            SettingsItem(title: "Test 3", type: .information)
        ],
        [
            SettingsItem(title: "Test 5", type: .information),
            SettingsItem(title: "Test 4", type: .reset)
        ],
    ]
    
    var headerTitles = ["Opus", "Andet"]
    
    public let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.backgroundColor = .clear
        t.alwaysBounceVertical = true
        t.showsVerticalScrollIndicator = false
        t.contentInset.top = 16
        t.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        t.register(SettingsHeaderView.self, forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
        return t
    }()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 250)
        
        // Add Subwiews
        view.addSubview(tableView)
        
        // Define Layout
        defineLayout()
        
        // Setup Tableview
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func defineLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: Do something
    
    func doSomething() {
        let request = Settings.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Settings.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else { fatalError() }
        let cellData = data[indexPath.section][indexPath.row]
        cell.data = cellData
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("Tap on s: \(indexPath.section), r: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else { return nil }
        let config = SettingsHeaderView.ViewModel(title: headerTitles[section])
        view.configure(config: config)
        return view
    }
    
}

extension SettingsViewController: SettingsCellDelegate {
    func didSwitch(isOn value: Bool, cell: SettingsItem) {
        print("Switch on title: \(cell.title)")
    }
}
