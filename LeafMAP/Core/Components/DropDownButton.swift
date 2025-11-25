//
//  DropDownButton.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class DropDownButton: UIView {
    //MARK: - Properties
    private var isError: Bool = false
    private var options: [String] = []
    private var selectedIndex: Int?
    var onSelect: ((String, Int) -> Void)?
    
    //MARK: - Components
    private lazy var circleIcon = UIImageView().then {
        $0.image = UIImage(named: "circle")
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont(name: AppFontName.pSemiBold, size: 18)
        $0.textColor = .gray900
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private lazy var dropDownButton = UIButton().then {
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.lightGray, for: .disabled)
        $0.addTarget(self, action: #selector(dropDownTapped), for: .touchUpInside)
    }
    
    private lazy var arrowIcon = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.tintColor = .lightGray
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var dropDownTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.isHidden = true
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        $0.delegate = self
        $0.dataSource = self
    }
    
    private lazy var errorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .systemRed
        $0.isHidden = true
    }
    
    //MARK: - init
    init(title: String, placeholder: String = "", options: [String] = []) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.titleLabel.text = title
        self.options = options
        setView()
        setConstraints()
        setPlaceholder(placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    private func setView() {
        addSubview(circleIcon)
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(dropDownButton)
        containerView.addSubview(arrowIcon)
        addSubview(errorLabel)
        addSubview(dropDownTableView)
    }
    
    private func setConstraints() {
        circleIcon.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.size.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(-1)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        dropDownButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(arrowIcon.snp.leading).offset(-8)
        }
        
        arrowIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        dropDownTableView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(dropDownTableView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    @objc private func dropDownTapped() {
        if dropDownTableView.isHidden {
            showDropDown()
        } else {
            hideDropDown()
        }
    }
    
    private func showDropDown() {
        let height = min(CGFloat(options.count) * 44, 200)
        
        dropDownTableView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dropDownTableView.isHidden = false
            self.arrowIcon.transform = CGAffineTransform(rotationAngle: .pi)
            self.layoutIfNeeded()
        }
    }
    
    private func hideDropDown() {
        dropDownTableView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dropDownTableView.isHidden = true
            self.arrowIcon.transform = .identity
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - Public Methods
    func getSelectedText() -> String? {
        guard let index = selectedIndex else { return nil }
        return options[index]
    }
    
    func getSelectedIndex() -> Int? {
        return selectedIndex
    }
    
    func setOptions(_ options: [String]) {
        self.options = options
        dropDownTableView.reloadData()
    }
    
    func selectOption(at index: Int) {
        guard index < options.count else { return }
        selectedIndex = index
        dropDownButton.setTitle(options[index], for: .normal)
        dropDownButton.setTitleColor(.black, for: .normal)
        hideError()
    }
    
    func setSelectedOption(_ option: String) {
        guard let index = options.firstIndex(of: option) else {
            return
        }
        selectOption(at: index)
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
        dropDownButton.setTitle(placeholder, for: .normal)
        dropDownButton.setTitleColor(.lightGray, for: .normal)
    }
    
    func reset() {
        selectedIndex = nil
        dropDownButton.setTitleColor(.lightGray, for: .normal)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension DropDownButton: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.selectionStyle = .none
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = UIColor.systemGray6
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        dropDownButton.setTitle(options[indexPath.row], for: .normal)
        dropDownButton.setTitleColor(.black, for: .normal)
        hideDropDown()
        hideError()
        onSelect?(options[indexPath.row], indexPath.row)
        tableView.reloadData()
    }
}

