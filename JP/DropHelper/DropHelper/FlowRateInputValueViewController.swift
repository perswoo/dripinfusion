//
//  FlowRateInputValueViewController.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/07/03.
//

import UIKit

class FlowRateInputValueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    
    @IBOutlet weak var fluidRateInputTableView: UITableView!
    
    @IBOutlet weak var InputTextField: UITextField!
    @IBOutlet weak var InputButton: UIButton!
    @IBOutlet weak var dataListEditButton: UIBarButtonItem!
    
    
    let userDefaults = UserDefaults.standard
    
    private let sections = [NSLocalizedString("Drip_History", comment: "") ]
    var flowRateInputList = [FlowRateInputList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fluidRateInputTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")

        if let storedData = UserDefaults().data(forKey: KEY_FLOW_RATE_INPUT_LIST) {
            do {
                let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData)
                flowRateInputList.append(contentsOf: unarchivedData as! [FlowRateInputList])
            } catch {
                print(error)
            }
        }
        
        
        
        //キーボードバーを作成
        let keyboardBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        keyboardBar.barStyle = UIBarStyle.default
        keyboardBar.sizeToFit()

        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)

        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(addButton(_:)))
        done.tintColor = .systemOrange

        let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.cancel))
        cancel.tintColor = .systemOrange

        keyboardBar.items = [cancel, spacer]

        // Set the bar.
        InputTextField.inputAccessoryView = keyboardBar
        
        
        // 画面を開いたら、テキストフィールドを入力可能状態にする。
        InputTextField.becomeFirstResponder()
       
        InputButton.layer.cornerRadius = 15.0
        InputButton.backgroundColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        InputButton.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        InputButton.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        InputButton.layer.borderWidth = 5
    }
    
    
    @IBAction func changeButtonStatus(_ sender: Any) {
        
        if (InputTextField.text!.count > 0){
            InputButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            InputButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
            InputButton.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }else{
            InputButton.backgroundColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            InputButton.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            InputButton.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
    }
    
    // 設定画面がアクティブになったとき
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // スクロールインジケータを一時的に表示
        self.fluidRateInputTableView.flashScrollIndicators()
    }
    
    
    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *ここから下はテーブルによるデータ入力に関する処理
    *
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    
    
    // セクション合計数を指定
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    /// セルの個数を指定（UITableViewDataSource required）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flowRateInputList.count
    }
    
    // セクション名を指定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    /// セルに値を設定（UITableViewDataSource required）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let flowRateInputList = flowRateInputList[indexPath.row]
        
        cell.textLabel?.text = flowRateInputList.flowRateInputValue! + UNT_DROP_FLOW_RATE
        
        if (flowRateInputList.flowRateInputValue == userDefaults.string(forKey: KEY_DROP_FLOW_RATE)){
            // チェックマークを入れる
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    
    /// セル選択時（UITableViewDataSource optional）
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let dataSet = flowRateInputList[indexPath.row].flowRateInputValue {
            // トップ画面の液量記録用
            userDefaults.set(dataSet, forKey: KEY_DROP_FLOW_RATE)
            
            // 入力3項目「輸液量・所要時間・滴下速度」のうち、一番最新の入力にフラグを入れる
            LeastInputItem = LEAST_INPUT_DROP_FLOW_RATE
            
            // 画面遷移元に戻る
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    /// セルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            flowRateInputList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            let userDefalults = UserDefaults.standard
            do {
                let data: Data = try NSKeyedArchiver.archivedData(withRootObject: self.flowRateInputList, requiringSecureCoding: false)
                userDefalults.set(data, forKey: KEY_FLOW_RATE_INPUT_LIST)
                userDefalults.synchronize()
            } catch {
                print(error)
            }
        }
    }
    
    
    // 並び替えはイベント検知したらデータを更新する
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveRowData = flowRateInputList[sourceIndexPath.row]
        flowRateInputList.remove(at: sourceIndexPath.row)
        flowRateInputList.insert(moveRowData, at: destinationIndexPath.row)
        
        let userDefalults = UserDefaults.standard
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: self.flowRateInputList, requiringSecureCoding: false)
            userDefalults.set(data, forKey: KEY_FLOW_RATE_INPUT_LIST)
            userDefalults.synchronize()
        } catch {
            print(error)
        }
    }
    
    

    
    /*
    // 文字制限
    func textField(_ textView: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentString = InputTextField.text, let _range = Range(range, in: currentString) {
                
                let newString = currentString.replacingCharacters(in: _range, with: string)
                
                
                // 数値でない場合には、falseを返す
                if Int(newString) == nil {
                    return Int(newString) != nil
                }
                
                // 最大文字数の制限
                return InputTextField.text!.count + (string.count - range.length) <= MAX_WORD_COUNT_DROP_FLUID_VOLUME
                
            } else {
                return false
            }
    }
    */
    


    @objc func cancel(_ sender: UIButton){
        // キャンセルボタンを押した時に、キーボードを閉じる
        InputTextField.resignFirstResponder()
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // スクロールした時に、キーボードを閉じる
        InputTextField.resignFirstResponder()
    }
    
    /*
     *  テキストで入力した計算式を、"＋"演算マークで区切ってString型の配列へ格納する。
     *  String型の配列をIntへ変換して、足し合わせる。
     *  引数；textFieldのstring変数
     *  戻り値；Int
     */
    func CulTextToIntAndCulcuate(RowInputText:String) -> Int {
        
        var rtrn_val : Int = 0 // 戻り値用変数
        
        // ① 検索対象文字列
        let string = RowInputText

        // ② 検索するパターン
        let pattern = "[1-9][0-9]*"
        
        /*
         *  パターン条件
         *  ■[1-9]   :      先頭に1〜9の値が入るようにする（0を除外する）
         *  ■[0-9+]*   :    次の桁からは0〜9の値が入るようにする。その他の値（0や＋）が来たらその前の値までを配列へ格納する
         *
         */

        // ③ NSRegularExpressionのインスタンス生成
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        // ④ 検索実行
        let results = regex.matches(in: string, options: [], range: NSRange(0..<string.count))

        
        // ⑤ 結果表示
        for result in results {
            for i in 0..<result.numberOfRanges {
                let start = string.index(string.startIndex, offsetBy: result.range(at: i).location)
                let end = string.index(start, offsetBy: result.range(at: i).length)
                let text = String(string[start..<end])
                
                // ⑥ 配列を数値に変換して戻り値用変数へ足し合わせる
                if let val = Int(text){
                    rtrn_val += val
                }
            }
        }
        return rtrn_val
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        
        
        
        let finalTextFieldAsInt: Int = CulTextToIntAndCulcuate(RowInputText : InputTextField.text!)
        let finalTextFieldAsString : String = String(finalTextFieldAsInt)
        
        // トップ画面の液量の登録
        userDefaults.set(finalTextFieldAsString, forKey: KEY_DROP_FLOW_RATE)
        
        // 入力3項目「輸液量・所要時間・滴下速度」のうち、一番最新の入力にフラグを入れる
        LeastInputItem = LEAST_INPUT_DROP_FLOW_RATE
        
        // [課題]　テキストと履歴リストが一致する際には履歴リストの登録を行わない
        //if (finalTextFieldAsString != userDefaults.string(forKey: KEY_DROP_FLOW_RATE)){
        //}
        
        
        // 履歴リストの登録
        let flowRateInputList = FlowRateInputList()
        flowRateInputList.flowRateInputValue = finalTextFieldAsString
        self.flowRateInputList.insert(flowRateInputList, at: 0)

        self.fluidRateInputTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)

        
        // ストアの更新？
        let userDefaults = UserDefaults.standard
        do {
            let archivedData: Data = try NSKeyedArchiver.archivedData(withRootObject: self.flowRateInputList, requiringSecureCoding: false)
            userDefaults.set(archivedData, forKey: KEY_FLOW_RATE_INPUT_LIST)
            userDefaults.synchronize()
        } catch {
            print(error)
        }
        
        
        
        // 画面遷移元に戻る
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func dataListEditButton(_ sender: Any) {
        
        if (dataListEditButton.title == NSLocalizedString("Drip_EditStart", comment: "") ){
            dataListEditButton.title = NSLocalizedString("Drip_EditDone", comment: "") 
            super.setEditing(true, animated: true)
            fluidRateInputTableView.setEditing(true, animated: true)
        }
        else{
            dataListEditButton.title = NSLocalizedString("Drip_EditStart", comment: "")
            super.setEditing(false, animated: true)
            fluidRateInputTableView.setEditing(false, animated: true)
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

}
