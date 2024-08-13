//
//  SettingViewController.swift
//  SnapPop
//
//  Created by 이인호 on 8/9/24.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountInfoTableViewCell.self, forCellReuseIdentifier: AccountInfoTableViewCell.identifier)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.register(AppLockSettingTableViewCell.self, forCellReuseIdentifier: AppLockSettingTableViewCell.identifier)
        
        return tableView
    }()
    
    private let footerView = UIView()
    
    private lazy var footerButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 탈퇴", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        button.addAction(UIAction { [weak self] _ in
            self?.showDeleteAccountAlert()
        }, for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(settingTableView)
        footerView.addSubview(footerButton)
        
        footerButton.translatesAutoresizingMaskIntoConstraints = false
        settingTableView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            settingTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            settingTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            footerButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            footerButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: 8)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // 계정 정보
        case 1:
            return 1 // 보안 및 개인정보
        case 2:
            return 1 // 로그아웃
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountInfoTableViewCell.identifier, for: indexPath) as? AccountInfoTableViewCell else {
                return UITableViewCell()
            }
            
            if let user = AuthViewModel.shared.currentUser {
                cell.configure(with: user)
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppLockSettingTableViewCell.identifier, for: indexPath) as? AppLockSettingTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: "로그아웃")
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            showLogoutAlert()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "계정 정보"
        case 1:
            return "보안 및 개인정보"
        case 2:
            return "계정 관리"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 2:
            return footerView
        default:
            return nil
        }
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "SnapPop", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "로그아웃", style: .default, handler: { _ in
            AuthViewModel.shared.signOut { result in
                switch result {
                case .success:
                    print("Successfully signed out")
                case .failure(let error):
                    print("Error signing out: \(error.localizedDescription)")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func showDeleteAccountAlert() {
        let alert = UIAlertController(title: "SnapPop", message: "정말 탈퇴 하시겠습니까? 모든 데이터가 삭제됩니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "회원탈퇴", style: .default, handler: { [weak self] _ in
            AuthViewModel.shared.deleteCurrentUser(on: self ?? UIViewController())
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension SettingViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        else {
            print("Unable to retrieve AppleIDCredential")
            return
        }
        
        guard AuthViewModel.shared.currentNonce != nil else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        guard let appleAuthCode = appleIDCredential.authorizationCode else {
            print("Unable to fetch authorization code")
            return
        }
        
        guard let authCodeString = String(data: appleAuthCode, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleAuthCode.debugDescription)")
            return
        }
        
        Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
        AuthViewModel.shared.currentUser?.delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
            } else {
                print("Successfully deleted user")
            }
        }
    }
}