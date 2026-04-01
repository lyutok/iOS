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
    
    private var hours: WorkingHours {
        presets[selectedIndex]
    }
    
    private var customStart = Date()
    private var customEnd = Date()
    
    private var isStartPickerVisible = false
    private var isEndPickerVisible = false
    
    // MARK: - Init  (forces insetGrouped style)
    convenience init() {
        self.init(style: .insetGrouped)
    }

    override init(style: UITableView.Style) {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        super.init(style: .insetGrouped)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomWorkingHours(hours: hours)
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dismissKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    // Force-resign whoever triggered the keyboard, app-wide
    @objc private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
    
    // Tells iOS this view never needs keyboard input
    override var canBecomeFirstResponder: Bool { return false }
    
    // MARK: - Setup
    func setupCustomWorkingHours(hours: WorkingHours) {
        customStart = {
            var c = DateComponents()
            c.hour   = hours.startHour
            c.minute = hours.startMinute
            return Calendar.current.date(from: c) ?? Date()
        }()
        
        customEnd = {
            var c = DateComponents()
            c.hour   = hours.endHour
            c.minute = hours.endMinute
            return Calendar.current.date(from: c) ?? Date()
        }()
    }
    
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
        // Native iOS grouped background — light gray, rounded cards
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PresetCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomHeaderCell")
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
    
    // Always 2 sections: [0] Presets  [1] Custom
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return presets.count
        } else {
            // Row 0 is always the "Custom" toggle row
            guard isCustomSelected else { return 1 }
            // + Start row + optional start picker + End row + optional end picker
            var rows = 3  // Custom header + Starts + Ends
            if isStartPickerVisible { rows += 1 }
            if isEndPickerVisible   { rows += 1 }
            return rows
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return indexPath.section == 0
            ? presetCell(at: indexPath)
            : customCell(at: indexPath)
    }
    
    // MARK: - Section 0: Preset cells
    private func presetCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresetCell", for: indexPath)
        
        let isChecked = !isCustomSelected && selectedIndex == indexPath.row
        var config = cell.defaultContentConfiguration()
        config.text = presets[indexPath.row].displayString
        config.image = circleImage(filled: isChecked)
        config.imageProperties.tintColor = isChecked ? .systemGray : .systemGray3
        cell.contentConfiguration = config
        cell.accessoryView  = nil
        cell.accessoryType  = .none
        cell.selectionStyle = .default
        return cell
    }
    
    // MARK: - Section 1: Custom cells
    // Row layout (when isCustomSelected):
    //   0  – "Custom"  (toggle + checkmark)
    //   1  – "Starts"  + time value
    //   2  – Start picker           ← only when isStartPickerVisible
    //   2/3 – "Ends"   + time value
    //   3/4 – End picker            ← only when isEndPickerVisible
    private func customCell(at indexPath: IndexPath) -> UITableViewCell {
        
        // ── Row 0: "Custom" toggle ──────────────────────────────────────
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CustomHeaderCell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = "Custom"
            config.image = circleImage(filled: isCustomSelected)
            config.imageProperties.tintColor = isCustomSelected ? .systemGray : .systemGray3
            cell.contentConfiguration = config
            cell.accessoryView  = nil
            cell.accessoryType  = .none
            cell.selectionStyle = .default
            return cell
        }
        
        // ── Rows below only exist when isCustomSelected == true ──────────
        let startPickerRow = 2
        let endRow         = isStartPickerVisible ? 3 : 2
        let endPickerRow   = endRow + 1
        
        if indexPath.row == 1 {
            // Starts row
            return timeRow(title: "Starts", time: formattedTime(customStart))
            
        } else if indexPath.row == startPickerRow && isStartPickerVisible {
            // Start picker
            return pickerCell(for: indexPath, isStart: true)
            
        } else if indexPath.row == endRow {
            // Ends row
            return timeRow(title: "Ends", time: formattedTime(customEnd))
            
        } else if indexPath.row == endPickerRow && isEndPickerVisible {
            // End picker
            return pickerCell(for: indexPath, isStart: false)
        }
        
        return UITableViewCell()
    }
    
    // "Starts" / "Ends" row — label on left, blue time on right
    private func timeRow(title: String, time: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text              = title
        cell.detailTextLabel?.text        = time
        cell.detailTextLabel?.textColor   = .label
        cell.selectionStyle               = .default
        return cell
    }
    
    // MARK: - Picker cell (unchanged logic, white background)
    private func pickerCell(for indexPath: IndexPath, isStart: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let picker = UIDatePicker()
        picker.datePickerMode         = .time
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval         = 30
        picker.date                   = isStart ? customStart : customEnd
        picker.tag                    = isStart ? 0 : 1
        picker.addTarget(self, action: #selector(timePickerChanged(_:)), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            picker.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            picker.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Helpers
    // Circle SF Symbol for left-side image in content configuration
    private func circleImage(filled: Bool) -> UIImage? {
        let name = filled ? "circle.fill" : "circle"
        return UIImage(systemName: name)
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // prevents locale overriding HH:mm
        formatter.dateFormat = "HH:mm"
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
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        
        if indexPath.section == 0 {
            // ── Preset selected ─────────────────────────────────────────
            isCustomSelected  = false
            selectedIndex     = indexPath.row
            setupCustomWorkingHours(hours: hours)   // seed Custom with preset values
            isStartPickerVisible = false
            isEndPickerVisible   = false
            tableView.reloadData()
            
        } else {
            // ── Custom section ───────────────────────────────────────────
            if indexPath.row == 0 {
                // Toggle Custom on/off
                isCustomSelected.toggle()
                if !isCustomSelected {
                    isStartPickerVisible = false
                    isEndPickerVisible   = false
                }
                tableView.reloadData()
                
            } else {
                // Starts / Ends rows
                let endRow = isStartPickerVisible ? 3 : 2
                
                if indexPath.row == 1 {
                    // Starts tapped
                    isStartPickerVisible.toggle()
                    isEndPickerVisible = false
                } else if indexPath.row == endRow {
                    // Ends tapped
                    isEndPickerVisible.toggle()
                    isStartPickerVisible = false
                }
                
                tableView.reloadData()
            }
        }
    }
}
