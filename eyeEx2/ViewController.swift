//
//  ViewController.swift
//  eyeEx
//
//  Created by inooph on 6/3/24.
//

import UIKit
//import Lottie

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet var lbsArr: [UILabel]!
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var btnInfo: UIButton!
    
    var isLight: Bool {
        return `switch`.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), 
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        
        _ = lbsArr.enumerated().map { (idx, element) in
            element.tag = idx
        }
        changeLbCol()
        
        // 태그 맞게 들어갔는지 확인
        //lbsArr.forEach { lb in
        //    print("\(lb.text ?? "") / \(lb.tag)")
        //}
    }
    
    deinit {
        // 뷰 컨트롤러가 해제될 때 옵저버 제거
        print("\n---> deinit")
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        print("\n---> willEnterForeground")
        startAnimation()
    }
    
    @objc func didEnterBackground() {
        print("\n---> didEnterBackground")
    }
    
    // MARK: - Actions
    /**
     눈운동 애니메이션 뷰
     */
    func startAnimation() {
        UIView.animate(withDuration: 5, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut]
                       , animations: {
                [weak self] in
                self?.imgView.transform = .init(scaleX: 0.2, y: 0.2)
            }
                           , completion: { _ in
                self.imgView.transform = .init(scaleX: 1, y: 1)
            }
        )
    }
    
    /**
     Switch toggle action
     */
    @IBAction func valueChanged(_ sender: UISwitch) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.imgView.tintColor       = sender.isOn ? .black : .white
            self?.view.backgroundColor    = sender.isOn ? .white : .black
            self?.btnInfo.tintColor       = sender.isOn ? .systemGray4 : .darkGray
            
            self?.changeLbCol()
        }
    }
    
    /**
     라벨컬러 변경
     */
    func changeLbCol() {
        _ = lbsArr.enumerated().map { (idx, element) in
            if idx == 0 {
                element.changeStatus(!isLight ? true : false)
            } else if idx == 1 {
                element.changeStatus(isLight ? true : false)
            }
        }
    }
    
    
    @IBAction func showInfoPopoverVC(_ sender: UIButton) {
        
        if let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "InfoPopOverVC") as? InfoPopOverVC{
            popVC.modalPresentationStyle                                    = .popover
            popVC.popoverPresentationController?.permittedArrowDirections   = .up
            popVC.popoverPresentationController?.delegate                   = self
            popVC.popoverPresentationController?.sourceView                 = sender
            popVC.popoverPresentationController?.sourceRect                 = sender.bounds
            
            popVC.view.backgroundColor  = isLight ? .white : #colorLiteral(red: 0.1307884455, green: 0.141463995, blue: 0.157846421, alpha: 1)
            popVC.lbDesc.textColor      = isLight ? .black : .white
            
            popVC.preferredContentSize = .init(width: 276, height: 93)
            self.present(popVC, animated: true)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - Extension Label
extension UILabel {
    /**
     스위치 토글할 때 상태값에 따라서 색 바꾸기
     */
    func changeStatus(_ isActive: Bool) {
        self.textColor = isActive ? .systemGreen : .gray
    }
}
