//
//  CalculatorViewController.swift
//  Billequal
//
//  Created by Lyudmila Tokar on 9/8/25.
//

import UIKit
import Foundation

// protocol for passing data back to CustomVC
protocol CalculatorViewControllerDelegate: AnyObject {
    func calculatorDidFinish(name: String, result: String)
}

class CalculatorViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: CalculatorViewControllerDelegate?

    private let displayLabel = UILabel()
    private let expressionLabel = UILabel()
    private var currentInput: String = "0"
    private var operation: String?
    private var textToCalculate: String = ""
    private var dotRemoved: Bool = false
    
    let personLabel = UILabel()
    private let personTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BgColor")
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        // 1️⃣ Person row (Label + TextField)
        personLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        personLabel.textColor = UIColor(named: K.customMainFontColor)
        personTextField.placeholder = "Enter name"
        personTextField.borderStyle = .roundedRect
            
        personTextField.delegate = self // for keyboard
        personTextField.keyboardType = .default
        personTextField.textContentType = .none
        personTextField.returnKeyType = .done
        personTextField.autocapitalizationType = .words
        personTextField.textColor = UIColor(named: K.customMainFontColor)
        
        personTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        personTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        personTextField.layer.borderWidth = 1
        personTextField.layer.cornerRadius = 8
        
        
        // create toolbar to keyboard
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // create flexible space (to push Done button to the right)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // create Done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        doneButton.tintColor = #colorLiteral(red: 0.4117647059, green: 0.7098039216, blue: 0.7450980392, alpha: 1)
                                             
        toolbar.items = [flexSpace, doneButton]
        
            
        // assign toolbar to your textField
        personTextField.inputAccessoryView = toolbar
        
        // placeholder text color
        personTextField.attributedPlaceholder = NSAttributedString(
            string: "Name (optional)",
            attributes: [.foregroundColor: UIColor.gray]
        )

        
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
        displayLabel.textColor = UIColor(named: K.customMainFontColor)
        displayLabel.textAlignment = .right
        displayLabel.numberOfLines = 1
        displayLabel.lineBreakMode = .byTruncatingHead   // adds “…” on the left
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displayLabel)
        
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: personRow.bottomAnchor, constant: 1),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // 2️⃣.1 Expression label (smaller grey text)
        expressionLabel.text = ""
        expressionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        expressionLabel.textColor = UIColor.gray
        expressionLabel.textAlignment = .right
        expressionLabel.numberOfLines = 1
        expressionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(expressionLabel)

        NSLayoutConstraint.activate([
            expressionLabel.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 1),
            expressionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expressionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            expressionLabel.heightAnchor.constraint(equalToConstant: 22)
        ])

        
        // 3️⃣ Buttons layout
        let buttons: [[String]] = [
            ["7","8","9","÷"],
            ["4","5","6","×"],
            ["1","2","3","−"],
            ["0",".","C","+"],
            ["="] // last row only plus
        ]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: expressionLabel.bottomAnchor, constant: 20),
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
        
        // 4️⃣ Submit Button (below calculator stack)
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        submitButton.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.4156862745, blue: 0.4, alpha: 1)
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 10
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        // 5️⃣ Cancel Button (below calculator stack)
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        cancelButton.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.6470588235, blue: 0.6392156863, alpha: 1)
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 10
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        // StackView for Submit + Cancel
        let bottomButtonsStack = UIStackView(arrangedSubviews: [cancelButton, submitButton])
        bottomButtonsStack.axis = .horizontal
        bottomButtonsStack.spacing = 20
        bottomButtonsStack.distribution = .fillEqually
        bottomButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomButtonsStack)
        
        NSLayoutConstraint.activate([
            bottomButtonsStack.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            bottomButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomButtonsStack.heightAnchor.constraint(equalToConstant: 44),
            bottomButtonsStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
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
    
    @objc func doneButtonTapped() {
        view.endEditing(true) // closes keyboard for any active textField
    }
    
    // MARK: - Calculatot Functionality
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        switch title {
        case "0"..."9":
            operation = nil
            if currentInput == "0" {
                currentInput = title
                print(currentInput)
            } else {
                currentInput += title
                print(currentInput)
            }
            textToCalculate += title
            print("textToCalculate:", textToCalculate)
            displayLabel.text = textToCalculate

        case ".":
            if let last = textToCalculate.last, "+−×÷".contains(last) {
                return
            } else if !currentInput.contains(".") || dotRemoved {
                if textToCalculate.isEmpty {
                    currentInput += "."
                    textToCalculate = textToCalculate + "0" + title
                    displayLabel.text = textToCalculate

                } else {
                    currentInput += "."
                    textToCalculate += title
                    displayLabel.text = textToCalculate
                }
                }
            dotRemoved = false

        case "+","−","×","÷":
            if textToCalculate == "" && ["×", "÷", "+"].contains(title) {
                return
            }
            if operation == nil && textToCalculate.last != "." {
                operation = title
                textToCalculate += title
                displayLabel.text = textToCalculate
                currentInput = "0"
            }

        case "=":
            // Check if string is only one character
            let operators: Set<String> = ["+", "−", "×", "÷", "=", ""]
            if operators.contains(textToCalculate) {
                print("= ", textToCalculate)
                return
            }
            
            // Check if there is no "nan", "inf" in the textToCalculate
            let nonValid = ["nan", "inf"]
            if nonValid.contains(where: { textToCalculate.lowercased().contains($0) }) {
                displayLabel.text = "Error"
                return
            }
            
            if let result = evaluate(textToCalculate) {
                displayLabel.text = String(format: "%g", result)
                print("Result: \(result)")
            } else {
                displayLabel.text = "Error"
                return
            }
            
            // Clean the last if "+-*/."
            if let last = textToCalculate.last, "+−×÷.".contains(last) {
                textToCalculate.removeLast()
            }

            // Update the UI
            expressionLabel.text = textToCalculate
            textToCalculate = displayLabel.text!
            currentInput = "0"
            operation = nil
            dotRemoved = false

        case "C":
            if expressionLabel.text?.isEmpty == false {
                displayLabel.text = "0"
                expressionLabel.text = ""
                textToCalculate = ""
            }
            
            if !textToCalculate.isEmpty {
             let last = textToCalculate.removeLast()
                if last == "." {
                    dotRemoved = true
                }
                
                if textToCalculate.isEmpty {
                    displayLabel.text = "0"
                    currentInput = "0"
                } else {
                    displayLabel.text = textToCalculate
                }
            }

        default: break
        }
    }
    
    func evaluate(_ math: String) -> Double? {
        var clean = math
                .replacingOccurrences(of: "−", with: "-")
                .replacingOccurrences(of: "×", with: "*")
                .replacingOccurrences(of: "÷", with: "/")
        
        // Remove trailing operator if present
            if let last = clean.last, "+-*/.".contains(last) {
                clean.removeLast()
            }
        
        // Convert only integers to decimals (skip existing decimals!)
        let regex = try! NSRegularExpression(pattern: #"(?<![\d.])(\d+)(?![\d.])"#)
            clean = regex.stringByReplacingMatches(
                in: clean,
                range: NSRange(clean.startIndex..., in: clean),
                withTemplate: "$1.0"
            )
        
        let exp = NSExpression(format: clean)
        return exp.expressionValue(with: nil, context: nil) as? Double
    }
    
    // MARK: - Submit/Cancel button actions
    @objc private func submitTapped() {
        let name = personTextField.text ?? ""
        let result = displayLabel.text ?? "0"
        
        delegate?.calculatorDidFinish(name: name, result: result)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
