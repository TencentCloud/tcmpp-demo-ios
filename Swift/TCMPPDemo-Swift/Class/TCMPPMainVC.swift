//
//  TCMPPMainVC.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/14.
//

import UIKit

class TCMPPMainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AppCellDelegate {
    
    var header: UIView!
    var bottom: UIView!
    var leftBtn: UIButton!
    var rightBtn: UIButton!
    var leftLine: UIView!
    var rightLine: UIView!
    var tableView: UITableView!
    var _menu: TCMPPMenuView!
    var tap: UITapGestureRecognizer!
    var demoList: [TMFAppletSearchInfo] = []
    var recentList: [TMFMiniAppInfo] = []
    var dataSource: [Any] = []
    var selectIndex = 0
    
    let cellIdentifier = "cellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("MiniApp Assistant", comment: "")
        self.edgesForExtendedLayout = []
        let itemBtn = UIButton()
        itemBtn.setImage(UIImage(named: "more"), for: .normal)
        itemBtn.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
        let item = UIBarButtonItem(customView: itemBtn)
        self.navigationItem.rightBarButtonItem = item
        initUI()
        appletListChange()
        NotificationCenter.default.addObserver(self, selector: #selector(appletListChange), name: NSNotification.Name(rawValue: "com.tencent.tcmpp.apps.change.notification"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.roundingCorners([.bottomLeft, .bottomRight], cornerRadius: 10)
        bottom.roundingCorners([.topLeft, .topRight], cornerRadius: 10)

        leftLine.roundingCorners(.allCorners, cornerRadius: 2)
        rightLine.roundingCorners(.allCorners, cornerRadius: 2)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initUI() {
        self.view.backgroundColor = UIColor.tcmpp_color(withHex: "#F4F4F4")
        
        let header = UIView()
        header.backgroundColor = .white
        self.view.addSubview(header)
        self.header = header
        
        let logoIV = UIImageView()
        logoIV.image = UIImage(named: "tcmpp_logo")
        header.addSubview(logoIV)
        
        let logoLab = UILabel()
        logoLab.textColor = .black
        logoLab.font = UIFont.systemFont(ofSize: 25)
        logoLab.text = "TCMPP"
        header.addSubview(logoLab)
        
        let detailLab = UILabel()
        detailLab.textColor = .black
        detailLab.font = UIFont.italicSystemFont(ofSize: 12)
        detailLab.textAlignment = .center
        detailLab.text = "A platform that takes your App to the next level"
        header.addSubview(detailLab)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        logoIV.translatesAutoresizingMaskIntoConstraints = false
        logoLab.translatesAutoresizingMaskIntoConstraints = false
        detailLab.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.view.topAnchor),
            header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 100),
            
