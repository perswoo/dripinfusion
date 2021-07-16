//
//  SoundSelectViewController.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/06/29.
//

import UIKit

class SoundSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var soundSelecttableView: UITableView!
    
    private let sections = ["",""]
    struct Sound {
        var title : String
        var soundID : Int
        
        init(title: String, soundID: Int){
            self.title = title
            self.soundID = soundID
        }
    }
    
    var allSounds : [[Sound]] = []
    
    func dataSET(){
        let section0Setting : [Sound] = [
            Sound(title: DROP_SOUND_TITLE_NO_SOUND, soundID: DROP_SOUND_ID_NO_SOUND),
            
        ]
        let section1Setting : [Sound] = [
            Sound(title: DROP_SOUND_TITLE_1, soundID: DROP_SOUND_ID_1),
            Sound(title: DROP_SOUND_TITLE_2, soundID: DROP_SOUND_ID_2),
            Sound(title: DROP_SOUND_TITLE_3, soundID: DROP_SOUND_ID_3),
            Sound(title: DROP_SOUND_TITLE_4, soundID: DROP_SOUND_ID_4),
            Sound(title: DROP_SOUND_TITLE_5, soundID: DROP_SOUND_ID_5),
            Sound(title: DROP_SOUND_TITLE_6, soundID: DROP_SOUND_ID_6),
            Sound(title: DROP_SOUND_TITLE_7, soundID: DROP_SOUND_ID_7),
            Sound(title: DROP_SOUND_TITLE_8, soundID: DROP_SOUND_ID_8),
            Sound(title: DROP_SOUND_TITLE_9, soundID: DROP_SOUND_ID_9)
        ]
        
        allSounds.append(section0Setting)
        allSounds.append(section1Setting)
    }
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataSET()
        
        soundSelecttableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // UITableViewの空セルのseparatorを消す
        soundSelecttableView.tableFooterView = UIView(frame: .zero)
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
        return allSounds[section].count
    }
    
    /// セルに値を設定（UITableViewDataSource required）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = soundSelecttableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        
        cell.title.text = allSounds[indexPath.section][indexPath.row].title
        
        // 過去の設定にチェックマークを入れる
        if(allSounds[indexPath.section][indexPath.row].soundID == userDefaults.integer(forKey: KEY_SOUND_SELECT)){
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
        
        soundSelecttableView.reloadData()
        
        userDefaults.set(allSounds[indexPath.section][indexPath.row].soundID, forKey: KEY_SOUND_SELECT)
        
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
