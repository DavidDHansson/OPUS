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
        [],
        [
            SettingsItem(title: "Om Mig", type: .aboutMe, opusType: nil, switchIsOn: false),
            SettingsItem(title: "Regler", type: .help, opusType: nil, switchIsOn: false)
        ],
        [
            SettingsItem(title: "Nulstil Indstillinger", type: .reset, opusType: nil, switchIsOn: false)
        ]
    ]
    
    var headerTitles = ["Opus", "Andet", "Nulstil"]
    
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

        // Load opus
        loadSettings()
        
        // Empty array before filling it
        data[0].removeAll(keepingCapacity: false)
        
        // Fill array from opus array
        for item in opus {
            data[0].append(SettingsItem(title: item.title, type: .onOffSwitch, opusType: item.type, switchIsOn: item.enabled))
        }
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
    
    private func saveSettings() {
        DispatchQueue.main.async {
            UserDefaults.standard.setStructArray(opus, forKey: "settings")
        }
    }
    
    private func loadSettings() {
        let data: [OpusType] = UserDefaults.standard.structArrayData(OpusType.self, forKey: "settings")
        opus = data
        
        print("\n--opus load--")
        for i in opus {
            print("\(i.title): \(i.enabled)")
        }
    }
    
    private func resetSettings() {
        opus = standardOpus
        saveSettings()
        
        // Empty local data array
        data[0].removeAll(keepingCapacity: false)
        
        // Fill array from standard opus
        for item in standardOpus {
            data[0].append(SettingsItem(title: item.title, type: .onOffSwitch, opusType: item.type, switchIsOn: item.enabled))
        }
        
        // Reload
        tableView.reloadData()
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
        cell.index = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = data[indexPath.section][indexPath.row]
        
        switch cell.type {
        case .onOffSwitch:
            guard let opusClass = opus.first(where: { $0.type == cell.opusType }) else { return }
            self.router?.navigateToInformation(with: opusClass)
        case .reset:
            resetSettings()
        case .aboutMe:
            self.router?.navigateToAboutMe()
        case .help:
            self.router?.navigateToHelp()
        }   
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
    func didSwitch(isOn value: Bool, indexPath: IndexPath) {
        
        // Update local data array
        guard let newState = data[indexPath.section][indexPath.row].switchIsOn else { return }
        data[indexPath.section][indexPath.row].switchIsOn = !newState
        
        print("\n--Local data save--")
        for i in data[indexPath.section] {
            print("\(i.title): \(String(describing: i.switchIsOn))")
        }
        
        // Update global opus Array
        let item = data[indexPath.section][indexPath.row]
        guard let index = opus.firstIndex(where: { $0.type ==  item.opusType }) else { return }
        opus[index].enabled = !newState
        
        print("\n--Opus data save--")
        for i in opus {
            print("\(i.title): \(i.enabled)")
        }
        
        // Save to disk
        saveSettings()
    }
}