            logoIV.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: (self.view.frame.size.width - 135) / 2),
            logoIV.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            logoIV.widthAnchor.constraint(equalToConstant: 30),
            logoIV.heightAnchor.constraint(equalToConstant: 30),
            
            logoLab.leadingAnchor.constraint(equalTo: logoIV.trailingAnchor, constant: 10),
            logoLab.topAnchor.constraint(equalTo: logoIV.topAnchor),
            logoLab.widthAnchor.constraint(equalToConstant: 95),
            logoLab.heightAnchor.constraint(equalToConstant: 30),
            
            detailLab.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            detailLab.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            detailLab.topAnchor.constraint(equalTo: logoLab.bottomAnchor, constant: 20),
            detailLab.heightAnchor.constraint(equalToConstant: 15),
        ])
        
        let bottom = UIView()
        bottom.backgroundColor = .white
        self.view.addSubview(bottom)
        self.bottom = bottom
        
        let leftBtn = UIButton()
        leftBtn.tag = 0
        leftBtn.setTitle(NSLocalizedString("My mini programs", comment: ""), for: .normal)
        leftBtn.setTitleColor(.black, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftBtn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
        bottom.addSubview(leftBtn)
        self.leftBtn = leftBtn
        
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.tcmpp_color(withHex: "#006EFF")
        bottom.addSubview(leftLine)
        self.leftLine = leftLine
        
        let rightBtn = UIButton()
        rightBtn.tag = 1
        rightBtn.setTitle(NSLocalizedString("Recently used", comment: ""), for: .normal)
        rightBtn.setTitleColor(.lightGray, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightBtn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
        bottom.addSubview(rightBtn)
        self.rightBtn = rightBtn
        
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.tcmpp_color(withHex: "#006EFF")
        rightLine.alpha = 0.0
        bottom.addSubview(rightLine)
        self.rightLine = rightLine
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TCMPPAppCell.self, forCellReuseIdentifier: cellIdentifier)
        bottom.addSubview(tableView)
        self.tableView = tableView
        
        bottom.translatesAutoresizingMaskIntoConstraints = false
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        rightBtn.translatesAutoresizingMaskIntoConstraints = false
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottom.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 15),
            bottom.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottom.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            leftBtn.topAnchor.constraint(equalTo: bottom.topAnchor, constant: 20),
            leftBtn.widthAnchor.constraint(equalToConstant: 180),
            leftBtn.centerXAnchor.constraint(equalTo: bottom.centerXAnchor, constant: -180 / 2),
            leftBtn.heightAnchor.constraint(equalToConstant: 22),
            
            leftLine.topAnchor.constraint(equalTo: leftBtn.bottomAnchor, constant: 10),
            leftLine.widthAnchor.constraint(equalToConstant: 20),
            leftLine.centerXAnchor.constraint(equalTo: leftBtn.centerXAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 4),
            
            rightBtn.topAnchor.constraint(equalTo: bottom.topAnchor, constant: 20),
            rightBtn.widthAnchor.constraint(equalToConstant: 180),
            rightBtn.centerXAnchor.constraint(equalTo: bottom.centerXAnchor, constant: 180 / 2),
            rightBtn.heightAnchor.constraint(equalToConstant: 22),
            
            rightLine.topAnchor.constraint(equalTo: rightBtn.bottomAnchor, constant: 10),
            rightLine.widthAnchor.constraint(equalToConstant: 20),
            rightLine.centerXAnchor.constraint(equalTo: rightBtn.centerXAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 4),
            
            tableView.topAnchor.constraint(equalTo: leftLine.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: bottom.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottom.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: bottom.centerXAnchor),
        ])
    }
    
    var menu: TCMPPMenuView? {
        if _menu == nil {
            let scan = TCMPPMenuItem()
            scan.icon = UIImage(named: "scanner")
            scan.title = NSLocalizedString("Scan", comment: "")
            scan.block = {
                TMFMiniAppSDKManager.sharedInstance().startUpMiniAppWithQRCode(withParentVC: self) { (error) in
                    self.showErrorInfo(error)
                }
            }
            
            let language = TCMPPMenuItem()
            language.icon = UIImage(named: "language")
            language.title = NSLocalizedString("Language", comment: "")
            language.block = {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                let vc = TCMPPLanguageSettingVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            let logout = TCMPPMenuItem()
            logout.icon = UIImage(named: "logout")
            logout.title = NSLocalizedString("Log out", comment: "")
            logout.block = {
                TMFMiniAppSDKManager.sharedInstance().terminateAllApplications()
                DemoUserInfo.shared.nickName = "unknown"
                let vc = TCMPPLoginVC()
                UIApplication.shared.keyWindow?.rootViewController = vc
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            }
            
            let items = [scan, language, logout]
            let menuView = TCMPPMenuView(menuItems: items)
            menuView.frame = CGRect(x: Int(self.view.frame.width) - 10 - 130, y: 10, width: 130, height: items.count * 50)
            menuView.roundingCorners(.allCorners, cornerRadius: 8.0)
            _menu = menuView
        }
        return _menu
    }
    
    @objc func clickBtn(_ sender: UIButton) {
        if sender.tag == 0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.leftBtn.setTitleColor(.black, for: .normal)
                self.rightBtn.setTitleColor(.lightGray, for: .normal)
                self.leftLine.alpha = 1.0
                self.rightLine.alpha = 0.0
            }, completion: nil)
            self.dataSource = self.demoList
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.leftBtn.setTitleColor(.lightGray, for: .normal)
                self.rightBtn.setTitleColor(.black, for: .normal)
                self.leftLine.alpha = 0.0
                self.rightLine.alpha = 1.0
            }, completion: nil)
            self.dataSource = self.recentList
        }
        self.selectIndex = sender.tag
        self.tableView.reloadData()
    }
    
    @objc func clickMore() {
        self.view.addSubview(self.menu!)
        self.tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.view.addGestureRecognizer(self.tap)
    }
    
    @objc func handleTapGesture(_ tap: UITapGestureRecognizer) {
        self.menu!.dismiss()
        self.view.removeGestureRecognizer(self.tap)
    }
    
    @objc func appletListChange() {
        initDataSource()
        if self.selectIndex == 0 {
            self.dataSource = self.demoList
        } else {
            self.dataSource = self.recentList
        }
        self.tableView.reloadData()
    }
    
    func initDataSource() {
        let list = TMFMiniAppSDKManager.sharedInstance().loadAppletsFromCache()
        self.recentList = list.compactMap { $0 as? TMFMiniAppInfo }
        if self.demoList.count > 0 {
            self.demoList.removeAll()
        }
        TMFMiniAppSDKManager.sharedInstance().searchApplets(withName: "") { (datas, error) in
            if let datas = datas {
                self.demoList.append(contentsOf: datas)
                if (self.selectIndex == 0) {
                    self.dataSource = self.demoList;
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func showErrorInfo(_ err: Error?) {
        guard let err = err else {
            return
        }
        var errMsg: String
        if err.localizedDescription.count > 0 {
            errMsg = "\(err.localizedDescription)\n\(err._code)\n\(err.localizedDescription)"
        } else {
            errMsg = "\(err.localizedDescription)\n\(err._code)"
        }
        let alert = UIAlertController(title: "Error", message: errMsg, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TCMPPAppCell
        if self.selectIndex == 0 {
            let info = self.dataSource[indexPath.row] as! TMFAppletSearchInfo
            cell.searchInfo = info
            cell.appInfo = nil
        } else {
            let info = self.dataSource[indexPath.row] as! TMFMiniAppInfo
            cell.searchInfo = nil
            cell.appInfo = info
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectIndex == 0 {
            let info = self.dataSource[indexPath.row] as! TMFAppletSearchInfo
            TMFMiniAppSDKManager.sharedInstance().startUpMiniApp(withAppID: info.appId, parentVC: self) { (error) in
                self.showErrorInfo(error)
            }
        } else {
            let info = self.dataSource[indexPath.row] as! TMFMiniAppInfo
            TMFMiniAppSDKManager.sharedInstance().startUpMiniApp(withAppID: info.appId, verType: info.verType, scene: .aioEntry, firstPage: nil, paramsStr: nil, parentVC: self) { (error) in
                self.showErrorInfo(error)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didClickMore(appId: String) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let alertA = UIAlertAction(title: NSLocalizedString("Preload", comment: ""), style: .default) { (action) in
            TMFMiniAppSDKManager.sharedInstance().preloadMiniApps([appId], isDownload: true) { (results, error) in
                if error == nil {
                    let icon = UIImage(named: "success")
                    let toast = ToastView(icon: icon!, title: NSLocalizedString("Preloaded successfully", comment: ""))
                    toast.show(withDuration: 2)
                }
            }
        }
        alertVC.addAction(alertA)
        
        let alertB = UIAlertAction(title: NSLocalizedString("Clear cache", comment: ""), style: .default) { (action) in
            TMFMiniAppSDKManager.sharedInstance().clearCache(withAppID: appId)
            let icon = UIImage(named: "success")
            let toast = ToastView(icon: icon!, title: NSLocalizedString("Cache cleared successfully", comment: ""))
            toast.show(withDuration: 2)
        }
        alertVC.addAction(alertB)
        
        let alertC = UIAlertAction(title: NSLocalizedString("Reset", comment: ""), style: .default) { (action) in
            TMFMiniAppSDKManager.sharedInstance().closeMiniApp(withAppID: appId)
            let icon = UIImage(named: "success")
            let toast = ToastView(icon: icon!, title: NSLocalizedString("Reset successfully", comment: ""))
            toast.show(withDuration: 2)
        }
        alertVC.addAction(alertC)
        
        let alertD = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertVC.addAction(alertD)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
