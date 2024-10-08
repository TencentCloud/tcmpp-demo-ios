//
//  TCMPPPayView.swift
//  TCMPPDemo-Swift
//
//  Created by v_zwtzzhou on 2023/8/31.
//

import UIKit

private var PWD_COUNT: NSInteger { return 6 };

class TCMPPPayView : UIView, UITextFieldDelegate{
    @objc var title: String? {
        didSet{
            self.titleLabel?.text = title;
        }
    }
    @objc var detail: String? {
        didSet{
            self.detailLabel?.text = detail;
        }
    }
    @objc var defaultPass: String? {
        didSet{
            self.defaultPassLabel?.text = defaultPass;
        }
    }
    
    @objc var money: String?{
        didSet{
            let count = Float(money ?? "") ?? 0
            self.moneyLabel?.text = String(format: "$%.2f", count/100);
        }
    }
    @objc var completeHandle: ((String?) -> Void)?;
    @objc var cancelHandle: (() -> Void)?;
    
    private var paymentAlert: UIView?;
    private var inputV: UIView?;
    private var titleLabel: UILabel?;
    private var detailLabel: UILabel?;
    private var moneyLabel: UILabel?;
    private var pwdTextField: UITextField?;
    private var defaultPassLabel: UILabel?;
    private lazy var pwdIndicatorArr = [UIView]();
    private var tap: UITapGestureRecognizer?;
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.frame = UIScreen.main.bounds;
        self.backgroundColor = UIColor(white: 0, alpha: 0.3);
        self.createSubViews();
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShowNotify(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews(){
        let paymentWidth = UIScreen.main.bounds.size.width - 80;
        let alertHeight = 230.0;
        let titleHeight = 46.0
        
        let frame = CGRectMake(40, UIScreen.main.bounds.size.height - 216.0 - 100.0 - alertHeight,
                               paymentWidth, 230); // keyboardHeight, viewDistance
        let paymentAlert = UIView(frame:frame);
        paymentAlert.layer.cornerRadius = 5.0;
        paymentAlert.layer.masksToBounds = true;
        paymentAlert.backgroundColor = UIColor(white: 1, alpha: 0.95);
        self.paymentAlert = paymentAlert;
        self.addSubview(paymentAlert);
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, paymentWidth, titleHeight));
        titleLabel.textAlignment = .center;
        titleLabel.textColor = .black;
        titleLabel.font = UIFont.systemFont(ofSize: 17);
        self.titleLabel = titleLabel;
        paymentAlert.addSubview(titleLabel);
        
