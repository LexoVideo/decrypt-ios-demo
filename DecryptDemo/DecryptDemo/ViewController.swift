//
//  ViewController.swift
//  DecryptDemo
//

import UIKit
import SnapKit
import DRMLib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let button = UIButton()
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        button.setTitle("解密", for: .normal)
        button.addTarget(self, action: #selector(checkDecrypt), for: .touchUpInside)
    }

    @objc
    func checkDecrypt() {
        print("start check")
        let util: DRMPlugin = .init()
        // get your encrypted file
        let encryptedUrl = Bundle.main.url(forResource: "encrypted", withExtension: "ts")!
        let encryptedData = try! Data(contentsOf: encryptedUrl)
        var decryptData: Data = Data()
        // to simulate stream data, pass piece to util process
        let pieceLen = 500
        for i in stride(from: 0, to: encryptedData.count, by: pieceLen) {
            let start = i
            let end = min(i + pieceLen, encryptedData.count)
            let subData = Data(encryptedData[start ..< end])
            // pass one piece data to util to process
            let decryptResult = util.process(url: encryptedUrl.absoluteString, data: subData)
            // check the result
            switch decryptResult {
            case .success(let success):
                // success, append it to the result
                decryptData.append(success)
            case .failure(let failure):
                // there's something happened
                switch failure {
                case .requireMoreData:
                    // the piece data is too small
                    // require more data to process decrypt
                    print("requre more data")
                    continue
                default:
                    // other exception, there must be some error
                    print("failure \(failure)")
                    fatalError()
                }
            }
        }
        
        // this is the origin file
        let rawUrl = Bundle.main.url(forResource: "original", withExtension: "ts")!
        let originData = try! Data(contentsOf: rawUrl)
        // finaly, check the result with the original data
        print("compare result \(decryptData == originData)")
    }

}

