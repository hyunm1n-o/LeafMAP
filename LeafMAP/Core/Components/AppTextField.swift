//
//  AppTextField.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class AppTextField: UIView {
    //MARK: - Properties
    private var iconName: String
    private var isError: Bool = false
    
    //MARK: - Components
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private lazy var iconView = UIImageView().then {
        $0.image = UIImage(named: iconName)
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var textField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.clearButtonMode = .never
        $0.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.lightGray
            ]
        )
    }
    
    private lazy var clearButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .lightGray
        $0.isHidden = true
        $0.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    private lazy var errorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemRed
        $0.isHidden = true
    }
    
    //MARK: - init
    init(iconName: String, placeholder: String = "") {
        self.iconName = iconName
        
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setView()
        setConstraints()
        setupTextFieldObserver()
        
        if !placeholder.isEmpty {
            setPlaceholder(placeholder)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    private func setView() {
        addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(textField)
        containerView.addSubview(clearButton)
        addSubview(errorLabel)
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(clearButton.snp.leading).offset(-8)
        }
        
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    @objc private func clearButtonTapped() {
        textField.text = ""
        clearButton.isHidden = true
        hideError()
    }
    
    //MARK: - TextField Observer
    private func setupTextFieldObserver() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        clearButton.isHidden = textField.text?.isEmpty ?? true
    }
    
    //MARK: - Public Methods
    func getText() -> String {
        return textField.text ?? ""
    }
    
    func setText(_ text: String) {
        textField.text = text
        clearButton.isHidden = text.isEmpty
    }
    
    func showError(message: String) {
        isError = true
        errorLabel.text = message
        errorLabel.isHidden = false
        containerView.layer.borderColor = UIColor.systemRed.cgColor
        
        // 에러 애니메이션
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 10, y: 0)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.containerView.transform = CGAffineTransform(translationX: -10, y: 0)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.containerView.transform = .identity
                }
            }
        }
    }
    
    func hideError() {
        isError = false
        errorLabel.isHidden = true
        containerView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setPlaceholder(_ placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.lightGray
            ]
        )
    }
    
    func setKeyboardType(_ type: UIKeyboardType) {
        textField.keyboardType = type
    }
    
    func setSecureTextEntry(_ isSecure: Bool) {
        textField.isSecureTextEntry = isSecure
    }
}
