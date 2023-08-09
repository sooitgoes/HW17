//
//  ViewController.swift
//  HW17
//
//  Created by Михаил Латий on 09.08.2023.
//

import UIKit

class ViewController: UIViewController {
    private var isBackgroundColorWhite = false

    // MARK: - UI Elements
    private lazy var passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.textAlignment = .center
        passwordField.font = .systemFont(ofSize: 15)
        passwordField.backgroundColor = .systemGray
        passwordField.isSecureTextEntry = true
        passwordField.layer.cornerRadius = 20
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        return passwordField
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Pass"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var buttonForPasswordGeneration: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate a password ", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(generatePassword), for: .touchUpInside)
        return button
    }()

    private lazy var backgroundColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change background color", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(changeBackgroundColor), for: .touchUpInside)
        return button
    }()

    private lazy var stackButtons: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup
    private func setupHierarchy() {
        stackButtons.addArrangedSubview(backgroundColorButton)
        stackButtons.addArrangedSubview(buttonForPasswordGeneration)
        view.addSubview(activityIndicator)
        view.addSubview(passwordField)
        view.addSubview(passwordLabel)
        view.addSubview(stackButtons)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),

            passwordField.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 100),
            passwordField.bottomAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: -100),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            backgroundColorButton.heightAnchor.constraint(equalToConstant: 44),
            backgroundColorButton.widthAnchor.constraint(equalToConstant: 150),

            buttonForPasswordGeneration.heightAnchor.constraint(equalToConstant: 44),
            buttonForPasswordGeneration.widthAnchor.constraint(equalToConstant: 150),

            stackButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120)


        ])
    }

    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
        }

        passwordField.text = password
        passwordField.isSecureTextEntry = false
        passwordLabel.text = password

    }

    // MARK: - Action
    @objc func changeBackgroundColor() {
        if isBackgroundColorWhite {
            view.backgroundColor = .black
            isBackgroundColorWhite.toggle()
        } else {
            view.backgroundColor = .systemBackground
            isBackgroundColorWhite.toggle()
        }
    }

    @objc func generatePassword() {
        activityIndicator.startAnimating()
        bruteForce(passwordToUnlock: "e22")
    }
}

