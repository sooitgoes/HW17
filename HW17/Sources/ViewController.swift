//
//  ViewController.swift
//  HW17
//
//  Created by Михаил Латий on 09.08.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI Elements


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup
    private func setupHierarchy() {

    }

    private func setupLayout() {
        NSLayoutConstraint.activate([

        ])
    }

    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            print(password)
        }
        print(password)
    }

    // MARK: - Action



}

