//
//  SettingsViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 29/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class SettingViewModel {
    typealias Callback = (SettingViewModel, Any?) -> Void
    enum AccessoryType: String {
        case onOff
        case picker
    }
    struct PickerValue {
        var array: [String]
        var index: Int?
    }
    let title: String
    let type: AccessoryType
    let callback: Callback
    private(set) var value: Any?
    
    var pickerValue: PickerValue {
        get { return value as? PickerValue ?? PickerValue(array: [], index: nil) }
        set { self.value = newValue }
    }
    var boolValue: Bool {
        get { return value as? Bool ?? false }
        set { self.value = newValue }
    }
    
    init(title: String, type: AccessoryType, callback: @escaping Callback) {
        self.title = title
        self.type = type
        self.callback = callback
    }
    
    func didCallback(sender: Any?) {
        self.callback(self, sender)
    }
    
    func didSelect() {
        self.callback(self, nil)
    }
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private(set) var bgImageView: UIImageView!
    private(set) var logoImageView: UIImageView!
    private(set) var tableView: UITableView!
    
    var settings: [SettingViewModel] = []

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Настройки"
        
        let manager = SettingsManager.shared
        
        let backgroundMeasure = SettingViewModel(title: "Измерение в фоне",
                                                 type: .onOff,
                                                 callback: { (model, _) in
            let value = model.boolValue
            manager.isMeasuringInBackgroundOn = value
        })
        backgroundMeasure.boolValue = true
        
        let timeInterval = SettingViewModel(title: "Интервал измерения",
                                            type: .picker) { (model, sender) in
                                                let index = sender as! Int
                                                switch index {
                                                case 1:
                                                    manager.measuringTimeInterval = 1800
                                                case 2:
                                                    manager.measuringTimeInterval = 2700
                                                case 3:
                                                    manager.measuringTimeInterval = 3600
                                                default:
                                                    manager.measuringTimeInterval = 900
                                                }
        }
        let index: Int
        switch SettingsManager.shared.measuringTimeInterval {
        case 0...900:
            index = 0
        case 901...1800:
            index = 1
        case 1801...2700:
            index = 2
        case 2701...3600:
            index = 3
        default: index = 0
        }
        timeInterval.pickerValue = SettingViewModel.PickerValue(array: ["15 мин", "30 мин", "45 мин", " 1 час"], index: index)
        
        self.settings = [backgroundMeasure, timeInterval]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.bgImageView = UIImageView(image: UIImage(named: "settings_back"))
        self.bgImageView.contentMode = .scaleAspectFill
        self.view.addSubview(self.bgImageView)
        self.bgImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.logoImageView = UIImageView(image: UIImage(named: "lounch-icon"))
        self.logoImageView.contentMode = .scaleAspectFit
        self.bgImageView.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(112)
            make.centerX.equalToSuperview()
        }
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoImageView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = self.settings[indexPath.row]
        let cellId = setting.type.rawValue
        
        var cell: SettingCell! = tableView.dequeueReusableCell(withIdentifier: cellId) as? SettingCell
        if cell == nil {
            let new = SettingCell(style: .value1, reuseIdentifier: cellId)
            cell = new
        }
        cell.configure(with: setting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? SettingCell {
            cell.didSelect()
        }
    }
}


class SettingCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.textColor = UIColorFromHex(rgbValue: 0xDBE0EA)
        self.detailTextLabel?.textColor = UIColorFromHex(rgbValue: 0xD0E0E0)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
    }
    
    func didSelect() {
        if let type = self.viewModel?.type {
            if type == .picker {
                let tf = self.makeTextField()
                self.contentView.addSubview(tf)
                tf.becomeFirstResponder()
            }
        }
    }
    
    func configure(with model: SettingViewModel) {
        self.viewModel = model
        
        self.textLabel?.text = model.title
        
        switch model.type {
    
        case .onOff:
            let sw = self.makeSwithView()
            sw.isOn = model.boolValue
            self.accessoryView = sw
            self.selectionStyle = .none
            
        case .picker:
            let tf = self.makeTextField()
            let picker = tf.inputView as! UIPickerView
            if let row = model.pickerValue.index {
                let value = model.pickerValue.array[row]
                self.detailTextLabel?.text = value
                picker.selectRow(row, inComponent: 0, animated: false)
            }
            self.insertSubview(tf, at: 0)
            self.accessoryView = nil
            self.accessoryType = .disclosureIndicator
            self.selectionStyle = .default
        }
    }
    
    @objc
    func actionSwitch(_ sender: UISwitch) {
        self.viewModel?.boolValue = sender.isOn
        self.viewModel?.didCallback(sender: sender.isOn)
    }
    
    private func makeSwithView() -> UISwitch {
        if let rightView = self.rightView {
            return rightView as! UISwitch
        }
        let view = UISwitch()
        view.addTarget(self, action: #selector(actionSwitch(_:)), for: .valueChanged)
        self.rightView = view
        return view
    }
    
    private func makeTextField() -> UITextField {
        if let rightView = self.rightView {
            return rightView as! UITextField
        }
        let view = UITextField()
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        view.inputView = picker
        self.rightView = view
        return view
    }
    
    private weak var viewModel: SettingViewModel?
    private var rightView: UIView?
    
    // MARK: - UIPickerViewDelegate, UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel?.pickerValue.array.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.detailTextLabel?.text = self.viewModel?.pickerValue.array[row]
        self.makeTextField().resignFirstResponder()
        self.viewModel?.pickerValue.index = row
        self.viewModel?.didCallback(sender: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel?.pickerValue.array[row]
    }
}