        let closeBtn = UIButton(type: .custom);
        closeBtn.frame = CGRectMake(0, 0, titleHeight, titleHeight);
        closeBtn.setTitle("╳", for: .normal);
        closeBtn.setTitleColor(.gray, for: .normal);
        closeBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside);
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15);
        paymentAlert.addSubview(closeBtn);
        
        let line = UIView(frame: CGRectMake(0, titleHeight, paymentWidth, 0.5));
        line.backgroundColor = .gray;
        paymentAlert.addSubview(line);
        
        let detailLabel = UILabel(frame: CGRectMake(0, titleHeight + 15, paymentWidth, 20));
        detailLabel.textAlignment = .center;
        detailLabel.textColor = .black;
        detailLabel.font = UIFont.systemFont(ofSize: 16);
        self.detailLabel = detailLabel;
        paymentAlert.addSubview(detailLabel);
        
        let moneyLabel = UILabel(frame: CGRectMake(0, titleHeight * 2, paymentWidth, 30));
        moneyLabel.textAlignment = .center;
        moneyLabel.textColor = .black;
        moneyLabel.font = UIFont.systemFont(ofSize: 33);
        self.moneyLabel = moneyLabel;
        paymentAlert.addSubview(moneyLabel);
        
        let inputView = UIView(frame: CGRectMake(15,
                                                 paymentAlert.bounds.size.height - (paymentWidth - 30) / 6.0 - 35,
                                                 paymentWidth - 30, (paymentWidth - 30) / 6.0));
        inputView.backgroundColor = .white;
        inputView.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor;
        inputView.layer.borderWidth = 1;
        self.inputV = inputView;
        paymentAlert.addSubview(inputView);
        
        let pwdTextField = UITextField(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        pwdTextField.isHidden = true;
        pwdTextField.delegate = self;
        pwdTextField.keyboardType = .numberPad;
        self.pwdTextField = pwdTextField;
        inputView.addSubview(pwdTextField);
        
        let defaultPassLabelWidth = paymentAlert.bounds.size.height - (paymentWidth - 30) / 6 - 30 + (paymentWidth - 30) / 6;
        let defaultPassLabel = UILabel(frame: CGRectMake(15, defaultPassLabelWidth, paymentWidth, 20));
        defaultPassLabel.textAlignment = .left;
        defaultPassLabel.textColor = .gray;
        defaultPassLabel.font = UIFont.systemFont(ofSize: 12);
        self.defaultPassLabel = defaultPassLabel;
        paymentAlert.addSubview(defaultPassLabel);
        
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
                
        let pwdCount = 6;
        let dotWidth = 10.0;
        let width = inputView.bounds.size.width / CGFloat(pwdCount);
        for i in 0...pwdCount {
            let frame = CGRectMake((width - dotWidth) / 2.0 + CGFloat(i) * width,
                                   (inputView.bounds.size.height - dotWidth) / 2.0,
                                   dotWidth, dotWidth)
            let dot = UIView(frame: frame);
            dot.backgroundColor = .black;
            dot.layer.cornerRadius = dotWidth / 2.0;
            dot.clipsToBounds = true;
            dot.isHidden = true;
            inputV?.addSubview(dot);
            self.pwdIndicatorArr.append(dot);
            
            if (pwdCount - 1 == i){
                continue;
            }
            
            let line = UIView(frame: CGRectMake(CGFloat(i + 1) * width, 0, 0.5, inputView.bounds.size.height));
            line.backgroundColor = UIColor(white: 0.9, alpha: 1.0);
            inputV?.addSubview(line);
            
            inputV?.addGestureRecognizer(tap!);
        }
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        pwdTextField?.becomeFirstResponder()
    }
    
    @objc func show(){
        let keyWindow = UIApplication.shared.keyWindow;
        keyWindow?.addSubview(self);
        
//        self.paymentAlert?.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.paymentAlert?.alpha = 0;
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.pwdTextField?.becomeFirstResponder();
//            self.paymentAlert?.transform = CGAffineTransformIdentity;
            self.paymentAlert?.alpha = 1.0;
        }
    }
    
    @objc private func cancel(){
        self.perform(#selector(dismiss), with: nil, afterDelay: 0);
        self.cancelHandle?();
    }
    
    @objc private func dismiss(){
        self.pwdTextField?.resignFirstResponder();
        UIView.animate(withDuration: 0) {
            self.paymentAlert?.transform = CGAffineTransformMakeScale(0.5, 0.5);
            self.paymentAlert?.alpha = 0;
            self.alpha = 0;
        } completion: { bool in
            self.removeFromSuperview();
        };
    }
    
    @objc func onKeyboardWillShowNotify(_ notification: Notification) {
        guard let keyBoardUserInfo = notification.userInfo,
              let endRect = keyBoardUserInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = endRect.size.height
        
        self.paymentAlert?.frame = CGRect(x: 40, y: UIScreen.main.bounds.size.height - keyboardHeight - 100 - 230, width: UIScreen.main.bounds.size.width - 80, height: 230)
    }
    
    ///UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.count ?? 0 >= PWD_COUNT && string.count > 0) {
            // 输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
            return false;
        }
        
        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^[0-9]*$");
        if (!predicate.evaluate(with: updatedText)) {
            return false;
        }
        
        var totalString: String?;
        if (string.count <= 0){
            if textField.text?.count == 0 {
                totalString = ""
            } else {
                totalString = String(textField.text!.prefix(textField.text!.count - 1));
            }
        } else {
            totalString = String(format: "%@%@", textField.text!, string);
        }
        self.setLab(totalString!.count);
        
        if (6 == totalString?.count){
            if (self.completeHandle != nil){
                self.perform(#selector(dismiss), with: nil, afterDelay: 0);
                self.completeHandle!(totalString);
            }
        }
        
        return true;
    }
    
    private func setLab(_ count: Int){
        self.pwdIndicatorArr.forEach({ label in
            label.isHidden = true;
        })
      
        for i in 0..<count {
            self.pwdIndicatorArr[i].isHidden = false;
        }
    }
}

