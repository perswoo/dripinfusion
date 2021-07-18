//
//  OptionInfusionSetViewController.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/07/01.
//

import UIKit
import MessageUI

class OptionInfusionSetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var optionInfusionSet: UIPickerView!
    
    var dataList = [Int](repeating: 0, count: 100)

    func dataListSet(){
        for i in 0..<100 {
            dataList[i]=i
        }
        
    }
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataListSet()
        // Do any additional setup after loading the view.
        
        let PickerNo = userDefaults.integer(forKey: "optionInfusionSet")
        // ここで初期値を設定している
        optionInfusionSet.selectRow(PickerNo, inComponent: 1, animated: false)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
                case 0:
                    return 1
                case 1:
                    return dataList.count
                case 2:
                    return 1
                default:
                    return 0
                }
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        switch component {
                case 0:
                    let min = UILabel()
                    min.text = "他のセット"  //minではなく自分の表示したいLabel名を入る。
                    optionInfusionSet.setPickerLabels(labels: [0: min]) //1のところはcaseと同じ数字を入れれば大丈夫です。
                    return ""
                
                case 1:
                    return String(dataList[row])
                
                case 2:
                    let min = UILabel()
                    min.text = UNT_DROP_INFUSION_SET  //minではなく自分の表示したいLabel名を入る。
                    optionInfusionSet.setPickerLabels(labels: [2: min]) //1のところはcaseと同じ数字を入れれば大丈夫です。
                    return ""
                
                default:
                    return "error"
                }
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        userDefaults.set(row, forKey: "optionInfusionSet")
        print(row)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//　固定のセルを追加するために、既存のクラスに別のメソッドを作成
extension UIPickerView {
    func setPickerLabels(labels: [Int:UILabel]) { // [component number:label]

        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = self.frame.size.width / CGFloat(self.numberOfComponents)
        //let x:CGFloat = self.frame.origin.x
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)

        for i in 0...self.numberOfComponents {

            if let label = labels[i] {
                label.frame = CGRect(x: labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                self.addSubview(label)
            }
        }
    }
}
