//
//  WorkingHoursViewController.swift
//  WhenItsTime
//
//  Created by Lyudmila Tokar on 3/31/26.
//

import UIKit

// MARK: - Delegate
protocol WorkingHoursDelegate: AnyObject {
    func didSaveWorkingHours(_ hours: WorkingHours)
}

class WorkingHoursViewController: UITableViewController {
    
    // MARK: - Properties
    weak var delegate: WorkingHoursDelegate?
    
    private let presets = WorkingHours.presets
    private var selectedIndex = 0        // which preset is selected
    private var isCustomSelected = false // is Custom row selected
    
    private var customStart = Date()
    private var customEnd = Date()
    
    private var isStartPickerVisible = false
    private var isEndPickerVisible = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
    }
    
//    // tells iOS this view never needs keyboard input
//    override var canBecomeFirstResponder: Bool {
//        return false }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Working Hours"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 190/255, alpha: 1.0)
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 190/255, alpha: 1.0)
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PresetCell")
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeCell")
        tableView.register(UITableViewCell(style: .value1, reuseIdentifier: "TimeCell").classForCoder, forCellReuseIdentifier: "TimeCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PickerCell")
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        // TODO: pass back selected hours
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension WorkingHoursViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isCustomSelected ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return presets.count + 1  // presets + Custom row
        } else {
            // Start row + optional picker + End row + optional picker
            var rows = 2
            if isStartPickerVisible { rows += 1 }
            if isEndPickerVisible { rows += 1 }
            return rows
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return presetCell(at: indexPath)
        } else {
            return customCell(at: indexPath)
        }
    }
    
    // MARK: - Section 0: Presets
    private func presetCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresetCell", for: indexPath)
        let isCustomRow = indexPath.row == presets.count
        
        if isCustomRow {
            cell.textLabel?.text = "Custom"
            let isSelected = isCustomSelected
            cell.imageView?.image = UIImage(systemName: isSelected ? "circle.fill" : "circle")
        } else {
            cell.textLabel?.text = presets[indexPath.row].displayString
            let isSelected = !isCustomSelected && selectedIndex == indexPath.row
            cell.imageView?.image = UIImage(systemName: isSelected ? "circle.fill" : "circle")
        }
        
        cell.imageView?.tintColor = .white
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 190/255, alpha: 1.0)
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Section 1: Custom
    private func customCell(at indexPath: IndexPath) -> UITableViewCell {
        // Start row is always row 0
        // If start picker visible → row 1 is picker, row 2 is End
        // If start picker not visible → row 1 is End
        
        let startPickerRow = 1
        let endRow = isStartPickerVisible ? 2 : 1
        let endPickerRow = endRow + 1
        
        if indexPath.row == 0 {
            // Start row
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath)
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "TimeCell")
            cell.textLabel?.text = "Starts"
            cell.detailTextLabel?.text = formattedTime(customStart)
  
            cell.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 190/255, alpha: 1.0)
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == startPickerRow && isStartPickerVisible {
            // Start picker
            return pickerCell(for: indexPath, isStart: true)
        } else if indexPath.row == endRow {
            // End row
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "TimeCell")
            cell.textLabel?.text = "Ends"
            cell.detailTextLabel?.text = formattedTime(customEnd)
            cell.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 190/255, alpha: 1.0)
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == endPickerRow && isEndPickerVisible {
            // End picker
            return pickerCell(for: indexPath, isStart: false)
        }
        
        return UITableViewCell()
    }
    
    // MARK: - Picker cell
    private func pickerCell(for indexPath: IndexPath, isStart: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath)
        
        // Clear existing pickers
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = 30
        picker.date = isStart ? customStart : customEnd
        picker.tag = isStart ? 0 : 1
        picker.addTarget(self, action: #selector(timePickerChanged(_:)), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            picker.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            picker.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        
        cell.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 190/255, alpha: 1.0)
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Helper
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    
    @objc private func timePickerChanged(_ picker: UIDatePicker) {
        if picker.tag == 0 {
            customStart = picker.date
        } else {
            customEnd = picker.date
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension WorkingHoursViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let isCustomRow = indexPath.row == presets.count
            
            if isCustomRow {
                isCustomSelected = true
                isStartPickerVisible = false
                isEndPickerVisible = false
            } else {
                isCustomSelected = false
                selectedIndex = indexPath.row
                isStartPickerVisible = false
                isEndPickerVisible = false
            }
            
            tableView.reloadData()
            
        } else {
            // Section 1 — Custom time rows
            let endRow = isStartPickerVisible ? 2 : 1
            
            if indexPath.row == 0 {
                // Tapped Start
                isStartPickerVisible.toggle()
                isEndPickerVisible = false
            } else if indexPath.row == endRow {
                // Tapped End
                isEndPickerVisible.toggle()
                isStartPickerVisible = false
            }
            
            tableView.reloadData()
        }
    }
}
