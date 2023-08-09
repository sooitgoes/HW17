//
//  ViewController.swift
//  HW17
//
//  Created by Михаил Латий on 09.08.2023.
//

import UIKit

class ViewController: UIViewController {
    private var isBackgroundColorWhite = false
    private var isStartGenerate = false
    private let queue = DispatchQueue.global(qos: .utility)

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

    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop generate", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(stopGenerate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        view.addSubview(stopButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),

            passwordField.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 100),
            passwordField.bottomAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: -80),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordLabel.heightAnchor.constraint(equalToConstant: 40),

            backgroundColorButton.heightAnchor.constraint(equalToConstant: 44),
            backgroundColorButton.widthAnchor.constraint(equalToConstant: 150),

            buttonForPasswordGeneration.heightAnchor.constraint(equalToConstant: 44),
            buttonForPasswordGeneration.widthAnchor.constraint(equalToConstant: 150),

            stackButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackButtons.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -20),

            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            stopButton.heightAnchor.constraint(equalToConstant: 44),
            stopButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    // MARK: - Action
    @objc func changeBackgroundColor() {
        view.backgroundColor = isBackgroundColorWhite ? .black : .systemBackground
        isBackgroundColorWhite.toggle()
    }

    @objc func generatePassword() {
        let password = passwordField.text
        activityIndicator.startAnimating()
        bruteForce(passwordToUnlock: password ?? "")
    }

    @objc func stopGenerate() {
        isStartGenerate.toggle()
        DispatchQueue.main.async {
            self.passwordLabel.text = "This password is safe"
        }
    }
}

// MARK: - Methods for generate password
extension ViewController {
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
        var password: String = ""

        queue.async {
            self.isStartGenerate = true
            while password != passwordToUnlock && self.isStartGenerate {
                password = self.generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)

                DispatchQueue.main.async {
                    self.passwordLabel.text = "Password: \(password)"
                }
            }

            DispatchQueue.main.async {
                self.passwordField.text = password
                self.passwordLabel.text = "Password: \(password)"
                self.passwordField.isSecureTextEntry = false
                self.activityIndicator.stopAnimating()
            }
        }
    }

    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
}
