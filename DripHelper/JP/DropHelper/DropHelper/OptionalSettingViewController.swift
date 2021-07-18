//
//  OptionalSettingViewController.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/06/29.
//

import UIKit
import MessageUI

class OptionalSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    struct Setting {
        var title : String
        var mode : Int
        var keyID : String
        var indexPathToSWTag : Int
        
        init(title: String, mode: Int, keyID: String, indexPathToSWTag: Int){
            self.title = title
            self.mode = mode
            self.keyID = keyID
            self.indexPathToSWTag = indexPathToSWTag
        }
        
    }
    
    private let sections = ["点滴計算","情報"]
    var allSetting : [[Setting]] = []
    
    // indexPath.sectionで取得できる番号の順番
    // indexPath.rowで取得できる番号の順番
    
    // [Section 0]
    let SECTION_CUL_TIMING = 0
    // [Row]
    let ROW_OPTION_INFUSION_SET = 0
    let ROW_SOUND_SELECT = 1
    let ROW_VIBRATION = 2
    let ROW_SHAKE_RESET = 3
    let ROW_SYNC_WATCH = 4
    let ROW_FLOW_RATE = 5
    
    // [Section 1]
    let SECTION_INFO = 1
    // [Row]
    let ROW_REVIEW_KEY = 0
    let ROW_CONTACT_KEY = 1
    let ROW_RECOMMEND_KEY = 2
    let ROW_APP_VERSION_KEY = 3
    let ROW_MY_APP_KEY = 4
    
   
    // インデックス番号をスイッチ切り替え時に取得できるTag番号へ変換（インデックス番号だとセクション区切りのため）
    let SWTAG_OPTION_INFUSION_SET = 0
    let SWTAG_SOUND_SELECT = 1
    let SWTAG_VIBRATION = 2
    let SWTAG_SHAKE_RESET = 3
    let SWTAG_SYNC_WATCH = 4
    let SWTAG_FLOW_RATE = 5
        
    let SWTAG_REVIEW_KEY = 6
    let SWTAG_CONTACT_KEY = 7
    let SWTAG_RECOMMEND_KEY = 8
    let SWTAG_APP_VERSION_KEY = 9
    let SWTAG_MY_APP_KEY = 10
    
    
    private let CHEVRON_UI = 0 // シェブロン（Disclosure Indicator）での遷移の場合に使用
    let SWITCH_UI = 1 // スイッチ切り替えの場合に使用
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    
    func dataSET(){
        let section0Setting : [Setting] = [
            Setting(title: "他のセット", mode: CHEVRON_UI, keyID: KEY_OPTION_INFUSION_SET, indexPathToSWTag: SWTAG_OPTION_INFUSION_SET),
            Setting(title: "点滴の音", mode: CHEVRON_UI, keyID: KEY_SOUND_SELECT, indexPathToSWTag: SWTAG_SOUND_SELECT),
            Setting(title: "点滴のバイブレーション", mode: SWITCH_UI, keyID: KEY_VIBRATION, indexPathToSWTag: SWTAG_VIBRATION),
            Setting(title: "シェイクでリセット", mode: SWITCH_UI, keyID: KEY_SHAKE_RESET, indexPathToSWTag: SWTAG_SHAKE_RESET),
            Setting(title: "WatchAppと設定値の同期(iOSのみ)", mode: SWITCH_UI, keyID: KEY_SYNC_WATCH, indexPathToSWTag: SWTAG_SYNC_WATCH),
            Setting(title: "「1時間あたりの滴下量」の入力", mode: SWITCH_UI, keyID: KEY_SETTING_FLOW_RATE, indexPathToSWTag: SWTAG_FLOW_RATE)
        ]
        let section1Setting : [Setting] = [
            Setting(title: "レビュー", mode: CHEVRON_UI, keyID: KEY_REVIEW, indexPathToSWTag: SWTAG_REVIEW_KEY),
            Setting(title: "問い合わせ", mode: CHEVRON_UI, keyID: KEY_CONTACT, indexPathToSWTag: SWTAG_CONTACT_KEY),
            Setting(title: "友達におすすめ", mode: CHEVRON_UI, keyID: KEY_RECOMMEND, indexPathToSWTag: SWTAG_RECOMMEND_KEY),
            Setting(title: "App Version", mode: CHEVRON_UI, keyID: KEY_APP_VERSION, indexPathToSWTag: SWTAG_APP_VERSION_KEY),
            Setting(title: "このアプリについて", mode: CHEVRON_UI, keyID: KEY_MY_APP, indexPathToSWTag: SWTAG_MY_APP_KEY)
        ]
        
        allSetting.append(section0Setting)
        allSetting.append(section1Setting)
    }
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataSET()
        
        // 使うxibファイルを指定
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        
         // UITableViewの空セルのseparatorを消す
        tableView.tableFooterView = UIView(frame: .zero)
        
        
        
    }
    
    // ヘッダーの大きさを設定する
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let size = self.view.frame.size
        
        //比較の基準を設定
        let horizontalSizeClass = UITraitCollection(horizontalSizeClass: .regular)

        if traitCollection.containsTraits(in: horizontalSizeClass){
            // ヘッダーViewの高さを返す
            return 30
        }else{
            if size.width > size.height {
                // ヘッダーViewの高さを返す
                return 20
            }else{
                // ヘッダーViewの高さを返す
                return 20
            }
        }
        
    }

    // フッターの大きさを設定する
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let size = self.view.frame.size
        
        //比較の基準を設定
        let horizontalSizeClass = UITraitCollection(horizontalSizeClass: .regular)

        if traitCollection.containsTraits(in: horizontalSizeClass){
            // ヘッダーViewの高さを返す
            return 10
        }else{
            if size.width > size.height {
                // ヘッダーViewの高さを返す
                return 5
            }else{
                // ヘッダーViewの高さを返す
                return 5
            }
        }
    }
    
    // セルの大きさを設定する
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = self.view.frame.size
        
        //比較の基準を設定
        let horizontalSizeClass = UITraitCollection(horizontalSizeClass: .regular)

        if traitCollection.containsTraits(in: horizontalSizeClass){
            // ヘッダーViewの高さを返す
            return 60
        }else{
            if size.width > size.height {
                // ヘッダーViewの高さを返す
                return 50
            }else{
                // ヘッダーViewの高さを返す
                return 50
            }
        }
        
    }
    
    // 設定画面がアクティブになったとき
    override func viewDidAppear(_ animated: Bool) {
        //テーブルを更新
        tableView.reloadData()
    }
    // セクション合計数を指定
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // セクション名を指定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    /// セルの個数を指定（UITableViewDataSource required）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allSetting[section].count
    }
    
    /// セルに値を設定（UITableViewDataSource required）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        
        var value = userDefaults.string(forKey: allSetting[indexPath.section][indexPath.row].keyID)
        
        cell.title.text = allSetting[indexPath.section][indexPath.row].title
        cell.value.tag = allSetting[indexPath.section][indexPath.row].indexPathToSWTag
        
        
        // シェブロン（"＞"マーク）をUIに追加する関数
        func chevronUI_Create(){
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        
        // スイッチをCellに追加する関数
        // スイッチのあるインデックス番号を取得するには、タグの値にその番号を入れる必要がある。
        // 構造体のデータだとセクションを超えたインデックス番号の参照が困難であったため、構造体の中にインデックス番号を割り当てている。
        func switchUI_Create(){
            let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 100, height: cell.frame.height))
            //スイッチの状態
            switchView.setOn(userDefaults.bool(forKey: allSetting[indexPath.section][indexPath.row].keyID), animated: true)
            
            //スイッチのタグにindexPath情報をスイッチ用へ変換したものを入れる。
            switchView.tag = allSetting[indexPath.section][indexPath.row].indexPathToSWTag
            
            //スイッチが押されたときの動作
            switchView.addTarget(self, action: #selector(fundlSwitch(_:)), for: UIControl.Event.valueChanged)
                
            cell.accessoryView = switchView
        }
        
        
        switch indexPath.section {
        case SECTION_CUL_TIMING:
            switch indexPath.row {
            case ROW_OPTION_INFUSION_SET:
                chevronUI_Create()
                if(value=="0"){
                    value = "-"
                }
                else{
                    value = value! + " 滴/mL"
                }
                
                cell.value.text = value
                
                break
            case ROW_SOUND_SELECT:
                chevronUI_Create()
                if(value==String(DROP_SOUND_ID_NO_SOUND)){
                    value = DROP_SOUND_TITLE_NO_SOUND
                }
                else if (value==String(DROP_SOUND_ID_1)){
                    value = DROP_SOUND_TITLE_1
                }
                else if (value==String(DROP_SOUND_ID_2)){
                    value = DROP_SOUND_TITLE_2
                }
                else if (value==String(DROP_SOUND_ID_3)){
                    value = DROP_SOUND_TITLE_3
                }
                else if (value==String(DROP_SOUND_ID_4)){
                    value = DROP_SOUND_TITLE_4
                }
                else if (value==String(DROP_SOUND_ID_5)){
                    value = DROP_SOUND_TITLE_5
                }
                else if (value==String(DROP_SOUND_ID_6)){
                    value = DROP_SOUND_TITLE_6
                }
                else if (value==String(DROP_SOUND_ID_7)){
                    value = DROP_SOUND_TITLE_7
                }
                else if (value==String(DROP_SOUND_ID_8)){
                    value = DROP_SOUND_TITLE_8
                }
                else if (value==String(DROP_SOUND_ID_9)){
                    value = DROP_SOUND_TITLE_9
                }else{
                    value = "ERR"
                }
                cell.value.text = value
                break
            case ROW_VIBRATION:
                switchUI_Create()
                break
            case ROW_SHAKE_RESET:
                switchUI_Create()
                break
            case ROW_SYNC_WATCH:
                switchUI_Create()
                break
            case ROW_FLOW_RATE:
                switchUI_Create()
                break
            default:
                break
            }
            
        case SECTION_INFO:
            switch indexPath.row {
            case ROW_REVIEW_KEY:
                chevronUI_Create()
                cell.value.text = value
                break
            case ROW_CONTACT_KEY:
                chevronUI_Create()
                cell.value.text = value
                break
            case ROW_RECOMMEND_KEY:
                cell.value.text = value
                break
            case ROW_APP_VERSION_KEY:
                cell.value.text = value
                break
            case ROW_MY_APP_KEY:
                chevronUI_Create()
                break
            default:
                break
            }
        default:
            break
        }
        
        
        // セルが選択された時の背景色を消す
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
    
    
    
    /// セル選択時（UITableViewDataSource optional）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case SECTION_CUL_TIMING:
            switch indexPath.row {
            case ROW_OPTION_INFUSION_SET:
                // 次の画面へ移動
                performSegue(withIdentifier: "OptionInfusionSet", sender: allSetting[indexPath.section][indexPath.row].title)
                break
            case ROW_SOUND_SELECT:
                performSegue(withIdentifier: "soundSelect", sender: allSetting[indexPath.section][indexPath.row].title)
                break
            case ROW_VIBRATION:
                break
            case ROW_SHAKE_RESET:
                break
            case ROW_SYNC_WATCH:
                break
            case ROW_FLOW_RATE:
                break
            default:
                break
            }
            
        case SECTION_INFO:
            switch indexPath.row {
            case ROW_REVIEW_KEY:
                // アップルストアへ移動
                reviewApp()
                break
            case ROW_CONTACT_KEY:
                // メール送信画面へ移動
                tapMailButton()
                break
            case ROW_RECOMMEND_KEY:
                shareApp()
                // 共有画面へ移動
                break
            case ROW_APP_VERSION_KEY:
                break
            case ROW_MY_APP_KEY:
                performSegue(withIdentifier: "AboutThisApp", sender: allSetting[indexPath.section][indexPath.row].title)
                break
            default:
                break
            }
        default:
            break
        }
        tableView.reloadData()
        
    }
    
    
    
    //スイッチのテーブルが変更されたときに呼ばれる
    @objc func fundlSwitch(_ sender: UISwitch) {
        
        /*
         sender.tagにはスイッチのセルの位置が入る(Int)
         sender.isOnにはスイッチのon/off情報が入る(Bool)
         下のprint文はセル内のラベルの内容とスイッチのTrue/False
         */
        
        switch sender.tag {
        case SWTAG_OPTION_INFUSION_SET:
            break
        case SWTAG_SOUND_SELECT:
            break
        case SWTAG_VIBRATION: // "点滴のバイブレーション"
            userDefaults.set(sender.isOn, forKey: allSetting[0][2].keyID)
            break
        case SWTAG_SHAKE_RESET: // "シェイクでリセット"
            userDefaults.set(sender.isOn, forKey: allSetting[0][3].keyID)
            break
        case SWTAG_SYNC_WATCH: // "使用中はリセットしない"
            userDefaults.set(sender.isOn, forKey: allSetting[0][4].keyID)
            break
        case SWTAG_FLOW_RATE: // "使用中はリセットしない"
            userDefaults.set(sender.isOn, forKey: allSetting[0][5].keyID)
            break
        case SWTAG_REVIEW_KEY:
            break
        case SWTAG_CONTACT_KEY:
            break
        case SWTAG_RECOMMEND_KEY:
            break
        case SWTAG_APP_VERSION_KEY:
            break
        case SWTAG_MY_APP_KEY:
            break
        default:
            break
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tapMailButton() {

      // メールを送信できるかどうかの確認
      if !MFMailComposeViewController.canSendMail() {
        print("Mail services are not available")
        return
      }

      // インスタンスの作成とデリゲートの委託
      let mailViewController = MFMailComposeViewController()
          mailViewController.mailComposeDelegate = self

      // 宛先の設定（開発者側のアドレス）
      let toRecipients = ["xemwoo@gmail.com"]

      // 件名と宛先の表示
      mailViewController.setSubject("点滴計算の開発者へメール")
      mailViewController.setToRecipients(toRecipients)
      mailViewController.setMessageBody("", isHTML: false)

      // mailViewControllerの反映（メール内容の反映）
      self.present(mailViewController, animated: true, completion: nil)
    }
    
    // メール機能終了処理
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

      // メールの結果で条件分岐
      switch result {

      // キャンセルの場合
      case .cancelled:
        print("Email Send Cancelled")
        break

      // 下書き保存の場合
      case .saved:
        print("Email Saved as a Draft")
        break

      // 送信成功の場合
      case .sent:
        print("Email Sent Successfully")
        break

      // 送信失敗の場合
      case .failed:
        print("Email Send Failed")
        break
      default:
        break
      }

      //メールを閉じる
      controller.dismiss(animated: true, completion: nil)
    }
    
    func shareApp(){
        let productURL:URL = URL(string: "https://itunes.apple.com/jp/app/id1576102500")!
        
        let activityViewController = UIActivityViewController(
            activityItems: [productURL],
            applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func reviewApp(){
        let productURL:URL = URL(string: "https://itunes.apple.com/app/id1576102500?action=write-review")!
        
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        guard let writeReviewURL = components?.url else {
            return
        }
        
        UIApplication.shared.open(writeReviewURL)
    }
}
