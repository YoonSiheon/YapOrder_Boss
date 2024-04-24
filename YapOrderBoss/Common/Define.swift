//
//  Define.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/09.
//


let APPSTORE_URL                   = "itms-apps://itunes.apple.com/app/apple-store/id6449272782"
//개인정보 처리 방침 url : https://yapstor.blob.core.windows.net/yaporderpub/ceo/cs5000.html

let DEV_BASE_URL                   = "https://stg-ceo.yap.net"
let DEV_API_URL                    = "https://stg-api.yap.net"

let REAL_BASE_URL                  = "https://ceo.yap.net"
let REAL_API_URL                   = "https://api.yap.net"

//let DEV_BASE_URL                   = "https://stg-ceo.yap.net"
//let REAL_BASE_URL                  = "https://stg-ceo.yap.net"
//let API_BASE_URL                   = "http://192.168.5.124:8089" //이한민

//let DEV_BASE_URL                   = "https://stg-ceo.yap.net"
//let REAL_BASE_URL                  = "https://stg-ceo.yap.net"
//let API_BASE_URL                   = "http://192.168.5.54:8080"  //김선영

//let DEV_BASE_URL                   = "http://192.168.5.179:8080"
//let REAL_BASE_URL                  = "https://stg-ceo.yap.net"
//let API_BASE_URL                   = "http://192.168.5.179:8088"  //김재경


#if DEBUG
    let BASE_URL                   = DEV_BASE_URL
    let API_URL                    = DEV_API_URL
#else
    let BASE_URL                   = REAL_BASE_URL
    let API_URL                    = REAL_API_URL
#endif

let URL_LOGINMAIN                  = "/login"                                            // 로그인
let URL_LOGOUT                     = "/pos/logout"                                       // 로그아웃
let URL_PUSHTOKEN                  = "/pos/push-token"                                   // 푸쉬토큰 등록
let URL_APPVERSION                 = "/mobile/versions/latest"                           // 앱 버전 체크
let URL_STORE                      = "/stores/"                                          // 매장정보 조회
let URL_ORDERS                     = "/orders"                                           // 주문내역 조회
let URL_ORDERS_DETAIL              = "/detail"                                           // 주문상세 조회
let URL_ORDERS_TODAY               = "/orders/today"                                     // 오늘의 주문내역 조회
let URL_ORDERS_LASTEST             = "/orders/latest-count"                              // 주문접수건 수 조회
let URL_CANCEL_REASON              = "/orders/cancel/reason"                             // 취소샤사유 목록 조회
let URL_COOKTIME                   = "/ceo/cook-time/info"                               // 조리시간 설정 조회
let URL_COOKTIME_UPDATE            = "/ceo/cook-time/update"                             // 조리시간 설정 수정
let URL_SALES_INFO                 = "/sales/info"                                       // 영업일보 조회
let URL_HOME_DATA                  = "/ceo/main"                                         // home - 매출, 그래프, 인기메뉴 data
let URL_SALES_CLOSE_UPDATE         = "/ceo/biz-stop/update"                              // home - 임시영업중지 데이터 전달
let URL_ORDERS_STATUS              = "/orders/status"                                    // 주문상태변경
let URL_ORDERS_CANCEL              = "/orders/cancel"                                    // 주문취소

//let URL_CONFIG_NOTI                = "/owner/config/noti"                                // 알림
//let URL_CONFIG_BELL                = "/owner/config/bell"                                // 주문알림
//let URL_CONFIG_CKTM                = "/owner/config/CKTM"                                // 조리시간 설정



let URL_SERVICEMANAGEMENT_INFO     = "/owner/menu/info"                                  //메뉴관리
let URL_SERVICEMANAGEMENT_OPTION   = "/owner/menu/option"                                //옵션관리
let URL_SERVICEMANAGEMENT_OUT      = "/owner/menu/out"                                   //품절관리
let URL_SERVICEMANAGEMENT_ORDER    = "/owner/menu/order"                                 //노출순서

let URL_MANAGEMENT_INFO_ADD                = "/owner/menu/info/add"                              //메뉴추가
let URL_MANAGEMENT_INFO_VIEW               = "/owner/menu/info/view"                             //메뉴정보
let URL_MANAGEMENT_MENU_EDIT               = "/owner/menu/info/product"                          //메뉴정보 수정
let URL_MANAGEMENT_OPTION_EDIT             = "/owner/menu/info/option"                           //옵션정보 수정
let URL_MANAGEMENT_ETC_EDIT                = "/owner/menu/info/etc"                              //주문유형 수정
let URL_MANAGEMENT_OPTION_ADD              = "/owner/menu/option"                                //옵션추가
let URL_MANAGEMENT_OPTION_GROUP_ADD        = "/owner/menu/option/group/add"                      //옵션그룹 추가
let URL_MANAGEMENT_OPTION_MENU_ADD         = "/owner/menu/option/menu/add"                       //옵션메뉴 추가
let URL_MANAGEMENT_OPTION_GROUP_EDIT       = "/owner/menu/option/group/edit"                     //옵션그룹 수정
let URL_MANAGEMENT_OPTION_MENU_EDIT        = "/owner/menu/option/menu/edit"                      //옵션메뉴 수정



