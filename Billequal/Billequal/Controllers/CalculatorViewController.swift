//
//  CalculatorViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 9/8/25.
//

import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate {

    private let displayLabel = UILabel()
    private var currentInput: String = "0"
    private var firstOperand: Double?
    private var operation: String?
    
    let personLabel = UILabel()
    private let personTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        // 1️⃣ Person row (Label + TextField)
        personLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        personLabel.textColor = UIColor(named: "MainFontColor")
        
        personTextField.delegate = self // for keyboard
        personTextField.placeholder = "Enter name"
        personTextField.borderStyle = .roundedRect
        personTextField.keyboardType = .default
        personTextField.autocapitalizationType = .words
        personTextField.tintColor = UIColor(named: "MainFontColor")
        personTextField.returnKeyType = .continue
        
        // 👇 disable autocomplete bar
        personTextField.autocorrectionType = .no
        personTextField.spellCheckingType = .no
        personTextField.smartInsertDeleteType = .no
        
        // 👇 Tap gesture to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let personRow = UIStackView(arrangedSubviews: [personLabel, personTextField])
        personRow.axis = .horizontal
        personRow.spacing = 10
        personRow.distribution = .fillEqually
        personRow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(personRow)
        
        NSLayoutConstraint.activate([
            personRow.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            personRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            personRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            personRow.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 2️⃣ Display label (below Person row)
        displayLabel.text = currentInput
        displayLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        displayLabel.textColor = UIColor(named: "MainFontColor")
        displayLabel.textAlignment = .right
        displayLabel.numberOfLines = 1
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displayLabel)
        
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: personRow.bottomAnchor, constant: 20),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // 3️⃣ Buttons layout
        let buttons: [[String]] = [
            ["7","8","9","÷"],
            ["4","5","6","×"],
            ["1","2","3","−"],
            ["0",".","C","="],
            ["+"] // last row only plus
        ]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        for row in buttons {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 10
            rowStack.distribution = .fillEqually
            
            for title in row {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .medium)
                button.tintColor = #colorLiteral(red: 0.9411764706, green: 0.4156862745, blue: 0.4, alpha: 1)
                button.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.8274509804, blue: 0.8509803922, alpha: 1)
                button.layer.cornerRadius = 10
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }
            stackView.addArrangedSubview(rowStack)
        }
        
        // 4️⃣ Done Button (below calculator stack)
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        doneButton.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.4156862745, blue: 0.4, alpha: 1)
        doneButton.tintColor = .white
        doneButton.layer.cornerRadius = 10
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 120),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true) // hides keyboard when tapping anywhere
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
    
    // MARK: - Calculatot Functionality
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        switch title {
        case "0"..."9":
            if currentInput == "0" {
                currentInput = title
            } else {
                currentInput += title
            }
            displayLabel.text = currentInput

        case ".":
            if !currentInput.contains(".") {
                currentInput += "."
                displayLabel.text = currentInput
            }

        case "+","−","×","÷":
            firstOperand = Double(currentInput)
            operation = title
            displayLabel.text = currentInput
            currentInput = "0"

        case "=":
            if let op = operation, let first = firstOperand, let second = Double(currentInput) {
                var result: Double = 0
                switch op {
                case "+": result = first + second
                case "−": result = first - second
                case "×": result = first * second
                case "÷": result = second != 0 ? first / second : 0
                default: break
                }
                currentInput = String(result)
                displayLabel.text = currentInput
                operation = nil
                firstOperand = nil
            }

        case "C":
            currentInput = "0"
            firstOperand = nil
            operation = nil
            displayLabel.text = currentInput

        default: break
        }
    }
    
    // MARK: - Done button action
    @objc private func doneTapped() {
        
        let name = personTextField.text ?? ""
        let result = displayLabel.text ?? "0"
        
        if name != "" {
            print(name)
        }
        print(result)
        
        self.dismiss(animated: true, completion: nil)
    }
}
