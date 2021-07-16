//
//  InitTimerValueViewController.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/07/01.
//

import UIKit

class InitTimerValueViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var initTimerValueUIPickerView: UIPickerView!
    
    var dataList = [Int](repeating: 0, count: 59)
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    
    func dataListSet(){
        for i in 1..<59 {
            dataList[i]=i
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataListSet()
        // Do any additional setup after loading the view.
        
        let PickerNo = userDefaults.integer(forKey: KEY_INIT_TIMER_VALUE)
        // ここで初期値を設定している
        initTimerValueUIPickerView.selectRow(PickerNo, inComponent:0, animated: false)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        print(component)
        
        switch component {
                case 0:
                    return dataList.count
                case 1:
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
                    return String(dataList[row])
                
                case 1:
                    let min = UILabel()
                    min.text = "分前(点滴終了前)"  //minではなく自分の表示したいLabel名を入る。
                    initTimerValueUIPickerView.setPickerLabels(labels: [1: min]) //1のところはcaseと同じ数字を入れれば大丈夫です。
                    return ""
                
                
                default:
                    return "error"
                }
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        userDefaults.set(row, forKey: "initTimerValue")
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