let URL_SALESSTATISTICS_SALE       = "/owner/settle/sale"                                //매출조회
let URL_SALESSTATISTICS_CALC       = "/owner/settle/calc"                                //정산내역
let URL_SALESSTATISTICS_DISC       = "/owner/settle/disc"                                //할인내역

let URL_MANAGEMENT_SALES_RECEIPT           = "/owner/settle/sale/info"                           //영수증 조회
let URL_MANAGEMENT_SALES_DETAIL            = "/owner/menu/option"                                //정산내역 상세 ////////////////////////////



let URL_MORE_INFO                  = "/owner/store/info"                                 //매장정보
let URL_MORE_TIME                  = "/owner/store/time"                                 //영업시간
let URL_MORE_ORIGIN                = "/owner/store/origin"                               //원산지

let URL_MORE_STORE_EDIT                    = "/owner/store/info/edit"                            //매장정보 수정
let URL_MORE_STORE_IMAGE_EDIT              = "/owner/store/info/image"                           //매장이미지 수정
let URL_MORE_STORE_OPENING                 = "/owner/store/time/edit"                            //영업시간 수정
let URL_MORE_STORE_HOLIDAY                 = "/owner/store/time/holiday"                         //휴무일 수정
let URL_MORE_STORE_ORIGIN_EDIT             = "/owner/store/origin/edit"                          //원산지 수정



let URL_MORE_SALE                  = "/owner/marketing/sale"                             //메뉴할인
let URL_MORE_STAMP                 = "/owner/marketing/stamp"                            //스탬프

let URL_MORE_SALE_ADD                      = "/owner/marketing/sale/add"                         //메뉴할인 추가
let URL_MORE_SALE_EDIT                     = "/owner/marketing/sale/edit"                        //메뉴할인 수정
let URL_MORE_STAMP_ADD                     = "/owner/marketing/stamp/add"                        //스탬프 추가
let URL_MORE_STAMP_EDIT                    = "/owner/marketing/stamp/edit"                       //스탬프 수정



let URL_MORE_NOTICE                = "/owner/bbs/notice"                                 //공지사항
let URL_MORE_FAQ                   = "/owner/bbs/faq"                                    //FAQ
let URL_MORE_NOTI                  = "/owner/config/noti"                                //알림설정
let URL_MORE_BELL                  = "/owner/config/bell"                                //알림음설정
let URL_MORE_CKTM                  = "/owner/config/cktm"                                //조리시간 설정
let URL_MORE_MYINFO                = "/owner/my/info"                                    //계정관리
let URL_MORE_INQUIRY               = "/owner/bbs/inquiry"                                //1:1문의
let URL_MORE_INQUIRY_ADD           = "/owner/bbs/inquiry/add"                            //1:1문의
let URL_MORE_TERMS                 = "/view/yapmobile-terms/홈"                           //이용약관

let URL_MORE_LOGOUT                     = "/logout"                                           //로그아웃

let URL_ENTER                      = "/enter"                                            //입점문의


let URL_MAIN                       = "/owner/main"
let URL_ORDERRECEIPT               = "/owner/menu/info"//
let URL_SERVICEMANAGEMENT          = "/owner/menu/info"
let URL_SALESSTATISTICS            = "/owner/settle/sale"//
let URL_MOREMENU                   = "/owner/more/main"

// 앱스키마 설정
let SCHEMA_ALERTSETTING            = "alertsetting"
let SCHEMA_SETALERT                = "alert"
let SCHEMA_BELL                    = "bell"
let SCHEMA_LOGOUT                  = "logout"
let SCHEMA_IMGUPLOAD               = "imgUpload"


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


let SPLASH_DELAY_TIME_DEFAULT      = 1.0                                                // default 스플래쉬 타임
let REFRESH_DELAY_TIME_DEFAULT     = 1.5                                                // 리프레쉬 타임
let LOADING_DELAY_DEFAULT          = 3.0                                                // loading indicator delay
let LOADING_DELAY_MAX              = 10.0                                               // loading indicator delay max


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

let TAB_IDX_HOME: Int              = 0
let TAB_IDX_ORDERRECEIPT: Int      = 1
let TAB_IDX_SERVICEMANAGEMENT: Int = 2
let TAB_IDX_SALESSTATISTICS: Int   = 3
let TAB_IDX_MOREMENU: Int          = 4

let TAB_ORDER_ORDERTODAY: Int      = 0
let TAB_ORDER_ORDERALL: Int        = 1

let TAB_ORDER_ORDERWAITING: Int    = 0
let TAB_ORDER_ORDERPROCESSING: Int = 1
let TAB_ORDER_ORDERCOMPLETE: Int   = 2
let TAB_ORDER_ORDERCANCEL: Int     = 3

