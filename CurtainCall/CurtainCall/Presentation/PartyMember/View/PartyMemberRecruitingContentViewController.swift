//
//  File.swift
//  CurtainCall
//
//  Created by 김민석 on 2023/07/17.
//

import UIKit
import Combine

import SnapKit

final class PartyMemberRecruitingContentViewController: UIViewController {
    
    // MARK: - UI properties
    
    private let step1Label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x273041)
        label.text = "Step 1"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let step2Label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x273041)
        label.text = "Step 2"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let step3Label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x273041)
        label.text = "Step 3"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let stepLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let step1View: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x273041)
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return view
    }()
    
    private let step2View: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x273041)
        return view
    }()
    
    private let step3View: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x273041)
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let stepViewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        return stackView
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x273041)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "공연 관람"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let titleWriteLabel: UILabel = {
        let label = UILabel()
        label.text = "제목을 적어주세요."
        label.textColor = UIColor(rgb: 0x273041)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let titleWriteEssentialLabel: UILabel = {
        let label = UILabel()
        label.text = "필수"
        label.textAlignment = .center
        label.textColor = UIColor(rgb: 0xFF5792)
        label.layer.borderColor = UIColor(rgb: 0xFF5792).cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 11
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private lazy var titleWriteTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = UIColor(rgb: 0xF5F6F8)
        textField.placeholder = "예시) OOO 함께 볼 사람 구해요!"
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.textColor = UIColor(rgb: 0x828996)
        textField.layer.cornerRadius = 10
        textField.addLeftPadding(width: 18)
        textField.setPlaceholderColor(color: UIColor(rgb: 0x828996))
        return textField
    }()
    
    private let contentWriteLabel: UILabel = {
        let label = UILabel()
        label.text = "내용을 적어주세요."
        label.textColor = UIColor(rgb: 0x273041)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let contentWriteEssentialLabel: UILabel = {
        let label = UILabel()
        label.text = "필수"
        label.textAlignment = .center
        label.textColor = UIColor(rgb: 0xFF5792)
        label.layer.borderColor = UIColor(rgb: 0xFF5792).cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 11
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(rgb: 0xF5F6F8)
        textView.textColor = UIColor(rgb: 0x828996)
        textView.font = .systemFont(ofSize: 15, weight: .medium)
        textView.textContainerInset = .init(top: 12, left: 18, bottom: 12, right: 18)
        textView.layer.cornerRadius = 12
        textView.text = Constants.PARTY_MEMBER_PRODUCT_CONTENT_TEXTVIEW_PLACEHOLDER
        textView.delegate = self
        return textView
    }()
    
    private let contentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x828996)
        label.font = .systemFont(ofSize: 12)
        label.text = "글자수 제한 (0/400)"
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성 완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor(rgb: 0xDCDEE1)
        button.setTitleColor(UIColor(rgb: 0x99A1B2), for: .normal)
        button.layer.cornerRadius = 12
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: PartyMemberRecruitingContentViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Lifecycles
    
    init(viewModel: PartyMemberRecruitingContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardWhenTappedArround()
        bind()
        
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        configureSubviews()
        configureConstraints()
        configureNavigation()
    }
    
    private func configureSubviews() {
        view.backgroundColor = .white
        view.addSubviews(
            stepLabelStackView, stepViewStackView, titleView, titleWriteLabel,
            titleWriteEssentialLabel, titleWriteTextField, contentWriteLabel,
            contentWriteEssentialLabel, contentTextView, contentCountLabel, nextButton
        )
        stepLabelStackView.addArrangedSubviews(step1Label, step2Label, step3Label)
        stepViewStackView.addArrangedSubviews(step1View, step2View, step3View)
        titleView.addSubview(titleLabel)
    }
    
    private func configureConstraints() {
        stepLabelStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        stepViewStackView.snp.makeConstraints {
            $0.top.equalTo(stepLabelStackView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(8)
        }
        titleView.snp.makeConstraints {
            $0.top.equalTo(stepViewStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        titleWriteLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(11)
            $0.leading.equalToSuperview().offset(24)
        }
        titleWriteEssentialLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleWriteLabel)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(40)
            $0.height.equalTo(22)
        }
        titleWriteTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(titleWriteLabel.snp.bottom).offset(10)
            $0.height.equalTo(42)
        }
        
        contentWriteLabel.snp.makeConstraints {
            $0.top.equalTo(titleWriteTextField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(24)
        }
        contentWriteEssentialLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentWriteLabel)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(40)
            $0.height.equalTo(22)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentWriteLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(227)
        }
        contentCountLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(24)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(55)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
    private func configureNavigation() {
        configureBackbarButton()
        title = "파티원 모집"
    }
    
    private func updateCountLabel(count: Int) {
        contentCountLabel.text = "글자수 제한 (\(count)/400)"
    }
    
    private func bind() {
        viewModel.isValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.setNextButton(isSelected: isValid)
            }.store(in: &cancellables)
    }
    
    private func setNextButton(isSelected: Bool) {
        nextButton.backgroundColor = isSelected ? UIColor(rgb: 0xFF7CAB) : UIColor(rgb: 0xDCDEE1)
        nextButton.setTitleColor(
            isSelected ? .white : UIColor(rgb: 0x99A1B2),
            for: .normal
        )
        nextButton.isUserInteractionEnabled = isSelected
    }
    
}

extension PartyMemberRecruitingContentViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        viewModel.titleTextFieldChanged(text: textField.text)
        return true
    }
}

extension PartyMemberRecruitingContentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.PARTY_MEMBER_PRODUCT_CONTENT_TEXTVIEW_PLACEHOLDER {
            textView.text = nil
            return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Constants.PARTY_MEMBER_PRODUCT_CONTENT_TEXTVIEW_PLACEHOLDER
            return
        }
        
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        guard let content = textView.text else { return false }
        viewModel.contentTextViewChanged(text: textView.text)
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard content.count <= 400 else { return false }
        updateCountLabel(count: content.count)
        return true
    }
}
