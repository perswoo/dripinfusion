//
//  TimerDisplaySequenceViewController.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/07/01.
//

import UIKit

class TimerDisplaySequenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var timerDisplaySequenceTableView: UITableView!
    
    
    private let sections = [""]
    struct Setting {
        var title : String
        var value : Int
        
        init(title: String, value: Int){
            self.title = title
            self.value = value
        }
    }
    
    
    
    var allSetting : [[Setting]] = []
    
    func dataSET(){
        let section0Setting : [Setting] = [
            Setting(title: "1:点滴中　2:完了", value: 0),
            Setting(title: "1:完了　2:点滴中", value: 1)
            
        ]
        
        allSetting.append(section0Setting)
    }
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataSET()
        
        timerDisplaySequenceTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // UITableViewの空セルのseparatorを消す
        timerDisplaySequenceTableView.tableFooterView = UIView(frame: .zero)
    }
    
    // セクション合計数を指定
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // 現在のセクション数を指定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // 現在のセクション数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSetting[section].count
    }
    
    /// セルに値を設定（UITableViewDataSource required）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timerDisplaySequenceTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        
        cell.title.text = allSetting[indexPath.section][indexPath.row].title
        
        // 過去の設定にチェックマークを入れる
        if(allSetting[indexPath.section][indexPath.row].value == userDefaults.integer(forKey: KEY_TIMER_DISPLAY_SEQUENCE)){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        // セルが選択された時の背景色を消す
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    /// セル選択時（UITableViewDataSource optional）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at:indexPath)

        // チェックマークを入れる
        cell!.accessoryType = .checkmark
        timerDisplaySequenceTableView.reloadData()
        
        
        userDefaults.set(allSetting[indexPath.section][indexPath.row].value, forKey: KEY_TIMER_DISPLAY_SEQUENCE)
        
        // 画面遷移元に戻る
        navigationController?.popViewController(animated: true)
        
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            
        let cell = tableView.cellForRow(at:indexPath)

        // チェックマークを外す
        cell?.accessoryType = .none
    }
    
    // ヘッダーの大きさを設定する
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // ヘッダーViewの高さを返す
        return 30
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