let TAB_ORDER_DETAIL_ORDERWAITING: Int        = 10
let TAB_ORDER_DETAIL_ORDERPROCESSING: Int     = 11
let TAB_ORDER_DETAIL_ORDERCOMPLETE: Int       = 12
let TAB_ORDER_DETAIL_ORDERCANCEL: Int         = 13

let POPUP_STATE_SALES_CLOSE: Int   = 101
let POPUP_STATE_LOGOUT: Int   = 102
let POPUP_STATE_PERMISSION_CHECK: Int   = 103

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

let TAB_ORDER_STATUS_ORDER                    = "2003" //주문접수
let TAB_ORDER_STATUS_RESERVATIONWAITTING      = "2005" //예약대기
let TAB_ORDER_STATUS_RESERVATIONWAITTING_10   = "2006" //예약10분전
let TAB_ORDER_STATUS_ORDERCOMPLETE            = "2007" //접수완료
let TAB_ORDER_STATUS_PRODUCTCOMPLETE          = "2020" //상품준비완료
let TAB_ORDER_STATUS_PICKUP                   = "2080" //픽업요청알림
let TAB_ORDER_STATUS_PICKUPDELAY              = "2085" //픽업지연
let TAB_ORDER_STATUS_PICKUPDELAYCOMPLETE      = "2090" //픽업지연완료
let TAB_ORDER_STATUS_PICKUPWAITTING           = "2099" //미픽업
let TAB_ORDER_STATUS_RESERVATIONCANCEL        = "2000" //예약취소
let TAB_ORDER_STATUS_ORDERCANCEL              = "9999" //주문취소

let TAB_ORDER_TYPE_STORE                      = "01" //매장식사(서빙)
let TAB_ORDER_TYPE_STORE_EAT                  = "02" //매장식사(셀프)
let TAB_ORDER_TYPE_STORE_RESERVATION          = "03" //매장예약
let TAB_ORDER_TYPE_PICKUP                     = "04" //포장
let TAB_ORDER_TYPE_PICKUP_RESERVATION         = "05" //포장예약


let NAVIGATION_CONTROLLER_HOME                = "HomeNavigationController"
let NAVIGATION_CONTROLLER_ORDERRECEIPT        = "OrderReceiptNavigationController"
let NAVIGATION_CONTROLLER_SERVICEMANAGEMENT   = "ServiceManagementNavigationController"
let NAVIGATION_CONTROLLER_SALESSTATISTICS     = "SalesStatisticsNavigationController"
let NAVIGATION_CONTROLLER_MOREMENU            = "MoreMenuNavigationController"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

let SHOW_BACKBUTTON_ADD_TITLE                 = "    "
let BELL_NAME_DEFAULT                         = "기본음"
let BELL_NAME_LIMCHANGJUNG                    = "임창정 음성"

let GLOBAL_TRUE                               = "true"
let GLOBAL_FALSE                              = "false"


let FIRSTCONFIRM                              = "fistConfirm"
let FCMTOKEN                                  = "fcmToken"
let DEVICEUUID                                = "deviceUUID"
let APPUPDATECHECK                            = "appUpdateCheck"
let CONFIRM_CAMERA_PERMISSION                 = "confirmCameraPermission"
let CONFIRM_NOTIFICATION_PERMISSION           = "confirmNotificationPermission"
let GLOBAL_LOGIN_TOKEN                        = "loginToken"
let GLOBAL_LOGIN_CHECKBOX                     = "loginCheckBox"
let SCHEMA_LOGIN_CHECKBOX_ON                  = "loginCheckBoXOn"
let SCHEMA_LOGIN_CHECKBOX_OFF                 = "loginCheckBoxOff"
let GLOBAL_LOGIN_ID                           = "loginId"
let GLOBAL_LOGIN_PW                           = "loginPw"
let GLOBAL_COMPANY_CODE                       = "companyCode"
let GLOBAL_BRAND_CODE                         = "brandCode"
let GLOBAL_STORE_CODE                         = "storeCode"
let GLOBAL_USER_ID                            = "userId"
let GLOBAL_USER_NAME                          = "userName"
let GLOBAL_ACCESSTOKEN                        = "accessToken"
let GLOBAL_PUSHID                             = "pushId"
let GLOBAL_POSNO                              = "posNo"

let GLOBAL_DEVICE_ALERT                       = "deviceAlert"
let GLOBAL_CONFIG_ALERT                       = "configAlert"
let GLOBAL_CONFIG_BELL                        = "configBell"
let GLOBAL_CONFIG_BELL_NAME                   = "bellName"

let GLOBAL_PERMISSION_CAMERA                  = "permissionCamera"
let GLOBAL_PERMISSION_ALBUM                   = "permissionAlbum"



//ysh
let test_data = 0           // 0:real data,          1:test data(test)
let local_server = 0        // 0:local server X ,    1:local server O(test)
