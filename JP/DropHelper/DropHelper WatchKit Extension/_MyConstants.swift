//
//  _MyConstants.swift
//  DropHelper
//
//  Created by おいちいたまご on 2021/07/06.
//

import Foundation

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Apple Watch OS Define

let VAL_W_DROP_INFUSION_20 = 20
let VAL_W_DROP_INFUSION_60 = 60
let VAL_W_DROP_INFUSION_15 = 15
let VAL_W_DROP_INFUSION_10 = 10

let VAL_W_INIT_INFUSION_SET = VAL_W_DROP_INFUSION_20
let VAL_W_INIT_DROP_FLUID_VOLUME = 100
let VAL_W_INIT_DROP_TIMER_HOUR = 1
let VAL_W_INIT_DROP_TIMER_MIN = 0
let VAL_W_INIT_DROP_FLOW_RATE = 100

let TITLE_W_MAIN = "　"
let TITLE_W_DROP_INFUSION_SET = "　"
let TITLE_W_DROP_FLUID_VOLUME = "　"
let TITLE_W_DROP_TIMER = "　"
let TITLE_W_DROP_FLOW_RATE = "　"
let TITLE_W_DROP_NOTIFICATION = "　"
let TITLE_W_SETTING = "　設定"


// メイン画面のデータ記録
let KEY_W_DROP_INFUSION_SET = "w_dropInfusionSet"
let KEY_W_DROP_FLUID_VOLUME = "w_dropFluidVolume"
let KEY_W_DROP_TIME_HOUR = "w_dropTimeHour"
let KEY_W_DROP_TIME_MIN = "w_dropTimeMin"
let KEY_W_DROP_FLOW_RATE = "w_dropFlowRate"

let KEY_W_DROP_RE_CULCUATION = "w_reCulcuation"

let KEY_W_VISIT = "w_visit"

let KEY_W_IMAGE_ALIGNMENT = "w_imageAlignment"

let STR_W_DROP_PROGRESS_CIRCLE_IMAGE = "ProgressCircle"
let STR_W_DROP_PROGRESS_DROP_IMAGE = "InflusionDrop"


let STR_W_DROP_PROGRESS_DROP_IMAGE0 = "InflusionDrop0"
let STR_W_DROP_PROGRESS_DROP_IMAGE1 = "InflusionDrop1"
let STR_W_DROP_PROGRESS_DROP_IMAGE2 = "InflusionDrop2"
let STR_W_DROP_PROGRESS_DROP_IMAGE3 = "InflusionDrop95"
let STR_W_DROP_PROGRESS_DROP_IMAGE4 = "InflusionDrop96"
let STR_W_DROP_PROGRESS_DROP_IMAGE5 = "InflusionDrop99"


let UNT_W_DROP_INFUSION_SET = " 滴/㎖"
let UNT_W_DROP_FLUID_VOLUME = " ㎖"
let UNT_W_DROP_FLOW_RATE = " ㎖/hr"
let UNT_W_DROP_COUNT_PER_MIN = " gtts/min"

let VAL_W_IMAGE_ALIFNMENT_LEFT = 1
let VAL_W_IMAGE_ALIFNMENT_RIGHT = 2

let VAL_W_KEYBUTTON_1 = 1
let VAL_W_KEYBUTTON_2 = 2
let VAL_W_KEYBUTTON_3 = 3
let VAL_W_KEYBUTTON_4 = 4
let VAL_W_KEYBUTTON_5 = 5
let VAL_W_KEYBUTTON_6 = 6
let VAL_W_KEYBUTTON_7 = 7
let VAL_W_KEYBUTTON_8 = 8
let VAL_W_KEYBUTTON_9 = 9
let VAL_W_KEYBUTTON_0 = 0
let VAL_W_KEYBUTTON_OK = 100
let VAL_W_KEYBUTTON_DELETE = 101

let VAL_W_KEYINPUT_MAXSIZE = 1000000

let VAL_W_TIMER_INTERVAL = 0.01

let CUL_W_DROP_NONE = 0
let CUL_W_DROP_FLUID_VOLUME = 1
let CUL_W_DROP_TIME = 2
let CUL_W_DROP_FLOW_RATE = 3

var LeastInputItem_W = LEAST_W_INPUT_IS_OLD_DATA

let LEAST_W_INPUT_DROP_NONE = 0
let LEAST_W_INPUT_DROP_INFLUSION_SET = 0
let LEAST_W_INPUT_DROP_FLUID_VOLUME = 1
let LEAST_W_INPUT_DROP_TIME = 2
let LEAST_W_INPUT_DROP_FLOW_RATE = 3
let LEAST_W_INPUT_IS_OLD_DATA = 4


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Apple iOS Define


let DISABLE = false
let ENABLE = true

let VAL_TIMER_INTERVAL = 0.01

var LeastInputItem = CUL_DROP_NONE

let INFUSIONSET_20 = 20
let INFUSIONSET_60 = 60

let UNT_DROP_INFUSION_SET = " 滴/㎖"
let UNT_DROP_FLUID_VOLUME = " ㎖"
let UNT_DROP_FLOW_RATE = " ㎖/hr"
let UNT_DROP_COUNT_PER_MIN = " gtts/min"

