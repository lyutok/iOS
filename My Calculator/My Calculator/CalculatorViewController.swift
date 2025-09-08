//
//  CalculatorViewController.swift
//  My Calculator
//
//  Created by Lyudmila Tokar on 9/7/25.
//

import UIKit

class CalculatorViewController: UIViewController {

    private let displayLabel = UILabel()
    private var currentInput: String = "0"
    private var firstOperand: Double?
    private var operation: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        // Display label
        displayLabel.text = currentInput
        displayLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        displayLabel.textColor = #colorLiteral(red: 1, green: 0.3882352941, blue: 0.3882352941, alpha: 1)
        displayLabel.textAlignment = .right
        displayLabel.numberOfLines = 1
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displayLabel)

        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayLabel.heightAnchor.constraint(equalToConstant: 80)
        ])

        // Buttons layout (added ".")
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
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
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
                button.titleLabel?.tintColor = #colorLiteral(red: 0.9411764706, green: 0.4156862745, blue: 0.4, alpha: 1)
                button.backgroundColor = #colorLiteral(red: 0.6470588235, green: 0.8274509804, blue: 0.8509803922, alpha: 1)
                button.layer.cornerRadius = 10
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }

            stackView.addArrangedSubview(rowStack)
        }
    }

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
}
