//
//  ViewController.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/06/28.
//

import UIKit
import AudioToolbox     // バイブレーション & サウンド通知用
// AVクラスをインポートする
import AVFoundation

import WatchConnectivity

import GoogleMobileAds

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WCSessionDelegate, GADBannerViewDelegate {

    @IBOutlet weak var form_DropCountPerMin: UITextField!
    @IBOutlet weak var form_DropSecPerCount: UITextField!
    @IBOutlet weak var segmentedControl_InfusionSet: UISegmentedControl!
    @IBOutlet weak var progressBar_DropTiming: UIProgressView!
    
    @IBOutlet weak var DropSettingTableView: UITableView!
    
    @IBOutlet weak var DropTimingImage: UIImageView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var audioPlayer:AVAudioPlayer!
    
    var timer: Timer!                   // タイマー用変数
    var infusionSet: Int = INFUSIONSET_20         // 輸液セットの選択（20もしくは60がある）
    var dropStartFlag: Bool = false     // 点滴を開始するためのフラグ
    var countTimeInterval: Int = 0
    var countTimeIntervalForWatch: Int = 0
    var dropProgressPercent: Float = 0
    
    var val_DropFluidVolume: Float = 0
    var val_DropTimeHour: Float = 0
    var val_DropTimeMin: Float = 0
    var val_DropFlowRate: Float = 0
    
    var wcSession : WCSession! = nil
    
    let userDefaults = UserDefaults.standard

    
    var dropTimingImage: Int = DROP_TIMING_STATUS_DEFALUTS
    var dropTimingImageWaitCount: Int = 0
    
    var InputDropInfoData = ["","",""] // セルのTitle
    
    
    var culcuateMethodSelect = CUL_DROP_FLUID_VOLUME
    
    func initDropAPP() {
        
        //初回起動判定
        let visit = UserDefaults.standard.bool(forKey: KEY_VISIT)
        if visit {
            //二回目以降
            print("二回目以降")
            LeastInputItem = LEAST_INPUT_IS_OLD_DATA
            
            
        } else {
            //初回アクセス
            print("初回起動")
            userDefaults.set(true, forKey: KEY_VISIT)
            
            LeastInputItem = LEAST_INPUT_IS_OLD_DATA
            
            userDefaults.set(VAL_INIT_DROP_FLUID_VOLUME, forKey: KEY_DROP_ALL_AMOUNT)
            userDefaults.set(VAL_INIT_DROP_TIMER_HOUR, forKey: KEY_DROP_TIME_HOUR)
            userDefaults.set(VAL_INIT_DROP_TIMER_MIN, forKey: KEY_DROP_TIME_MIN)
            userDefaults.set(VAL_INIT_DROP_FLOW_RATE, forKey: KEY_DROP_FLOW_RATE)
            
            userDefaults.set(0, forKey: KEY_OPTION_INFUSION_SET)
            userDefaults.set(DROP_SOUND_ID_1, forKey: KEY_SOUND_SELECT)
            userDefaults.set(false, forKey: KEY_VIBRATION)
            userDefaults.set(false, forKey: KEY_SHAKE_RESET)
            userDefaults.set(false, forKey: KEY_SYNC_WATCH)
            userDefaults.set(false, forKey: KEY_SETTING_FLOW_RATE)
            userDefaults.set(0, forKey: KEY_INIT_TIMER_VALUE) // タイマー機能で使用する
            userDefaults.set(false, forKey: KEY_NOTIFICATION) // 通知機能で使用する
            userDefaults.set(0, forKey: KEY_TIMER_DISPLAY_SEQUENCE)
            userDefaults.set("App Store", forKey: KEY_REVIEW)
            userDefaults.set(NSLocalizedString("SettingText_Mail", comment: ""), forKey: KEY_CONTACT)
            userDefaults.set("", forKey: KEY_RECOMMEND)
            let AppVersion = ((Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)!) + " (23)"
            userDefaults.set(AppVersion, forKey: KEY_APP_VERSION)
            userDefaults.set("", forKey: KEY_MY_APP)
            
        }
        
        
        culcuateMethodSelect = CUL_DROP_FLUID_VOLUME
        val_DropFluidVolume = 0
        val_DropTimeHour = 0
        val_DropTimeMin = 0
        val_DropFlowRate = 0

        
        form_DropCountPerMin.text = "-"
        form_DropSecPerCount.text = "-"
        
        
        dropStartFlag = false
        countTimeInterval = 0
        countTimeIntervalForWatch = 0
        dropProgressPercent = 0.0
        
        
        
        
        //テーブルを更新
        DropSettingTableView.reloadData()
        
    }
    

    
    @IBAction func resetSetting(_ sender: Any) {
        
        userDefaults.set(VAL_INIT_DROP_FLUID_VOLUME, forKey: KEY_DROP_ALL_AMOUNT)
        userDefaults.set(VAL_INIT_DROP_TIMER_HOUR, forKey: KEY_DROP_TIME_HOUR)
        userDefaults.set(VAL_INIT_DROP_TIMER_MIN, forKey: KEY_DROP_TIME_MIN)
        userDefaults.set(VAL_INIT_DROP_FLOW_RATE, forKey: KEY_DROP_FLOW_RATE)
        
        // [課題]　changeSetting()と同じ内容なので、一つの関数にまとめたい。
        getInterruptSettingData()
        
        if (checkInterruptSettingData() == true){
            culcuationDropSchedule()
            // 点滴を開始するためのフラグ
            dropStartFlag = true
        }
        else{
            // 点滴を開始するためのフラグ
            dropStartFlag = false
        }
        
        //テーブルを更新
        DropSettingTableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"  //Test Ad ca-app-pub-3940256099942544~2934735716
        //bannerView.adUnitID = "ca-app-pub-8058786761550310/6004614497"   //本番 Ad 1st
        //bannerView.adUnitID = "ca-app-pub-8058786761550310/8432834265"   //本番 Ad 2nd バグで適用できなかった
        bannerView.adUnitID = "2ndca-app-pub-4463164875008049/9727712988"   //本番 Ad 3rd 新規アカウント(xemwoo@) ca-app-pub-4463164875008049~9727712988
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        DropSettingTableView.register(UINib(nibName: "MainDropTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        // UITableView をスクロールさせない
        DropSettingTableView.isScrollEnabled = false
        
        
        initDropAPP()
        startTimer()
        
        //テーブルを更新
        DropSettingTableView.reloadData()
        

        
        // UITableViewの空セルのseparatorを消す
        DropSettingTableView.tableFooterView = UIView(frame: .zero)
        
        
        form_DropCountPerMin.isEnabled = false
        form_DropSecPerCount.isEnabled = false
        
        changeSegmentedStyle(self.view.frame.size)
        
        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
        
    }
    
    func changeSegmentedStyle(_ size: CGSize){

        // 選択中のセグメントの色
        UISegmentedControl.appearance().selectedSegmentTintColor = #colorLiteral(red: 0.1056114191, green: 0.4013812245, blue: 0.779880799, alpha: 1)

        // 背景色
        UISegmentedControl.appearance().backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        // 通常時のフォント色
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),
        ], for: .normal)
        
        // 選択時のフォント色
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        ], for: .selected)
        
        //比較の基準を設定
        let horizontalSizeClass = UITraitCollection(horizontalSizeClass: .regular)

        if traitCollection.containsTraits(in: horizontalSizeClass){
            //Regular
            print("水平方向はRegular")
            segmentedControl_InfusionSet.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
        }else{
            if size.width > size.height {
                //横向きの判定.
                print("水平方向はCompact 横の長さのほうが長い")
                segmentedControl_InfusionSet.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
            }else{
                //縦向きの判定
                print("水平方向はCompact 縦の長さのほうが長い")
                segmentedControl_InfusionSet.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
            }
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        if (userDefaults.integer(forKey: KEY_OPTION_INFUSION_SET) == 0){
            // オプション点滴SETが0の場合、オプションのセグメントを表示しないようにする。
            segmentedControl_InfusionSet.removeSegment(at: 2, animated: true)
            
            // 現在選択されているインデックスが左から三番目の場合、一番目に戻す
            if ( userDefaults.integer(forKey: KEY_INFUSION_SET_CURRENT) == 2) {
                segmentedControl_InfusionSet.selectedSegmentIndex = 0
            }
        }
        else{
            // オプション点滴SETのオプションのセグメントを追加する
            let newSegmentTitle = userDefaults.string(forKey: KEY_OPTION_INFUSION_SET)! + UNT_DROP_INFUSION_SET
            segmentedControl_InfusionSet.insertSegment(withTitle: newSegmentTitle, at: 2, animated: true)
            
            segmentedControl_InfusionSet.selectedSegmentIndex = userDefaults.integer(forKey: KEY_INFUSION_SET_CURRENT)
        }
        // 過去のオプション点滴SETのセグメント削除する
        if (segmentedControl_InfusionSet.numberOfSegments > 3){
            print(segmentedControl_InfusionSet.numberOfSegments)
            segmentedControl_InfusionSet.removeSegment(at: 3, animated: true)
        }
        
        
        
        
        // [課題]　changeSetting()と同じ内容なので、一つの関数にまとめたい。
        getInterruptSettingData()
        
        if (checkInterruptSettingData() == true){
            culcuationDropSchedule()
            // 点滴を開始するためのフラグ
            dropStartFlag = true
        }
        else{
            // 点滴を開始するためのフラグ
            dropStartFlag = false
        }
        
        //テーブルを更新
        DropSettingTableView.reloadData()
        
        
    }
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: VAL_TIMER_INTERVAL,
            target: self,
            selector: #selector(self.dropMainFunction),
            userInfo: nil,
            repeats: true)
    }
    
    func DropTimingAction() {
        if (dropProgressPercent > 1.0){
            dropProgressPercent = 0.0
            progressBar_DropTiming.setProgress(dropProgressPercent, animated: false)
            countTimeInterval = 0
            
            // バイブレーションで通知する
            if (userDefaults.bool(forKey: KEY_VIBRATION)){
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            
            // サウンドで通知する
            switch userDefaults.integer(forKey: KEY_SOUND_SELECT) {
            case DROP_SOUND_ID_NO_SOUND:
                
                break
            case DROP_SOUND_ID_9:
                // mp3音声(WaterDropCLIP_20210704.mp3)の再生
                playSound(name: "WaterDropCLIP_20210704")
                break
            default:
                AudioServicesPlaySystemSoundWithCompletion( UInt32( userDefaults.integer(forKey: KEY_SOUND_SELECT))) {
                      //サウンドが鳴り終わった後の処理を記述
                }
                break
            }

            // イメージ変更する
            dropTimingImage = DROP_TIMING_STATUS_FINISH
            chengeDropTimingImage()
            
        }else{
            
            if(dropProgressPercent < 0.3){
                // イメージを変更する
                dropTimingImage = DROP_TIMING_STATUS_START1
            }else if(dropProgressPercent < 0.6){
                // イメージを変更する
                dropTimingImage = DROP_TIMING_STATUS_START2
            }else if(dropProgressPercent < 0.95){
                // イメージを変更する
                dropTimingImage = DROP_TIMING_STATUS_START3
            }else if(dropProgressPercent > 0.97){
                // イメージを変更する
                dropTimingImage = DROP_TIMING_STATUS_START4
            }else if(dropProgressPercent > 0.99){
                // イメージを変更する
                dropTimingImage = DROP_TIMING_STATUS_START5
            }
            
            
            chengeDropTimingImage()
            
            dropProgressPercent = Float(countTimeInterval) * Float(VAL_TIMER_INTERVAL) / Float(form_DropSecPerCount.text!)!
            
        }
        
        if(countTimeIntervalForWatch > 100){
            
            if (userDefaults.bool(forKey: KEY_SYNC_WATCH)){
                // 設定したデータを送信する(0.01*100[sec])
                sendInfoToWatch()
            }
            
            countTimeIntervalForWatch = 0
        }else{
            countTimeIntervalForWatch += 1
        }
        
        
    }
    
    func sendInfoToWatch(){
        let message = [KEY_W_DROP_INFUSION_SET : Int(infusionSet),
                       KEY_W_DROP_FLUID_VOLUME : Int(val_DropFluidVolume),
                       KEY_W_DROP_TIME_HOUR : Int(val_DropTimeHour),
                       KEY_W_DROP_TIME_MIN : Int(val_DropTimeMin),
                       KEY_W_DROP_FLOW_RATE : Int(val_DropFlowRate)]
        
        wcSession.sendMessage(message, replyHandler: nil) { (error) in
            
            //print(error.localizedDescription)
            
        }
    }
    
    // MARK: WCSession Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //print("activationDidCompleteWith state= \(activationState.rawValue)")
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //print("sessionDidBecomeInactive")
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //print("sessionDidDeactivate")
        
    }
    
    func chengeDropTimingImage(){
        
        switch dropTimingImage{
        case DROP_TIMING_STATUS_DEFALUTS:
            DropTimingImage.image = UIImage(named: DROP_TIMING_IMAGE_DEFAULTS)
        case DROP_TIMING_STATUS_START1:
            if (dropTimingImageWaitCount < 10){
                dropTimingImageWaitCount = dropTimingImageWaitCount + 1
                DropTimingImage.image = UIImage(named: DROP_TIMING_IMAGE_FINISH)
                
            }
            else{
                DropTimingImage.image = UIImage(named: DROP_TIMING_IMAGE_START1)
            }
        case DROP_TIMING_STATUS_START2:
            DropTimingImage.image = UIImage(named: DROP_TIMING_IMAGE_START2)
        case DROP_TIMING_STATUS_START3:
            DropTimingImage.image = UIImage(named: DROP_TIMING_IMAGE_START3)
        case DROP_TIMING_STATUS_START4:
            DropTimingImage.image = UIImage(named: DROP_TIMING_IMAGE_START4)
        case DROP_TIMING_STATUS_START5:
            DropTimingImage.image = UIImage(named: DROP_TIMING_IMAGE_START4)
        case DROP_TIMING_STATUS_FINISH:
            DropTimingImage.image = UIImage(named: DROP_TIMING_IMAGE_FINISH)
            dropTimingImageWaitCount = 0
            
        default:
            break
        
        }
    }
    
    @objc func dropMainFunction() {
        if (dropStartFlag == false) {
            //進捗を0%に戻す
            progressBar_DropTiming.setProgress(0.0, animated: false)
            countTimeInterval = 0
            return
        }
        
        
        DropTimingAction()
        progressBar_DropTiming.setProgress(dropProgressPercent, animated: false)
        countTimeInterval += 1
        
    }
    
    
    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *ここから下はテーブルによるデータ入力に関する処理
    *
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    
    // セクション合計数を指定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 現在のセクション数を指定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InputDropInfoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DropSettingTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainDropTableViewCell
        
        cell.title.text = InputDropInfoData[indexPath.row]
        
        switch indexPath.row {
        case 0:
            let cell_value = userDefaults.string(forKey: KEY_DROP_ALL_AMOUNT)
            cell.value.text = cell_value! + UNT_DROP_FLUID_VOLUME
            
            // シェブロン（"＞"マーク）をUIに追加
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            
            break
        case 1:
            let cell_value_Hour = userDefaults.string(forKey: KEY_DROP_TIME_HOUR)
            let cell_value_Min = userDefaults.string(forKey: KEY_DROP_TIME_MIN)
            
            cell.value.text = cell_value_Hour! + NSLocalizedString("Drip_Unit_Hour", comment: "") + cell_value_Min! + NSLocalizedString("Drip_Unit_Min", comment: "")
            
            // シェブロン（"＞"マーク）をUIに追加
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            
            break
        case 2:
            let cell_value = userDefaults.string(forKey: KEY_DROP_FLOW_RATE)
            cell.value.text = cell_value! + UNT_DROP_FLOW_RATE
            
            if (userDefaults.bool(forKey: KEY_SETTING_FLOW_RATE)){
                // シェブロン（"＞"マーク）をUIに追加
                cell.accessoryType =  UITableViewCell.AccessoryType.disclosureIndicator
            }else{
                // シェブロン（"＞"マーク）をUIに追加しない
                cell.accessoryType =  UITableViewCell.AccessoryType.none
                // セルが選択された時の背景色を消す
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
            }
            
            break
        default:
            break
        }
        
        
        return cell
    }
    
    
    
    /// セル選択時（UITableViewDataSource optional）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // 次の画面へ移動
            performSegue(withIdentifier: "fluidVolumeInput", sender: nil)
            break
        case 1:
            // 次の画面へ移動
            performSegue(withIdentifier: "dropTimeInput", sender: nil)
            break
        case 2:
            if (userDefaults.bool(forKey: KEY_SETTING_FLOW_RATE)){
                // 次の画面へ移動
                performSegue(withIdentifier: "flowRateInput", sender: nil)
            }
            break
        default:
            break
        }
        //tableView.reloadData()
        
    }
    
    // ヘッダーの大きさを設定する
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            // ヘッダーViewの高さを返す
            return  0.0
    }

    // フッターの大きさを設定する
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            // フッターViewの高さを返す
            return  0.0
    }
    
    // セルの大きさを設定する
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // セルの高さをテーブルサイズにすべてが均等に収まるように設定
        return DropSettingTableView.layer.bounds.height / CGFloat(InputDropInfoData.count)
    }
    
    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    *ここから下は直接テキストフィールドにデータ入力に関する処理
    *
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func getInterruptSettingData(){
        // 現在の輸液セットのセグメントで選択しているインデックス番号を取得
        let selectedIndex =  segmentedControl_InfusionSet.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            infusionSet = INFUSIONSET_20
            userDefaults.set(0, forKey: KEY_INFUSION_SET_CURRENT)
        case 1:
            infusionSet = INFUSIONSET_60
            userDefaults.set(1, forKey: KEY_INFUSION_SET_CURRENT)
        case 2:
            infusionSet = userDefaults.integer(forKey: KEY_OPTION_INFUSION_SET)
            userDefaults.set(2, forKey: KEY_INFUSION_SET_CURRENT)
        default:
            infusionSet = INFUSIONSET_20
            userDefaults.set(0, forKey: KEY_INFUSION_SET_CURRENT)
        }
        
        // userDefaultsを取得し、変数に代入する
        val_DropFluidVolume =  userDefaults.float(forKey: KEY_DROP_ALL_AMOUNT)
        val_DropTimeHour = userDefaults.float(forKey: KEY_DROP_TIME_HOUR)
        val_DropTimeMin = userDefaults.float(forKey: KEY_DROP_TIME_MIN)
        val_DropFlowRate =  userDefaults.float(forKey: KEY_DROP_FLOW_RATE)
        
    }
    
    func checkInterruptSettingData() -> Bool {
        /*
         if (val_DropFluidVolume <= 0 ){
            print("ERROR: 総輸液量は0よりも上の数値を入力してください。")
            return false
        }
        
        if (val_DropTimeHour < 0 || 100 < val_DropTimeHour){
            print("ERROR: 滴下時間（時間）は0〜100までの数値を入力してください。")
            return false
        }
        
        if (val_DropTimeMin < 0 || 59 < val_DropTimeMin ){
            print("ERROR: 滴下時間（分）は0〜59までの数値を入力してください。")
            return false
        }
        
        if (val_DropTimeHour == 0 && val_DropTimeMin == 0){
            print("ERROR: 1分以上の時間を入力してください。")
            return false
        }
        */
        
        if (val_DropFluidVolume > 0 && (val_DropTimeHour > 0 || val_DropTimeMin > 0) && val_DropFlowRate > 0){
            //「3項目全て入力済み状態で」「最新で変更した項目」を元に、入力パターンを記録
            switch LeastInputItem {
            case LEAST_INPUT_DROP_NONE:
                return false
            case LEAST_INPUT_DROP_FLUID_VOLUME:
                culcuateMethodSelect = CUL_DROP_FLOW_RATE
                break
            case LEAST_INPUT_DROP_TIME:
                culcuateMethodSelect = CUL_DROP_FLOW_RATE
                break
            case LEAST_INPUT_DROP_FLOW_RATE:
                culcuateMethodSelect = CUL_DROP_TIME
                break
            case LEAST_INPUT_IS_OLD_DATA:
                culcuateMethodSelect = CUL_DROP_TIME
                break
            default:
                return false
            }
        }
        else if (val_DropFluidVolume > 0 && (val_DropTimeHour > 0 || val_DropTimeMin > 0)) {
            culcuateMethodSelect = CUL_DROP_FLOW_RATE
        }
        else if (val_DropFluidVolume > 0 && val_DropFlowRate > 0){
            culcuateMethodSelect = CUL_DROP_TIME
        }
        else if (val_DropFlowRate > 0 && (val_DropTimeHour > 0 || val_DropTimeMin > 0)){
            culcuateMethodSelect = CUL_DROP_FLUID_VOLUME
        }
        else{
            return false
        }
        
        return true
    }
    
    
    func culcuationDropSchedule() {
        // 時間もしくは流量を計算する。
        //val_DropFluidVolume
        //val_DropTimeHour
        //val_DropTimeMin
        //val_DropFlowRate
        
        switch culcuateMethodSelect {
        case CUL_DROP_FLUID_VOLUME:
            val_DropFluidVolume = val_DropFlowRate * ( val_DropTimeHour + (val_DropTimeMin / 60 ) )
            
            // 小数点2位で四捨五入
            val_DropFluidVolume = round(val_DropFluidVolume * 10 ) / 10
        
        case CUL_DROP_TIME:
            val_DropTimeHour = floor((val_DropFluidVolume / val_DropFlowRate))
            val_DropTimeMin = (val_DropFluidVolume / val_DropFlowRate)
            val_DropTimeMin = round(val_DropTimeMin.truncatingRemainder(dividingBy: 1) * 60)
                
            
        case CUL_DROP_FLOW_RATE:
            val_DropFlowRate = val_DropFluidVolume / ( val_DropTimeHour + (val_DropTimeMin / 60 ) )
            
            // 小数点2位で四捨五入
            val_DropFlowRate = round(val_DropFlowRate)
            
        default:
            break
        }
        
        // 結果を記録
        userDefaults.set(val_DropFluidVolume, forKey: KEY_DROP_ALL_AMOUNT)
        userDefaults.set(val_DropTimeHour, forKey: KEY_DROP_TIME_HOUR)
        userDefaults.set(val_DropTimeMin, forKey: KEY_DROP_TIME_MIN)
        userDefaults.set(val_DropFlowRate, forKey: KEY_DROP_FLOW_RATE)
        
        
        //　滴下数と滴下間隔を計算する。
        var val_result_DropCountPerMin: Float  = 0
        var val_result_DropSecPerOneDrop: Float  = 0
        
        val_result_DropCountPerMin = val_DropFlowRate / 60 * Float(infusionSet)
        val_result_DropSecPerOneDrop = 60 / val_result_DropCountPerMin
        
        // 小数点2位で四捨五入
        val_result_DropCountPerMin = round(val_result_DropCountPerMin * 10 ) / 10
        val_result_DropSecPerOneDrop = round(val_result_DropSecPerOneDrop * 10 ) / 10
        
        // フォームへ代入
        form_DropCountPerMin.text = "\(val_result_DropCountPerMin)" // 滴下数
        form_DropSecPerCount.text = "\(val_result_DropSecPerOneDrop)" // 滴下間隔
        
    }

    // トグル切り替え後に実行する
    @IBAction func changeSetting(_ sender: Any) {
        
        
        getInterruptSettingData()
        if (checkInterruptSettingData() == true){
            culcuationDropSchedule()
            // 点滴を開始するためのフラグ
            dropStartFlag = true
            
            
        }
        else{
            // 点滴を開始するためのフラグ
            dropStartFlag = false
        }
        
    }
    
    // 画面半分下を押した場合に実行する
    @IBAction func StartButton(_ sender: Any) {
        dropProgressPercent = 0.0
        progressBar_DropTiming.setProgress(dropProgressPercent, animated: false)
        countTimeInterval = 0
    }
    
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype,
          with event: UIEvent?) {
        
        print("shake gesture has ended")
        
        if (userDefaults.bool(forKey: KEY_SHAKE_RESET)){
            
            initDropAPP()
            
            // 点滴を開始するためのフラグ
            dropStartFlag = false
        }
        
    }
    
    

}


extension ViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }

        do {
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))

            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self

            // 音声の再生
            audioPlayer.play()
        } catch {
        }
    }
}