let VAL_INIT_INFUSION_SET = INFUSIONSET_20
let VAL_INIT_DROP_FLUID_VOLUME = 100
let VAL_INIT_DROP_TIMER_HOUR = 1
let VAL_INIT_DROP_TIMER_MIN = 0
let VAL_INIT_DROP_FLOW_RATE = 100

let LEAST_INPUT_DROP_NONE = 0
let LEAST_INPUT_DROP_FLUID_VOLUME = 1
let LEAST_INPUT_DROP_TIME = 2
let LEAST_INPUT_DROP_FLOW_RATE = 3
let LEAST_INPUT_IS_OLD_DATA = 4

let DROP_TIMING_IMAGE_DEFAULTS = "InflusionDrop0"
let DROP_TIMING_IMAGE_START0 = "InflusionDrop0"
let DROP_TIMING_IMAGE_START1 = "InflusionDrop1"
let DROP_TIMING_IMAGE_START2 = "InflusionDrop2"
let DROP_TIMING_IMAGE_START3 = "InflusionDrop3"
let DROP_TIMING_IMAGE_START4 = "InflusionDrop4"
let DROP_TIMING_IMAGE_START5 = "InflusionDrop5"
let DROP_TIMING_IMAGE_FINISH = "InflusionDrop6"

let DROP_TIMING_STATUS_DEFALUTS = 0
let DROP_TIMING_STATUS_START0 = 0
let DROP_TIMING_STATUS_START1 = 1
let DROP_TIMING_STATUS_START2 = 2
let DROP_TIMING_STATUS_START3 = 3
let DROP_TIMING_STATUS_START4 = 4
let DROP_TIMING_STATUS_START5 = 5
let DROP_TIMING_STATUS_FINISH = 6

let DROP_SOUND_ID_NO_SOUND = 0000 // No Sound
let DROP_SOUND_ID_1 = 1057 // Default(Tink.caf)
let DROP_SOUND_ID_2 = 1103 // (Tink.caf2)
let DROP_SOUND_ID_3 = 1130 // (tock)
let DROP_SOUND_ID_4 = 1104 // (Tink.caf2)
let DROP_SOUND_ID_5 = 1105 // (Tink.caf2)
let DROP_SOUND_ID_6 = 1070
let DROP_SOUND_ID_7 = 1306
let DROP_SOUND_ID_8 = 1052
let DROP_SOUND_ID_9 = 9999

let DROP_SOUND_TITLE_NO_SOUND = "No Sound"
let DROP_SOUND_TITLE_1 = "Sound 1"
let DROP_SOUND_TITLE_2 = "Sound 2"
let DROP_SOUND_TITLE_3 = "Sound 3"
let DROP_SOUND_TITLE_4 = "Sound 4"
let DROP_SOUND_TITLE_5 = "Sound 5"
let DROP_SOUND_TITLE_6 = "Sound 6"
let DROP_SOUND_TITLE_7 = "Sound 7"
let DROP_SOUND_TITLE_8 = "Sound 8"
let DROP_SOUND_TITLE_9 = "Sound 9"

let CUL_DROP_NONE = 0
let CUL_DROP_FLUID_VOLUME = 1
let CUL_DROP_TIME = 2
let CUL_DROP_FLOW_RATE = 3


// 入力最大文字数(制限をかける)
let MAX_WORD_COUNT_DROP_FLUID_VOLUME = 1000
let MAX_WORD_COUNT_DROP_TIME_VALUE = 2
let MAX_WORD_COUNT_FLOW_RATE_VALUE = 10000

// 初回用
let KEY_VISIT = "visit"


// メイン画面のデータ記録
let KEY_DROP_ALL_AMOUNT = "dropALLAmount"
let KEY_DROP_TIME_HOUR = "dropTimeHour"
let KEY_DROP_TIME_MIN = "dropTimeMin"
let KEY_DROP_FLOW_RATE = "dropFlowRate"


// DataListのストア名
let KEY_DROP_INPUT_DATA_LIST = "dropInputDataList"



let KEY_FLUID_VOLUME_INPUT_LIST = "fluidVolumeInputList"
let KEY_DROP_FLUID_VOLUME_VALUE = "fluidVolumeInputValue"

let KEY_DROP_TIME_INPUT_LIST = "dropTimeInputList"
let KEY_DROP_TIME_HOUR_VALUE = "dropTimeHourInputValue"
let KEY_DROP_TIME_MIN_VALUE = "dropTimeMinInputValue"

let KEY_FLOW_RATE_INPUT_LIST = "flowRateInputList"
let KEY_DROP_FLOW_RATE_VALUE = "flowRateInputValue"





// 設定用キー
let KEY_OPTION_INFUSION_SET = "optionInfusionSet"
let KEY_SOUND_SELECT = "soundSelect"
let KEY_VIBRATION = "vibration"
let KEY_SHAKE_RESET = "shakeReset"
let KEY_SYNC_WATCH = "syncWatch"
let KEY_SETTING_FLOW_RATE = "settingFlowRate"
let KEY_INIT_TIMER_VALUE = "initTimerValue" // タイマー機能で使用する
let KEY_NOTIFICATION = "notification"
let KEY_TIMER_DISPLAY_SEQUENCE = "timerDisplaySequence"
let KEY_REVIEW = "reviewKey"
let KEY_CONTACT = "contactKey"
let KEY_RECOMMEND = "recommendKey"
let KEY_APP_VERSION = "appVersionKey"
let KEY_MY_APP = "myAppKey"



