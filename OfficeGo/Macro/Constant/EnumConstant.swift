//
//  EnumConstant.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

///楼盘房源详情- vr 视频 图片展示
enum BuildingDetailHeaderTypeEnum: Int {
//    case vr = "VR"
//    case video = "视频"
//    case image = "图片"
    case vr = 1
    case video = 2
    case image = 3
}

///楼盘房源详情- vr 视频 图片展示
enum BuildingDetailHeaderTitleEnum: String {
    case vr = "VR"
    case video = "视频"
    case image = "图片"
}

//性别
public enum UserSex: String {
    ///男
    case SexMale = "1"
    ///女
    case SexFeMale = "0"
}

///租户 - 写字楼类型
enum HouseTypeEnum: String {
    case allEnum = "全部"
    case officeBuildingEnum = "写字楼"
    case jointOfficeEnum = "共享办公"
}

///租户 - 首页列表排序
enum HouseSortEnum: String {
    case defaultSortEnum = "默认排序"
    case priceTopToLowEnum = "价格从高到低"
    case priceLowToTopEnum = "价格从低到高"
    case squareTopToLowEnum = "面积从大到小"
    case squareLowToTopEnum = "面积从小到大"
}

///租户 - 商圈地铁筛选
enum AreaCatogoryItem: String {
    case fujinCatogoryEnum = "附近"
    case mallsCatogoryEnum = "商圈"
    case subwaysCatogoryEnum = "地铁"
}


///基础数据接口请求枚举
enum DictionaryCodeEnum: String {
    /*
    租户职位 userPosition
    基础服务 basicServices
    企业服务 companyService
    装修类型 decoratedType
    网点特色 branchUnique
    楼盘类型 buildType
    房源特色 houseUnique
    举报类型 reportType
    热门关键词 hotKeywords
    会议室配套 roomMatchingUnique
    楼盘特色 buildingUnique*/
    case codeEnumuserPosition = "userPosition"
    case codeEnumbasicServices = "basicServices"
    case codeEnumcompanyService = "companyService"
    case codeEnumdecoratedType = "decoratedType"
    case codeEnumbranchUnique = "branchUnique"
    case codeEnumbuildType = "buildType"
    case codeEnumhouseUnique = "houseUnique"
    case codeEnumreportType = "reportType"
    case codeEnumhotKeywords = "hotKeywords"
    case roomMatchingUnique = "roomMatchingUnique"
    case codeEnumbuildingUnique = "buildingUnique"
}

//协议url
public enum ProtocalType {
    ///员工管理 staffList.html
    case ProtocalTypeStaffListOwnerUrl
    ///关于我们
    case ProtocalTypeAboutUs
    ///服务协议
    case ProtocalTypeRegisterProtocol
    ///隐私条款
    case ProtocalTypePrivacyProtocolUrl
    ///帮助与反馈
    case ProtocalTypeHelpAndFeedbackUrl
    ///常见问题
    case ProtocalTypeQuestionUrl
}

//认证- 房源url
public enum OwnerIdentifyOrFYType {
    ///认证 - 三种
    case ProtocalTypeIdentifyOwnerUrl
    ///个人认证  attestationPersonage.html
    case ProtocalTypeIdentifyPersonageOwnerUrl
    ///企业认证 company.html
    case ProtocalTypeIdentifyBuildingOwnerUrl
    ///网点认证 company2.html
    case ProtocalTypeIdentifyJointOwnerUrl
    ///房源页面 - 楼盘
    case ProtocalTypeFYBuildingOwnerUrl
    ///房源页面 - 网点
    case ProtocalTypeFYJointOwnerUrl

}

//我想找页面item枚举
public enum IWantToFindType {
    case IWantToFindTypeCity        //城市
    case IWantToFindTypeHouseType   //房源类型
    case IWantToFindTypeGongwei     //工位
    case IWantToFindTypeGongwei1    //工位1
    case IWantToFindTypeZujin       //租金
    case IWantToFindTypeMianji      //面积
    case IWantToFindTypeDocumentType//装修类型
    case IWantToFindTypeFeature     //房源特色
}

//写字楼和共享办公详情页面枚举
public enum FYDetailItemType {
    case FYDetailItemOfficeBuildingNameView //头部名字
    case FYDetailItemTypeJointNameView  //共享办公 - 头部 - 开放工位和独立办公室
    case FYDetailItemTypeTraffic        //交通
    case FYDetailItemTypeFeature        //特色
    case FYDetailItemTypeLianheOpenList //共享办公开放工位列表
    case FYDetailItemTypeFYList         //房源列表 - 写字楼办公室 / 共享办公独立办公室列表
    case FYDetailItemTypeShareServices  //共享服务
    case FYDetailItemTypeOfficeDeatail  //楼盘详情
    case FYDetailItemTypeAmbitusMating  //周边配套
    case FYDetailItemTypeHuxing         //办公室户型信息
}

//下面的bottom样式
public enum BottomBtnViewType {
    case BottomBtnViewTypeIwantToFind   //我想找页面 - 只显示一个确定按钮
    case BottomBtnViewTypeShaixuan      //筛选页面 - 两个按钮 清除 确定
    case BottomBtnViewTypeOfficeDetail  //详情页面 - 收藏 - 找房东
    case BottomBtnViewTypeChatAlertBottomView  //聊天页面 - 取消 - 确定
}

//租户我的页面
public enum RenterMineType {
    case RenterMineTypeIWanttoFind      //我想找
    case RenterMineTypeHouseSchedule    //看房行程
    case RenterMineTypeHelpAndFeedback  //帮助与反馈
    case RenterMineTypeCusomers         //客服
    case RenterMineTypeServiceAgent     //服务协议
    case RenterMineTypeRegisterAgent    //隐私条款
    case RenterMineTypeAboutus          //关于我们
    case RenterMineTypeRoleChange        //切换身份
}
//设置页面
public enum RenterSettingType {
//    case RenterSettingTypeAccountAndBind    //账号与绑定
    case RenterSettingTypeNoticifyAndAlert  //通知与提醒
    case RenterSettingTypePrivacySetting    //隐私设置
    case RenterSettingTypeHello             //打招呼语
    case RenterSettingTypeVersionUpdate     //版本更新
    case RenterSettingTypeRoleChange        //切换身份
    case RenterSettingTypeChangePhone       //修改手机号
    case RenterSettingTypeChangeWechat      //修改微信
    case RenterSettingTypeAPISet            //环境修改

}

//基本信息页面
public enum RenterUserMsgType {
    case RenterUserMsgTypeAvatar            //头像
    case RenterUserMsgTypeNick              //姓名
    case RenterUserMsgTypeSex               //性别
    case RenterUserMsgTypeTele              //联系方式
    case RenterUserMsgTypeWechat            //微信
    case RenterUserMsgTypeCompany           //公司
    case RenterUserMsgTypeJob               //职位
}



//房东
//租户我的页面
public enum OwnerMineType {
    case OwnerMineTypeAuthority         //员工管理 - 0 员工 1 管理员
    case OwnerMineTypeHelpAndFeedback  //帮助与反馈
    case OwnerMineTypeCusomers         //客服
    case OwnerMineTypeRegisterAgent    //隐私条款
    case OwnerMineTypeServiceAgent      //服务协议
    case OwnerMineTypeAboutus          //关于我们
    case OwnerMineTypeRoleChange        //切换身份
}


//弹框alert类型
public enum AlertType {
    case AlertTypeVersionUpdate             //版本更新
    case AlertTypeMessageAlert              //弹框展示
    case AlertTypeChatInput                 //聊天- 微信输入框
    case AlertTypeChatSure                  //聊天- 微信交换弹框
}

//房东
//公司认证页面
public enum OwnerCompanyIedntifyType {
    case OwnerCompanyIedntifyTypeIdentigy           //认证身份：
    case OwnerCompanyIedntifyTypeCompanyname        //公司名称：
    case OwnerCompanyIedntifyTypeBuildingName       //写字楼名称：
    case OwnerCompanyIedntifyTypeBuildingAddress    //写字楼地址：上海市静安区胶州路699号
    case OwnerCompanyIedntifyTypeBuildingFCType     //房产类型：租赁房产
    case OwnerCompanyIedntifyTypeUploadFangchanzheng//上传房产证
    case OwnerCompanyIedntifyTypeUploadZulinAgent   //上传租赁协议
    //case OwnerCompanyIedntifyTypeUploadMainimg      //上传楼盘封面图
}

//房东
//共享办公认证页面
public enum OwnerJointIedntifyType {
    case OwnerJointIedntifyTypeIdentigy           //认证身份：
    case OwnerJointIedntifyTypeBranchname         //网点名称：
    case OwnerJointIedntifyTypeCompanyname        //所属公司
    case OwnerJointIedntifyTypeBuildingName       //所在楼盘：
    case OwnerPersonalIedntifyTypeBuildingFCType            //房产类型：自有房产
    case OwnerJointIedntifyTypeUploadFangchanzheng//上传房产证
    case OwnerJointIedntifyTypeUploadZulinAgent   //上传租赁协议
    //case OwnerJointIedntifyTypeUploadMainimg      //上传楼盘封面图
}

//房东
//个人认证页面
public enum OwnerPersonalIedntifyType {
    case OwnerPersonalIedntifyTypeIdentify                  //认证身份：
    case OwnerPersonalIedntifyTypeUserName                  //姓名：赵捷
    case OwnerPersonalIedntifyTypeUserIdentifyCode          //身份证号：620303100309589209
    case OwnerPersonalIedntifyTypeUploadIdentifyPhoto       //上传身份证
    case OwnerPersonalIedntifyTypeBuildingName              //写字楼名称：恒森大厦
    case OwnerPersonalIedntifyTypeBuildingAddress           //写字楼地址
    case OwnerPersonalIedntifyTypeBuildingFCType            //房产类型：自有房产
    case OwnerPersonalIedntifyTypeUploadFangchanzheng       //上传房产证
    case OwnerPersonalIedntifyTypeUploadZulinAgent          //上传租赁协议
}


//房东
//创建公司页面
public enum OwnerCreteCompanyType {
    case OwnerCreteCompanyTypeIedntify              //认证身份：
    case OwnerCreteCompanyTypeCompanyName           //公司名称
    case OwnerCreteCompanyTypeCompanyAddress        //公司地址
    case OwnerCreteCompanyTypeYingyeCode            //营业执照注册号
    case OwnerCreteCompanyTypeUploadYingyePhoto     //上传营业执照
}

//房东
//创建网点页面
public enum OwnerCreteBranchType {
    case OwnerCreteBranchTypeBranchName             //网点名称
    case OwnerCreteBranchTypeBranchDistrictArea     //所在区域
    case OwnerCreteBranchTypeBranchAddress          //网点地址
    case OwnerCreteBranchTypeUploadYingyePhoto      //上传营业执照
}

//房东
//创建写字楼页面
public enum OwnerCreteBuildingType {
    case OwnerCreteBuildingTypeBranchName             //写字楼名称
    case OwnerCreteBuildingTypeBranchDistrictArea     //所在区域
    case OwnerCreteBuildingTypeBranchAddress          //网点地址
    case OwnerCreteBuildingTypeUploadYingyePhoto          //网点地址
}



///房源管理
//房东
//创建写字楼网点页面
public enum OwnerBuildingCreteAddType {
    case OwnerBuildingCreteAddTypeBuildingName             //写字楼名称
    case OwnerBuildingCreteAddTypeBuildingDistrictArea     //所在区域
    case OwnerBuildingCreteAddTypeBuildingAddress          //地址
    case OwnerBuildingCreteAddTypeUploadMainPhoto          //封面图
    case OwnerBuildingCreteAddTypeUploadFCZPhoto           //房产证图
}

//房东
//编辑写字楼页面
public enum OwnerBuildingEditType {
    ///楼盘类型
    case OwnerBuildingEditTypeBuildingTypew
    ///写字楼名称
    case OwnerBuildingEditTypeBuildingName
    ///楼号/楼名
    case OwnerBuildingEditTypeBuildingNum
    ///所在区域
    case OwnerBuildingEditTypeDisctict
    ///详细地址
    case OwnerBuildingEditTypeDetailAddress
    ///总楼层
    case OwnerBuildingEditTypeTotalFloor
    ///竣工时间
    case OwnerBuildingEditTypeCompelteTime
    ///翻新时间
    case OwnerBuildingEditTypeRenovationTime
    ///建筑面积
    case OwnerBuildingEditTypeArea
    ///净高
    case OwnerBuildingEditTypeClearHeight
    ///层高
    case OwnerBuildingEditTypeFloorHeight
    ///物业公司
    case OwnerBuildingEditTypePropertyCompany
    ///物业费
    case OwnerBuildingEditTypePropertyCoast
    ///车位数
    case OwnerBuildingEditTypeParkingNum
    ///车位费
    case OwnerBuildingEditTypeParkingCoast
    ///空调类型
    case OwnerBuildingEditTypeAirConditionType
    ///空调费
    case OwnerBuildingEditTypeAirConditionCoast
    ///电梯数 - 客梯
    case OwnerBuildingEditTypePassengerNum
    ///电梯数 - 货梯
    case OwnerBuildingEditTypeFloorCargoNum
    ///网络
    case OwnerBuildingEditTypeNetwork
    ///入驻企业 -最多5个
    case OwnerBuildingEditTypeEnterCompany
    ///详细介绍
    case OwnerBuildingEditTypeDetailIntroduction
    ///特色
    case OwnerBuildingEditTypeFeature
    ///上传楼盘图片
    case OwnerBuildingEditTypeBuildingImage
    ///上传楼盘视频
    case OwnerBuildingEditTypeBuildingVideo
    ///上传楼盘vr
    case OwnerBuildingEditTypeBuildingVR

}

//房东
//编辑办公室页面
public enum OwnerBuildingOfficeType {
    ///标题
    case OwnerBuildingOfficeTypeName
    ///面积 *
    case OwnerBuildingOfficeTypeArea
    ///可置工位 *
    case OwnerBuildingOfficeTypeSeats
    ///租金单价 *
    case OwnerBuildingOfficeTypePrice
    ///租金总价 *
    case OwnerBuildingOfficeTypeTotalPrice
    ///所在楼层 *
    case OwnerBuildingOfficeTypeTotalFloor
    ///净高 *
    case OwnerBuildingOfficeTypeClearHeight
    ///层高
    case OwnerBuildingOfficeTypeFloorHeight
    ///最短租期 *
    case OwnerBuildingOfficeTypeMinRentalPeriod
    ///免租期 *
    case OwnerBuildingOfficeTypeRentFreePeriod
    ///物业费 *
    case OwnerBuildingOfficeTypePropertyCoast
    ///装修程度 *
    case OwnerBuildingOfficeTypeDocument
    ///户型格局简介
    case OwnerBuildingOfficeTypeIntrodution
    ///办公室特色
    case OwnerBuildingOfficeTypeFeature
    ///上传办公室图片 *
    case OwnerBuildingOfficeTypeBuildingImage
    ///上传办公室视频
    case OwnerBuildingOfficeTypeBuildingVideo
    ///上传办公室vr
    case OwnerBuildingOfficeTypeBuildingVR
}

//房东
//编辑网点页面
public enum OwnerBuildingJointEditType {
    ///网点名称
    case OwnerBuildingJointEditTypeBuildingName
    ///所在区域
    case OwnerBuildingJointEditTypeDisctict
    ///详细地址
    case OwnerBuildingJointEditTypeDetailAddress
    ///所在楼层
    case OwnerBuildingJointEditTypeTotalFloor
    ///净高
    case OwnerBuildingJointEditTypeClearHeight
    ///空调类型
    case OwnerBuildingJointEditTypeAirConditionType
    ///空调费
    case OwnerBuildingJointEditTypeAirConditionCoast
    ///会议室数量
    case OwnerBuildingJointEditTypeConferenceNumber
    ///最多容纳人数
    case OwnerBuildingJointEditTypeConferencePeopleNumber
    ///会议室配套
    case OwnerBuildingJointEditTypeRoomMatching
    ///车位数
    case OwnerBuildingJointEditTypeParkingNum
    ///车位费
    case OwnerBuildingJointEditTypeParkingCoast
    ///电梯数 - 客梯
    case OwnerBuildingJointEditTypePassengerNum
    ///电梯数 - 货梯
    case OwnerBuildingJointEditTypeFloorCargoNum
    ///网络
    case OwnerBuildingJointEditTypeNetwork
    ///入驻企业
    case OwnerBuildingJointEditTypeEnterCompany
    ///详细介绍
    case OwnerBuildingJointEditTypeDetailIntroduction
    ///特色
    case OwnerBuildingJointEditTypeFeature
    ///共享服务
    case OwnerBuildingJointEditTypeShareService
    ///上传楼盘图片
    case OwnerBuildingJointEditTypeBuildingImage
    ///上传楼盘视频
    case OwnerBuildingJointEditTypeBuildingVideo
    ///上传楼盘vr
    case OwnerBuildingJointEditTypeBuildingVR
}

//房东
//独立办公室编辑页面
public enum OwnerBuildingJointOfficeType {
    ///标题
    case OwnerBuildingJointOfficeTypeName
    ///出租方式 *
    //case OwnerBuildingJointOfficeTypeRentType
    ///工位数 *
    case OwnerBuildingJointOfficeTypeSeats
    ///面积
    case OwnerBuildingJointOfficeTypeArea
    ///租金
    case OwnerBuildingJointOfficeTypePrice
    ///所在楼层 *
    case OwnerBuildingJointOfficeTypeTotalFloor
    ///最短租期 *
    case OwnerBuildingJointOfficeTypeMinRentalPeriod
    ///免租期 *
    case OwnerBuildingJointOfficeTypeRentFreePeriod
    ///空调类型 *
    case OwnerBuildingJointOfficeTypeAirConditionType
    ///空调费
    case OwnerBuildingJointOfficeTypeAirConditionCoast
    ///车位数
    case OwnerBuildingJointOfficeTypeParkingNum
    ///车位费
    case OwnerBuildingJointOfficeTypeParkingCoast
    ///净高
    case OwnerBuildingJointOfficeTypeClearHeight
    ///户型格局简介
    case OwnerBuildingJointOfficeTypeIntrodution
    ///上传办公室图片 *
    case OwnerBuildingJointOfficeTypeBuildingImage
    ///上传办公室视频
    case OwnerBuildingJointOfficeTypeBuildingVideo
    ///上传办公室vr
    case OwnerBuildingJointOfficeTypeBuildingVR
}

//房东
//开放工位编辑页面
public enum OwnerBuildingJointOpenStationType {
    ///工位数 *
    case OwnerBuildingJointOpenStationTypeSeats
    ///租金 *
    case OwnerBuildingJointOpenStationTypePrice
    ///所在楼层 *
    case OwnerBuildingJointOpenStationTypeTotalFloor
    ///净高
    case OwnerBuildingJointOpenStationTypeClearHeight
    ///最短租期 *
    case OwnerBuildingJointOpenStationTypeMinRentalPeriod
    ///免租期 *
    case OwnerBuildingJointOpenStationTypeRentFreePeriod
    ///上传图片 *
    case OwnerBuildingJointOpenStationTypeBuildingImage
}


/*
 空调
 中央空调 0
 独立空调 1
 无空调 2
 */
public enum OwnerAircontiditonType: String {
    ///默认为空
    case OwnerAircontiditonTypeDefault = ""
    ///中央空调
    case OwnerAircontiditonTypeCenter = "中央空调"
    ///独立空调
    case OwnerAircontiditonTypeIndividual = "独立空调"
    ///无空调
    case OwnerAircontiditonTypeNone = "无空调"
}
/*
 免租期
 */
public enum OwnerRentFreePeriodType: String {
    ///面议
    case OwnerRentFreePeriodTypeDefault = "面议"
    ///1个月
    case OwnerRentFreePeriodTypeMonth1 = "1个月"
    ///2个月
    case OwnerRentFreePeriodTypeMonth2 = "2个月"
    ///3个月
    case OwnerRentFreePeriodTypeMonth3 = "3个月"
    ///4个月
    case OwnerRentFreePeriodTypeMonth4 = "4个月"
    ///5个月
    case OwnerRentFreePeriodTypeMonth5 = "5个月"
    ///6个月
    case OwnerRentFreePeriodTypeMonth6 = "6个月"
    ///7个月
    case OwnerRentFreePeriodTypeMonth7 = "7个月"
    ///8个月
    case OwnerRentFreePeriodTypeMonth8 = "8个月"
    ///9个月
    case OwnerRentFreePeriodTypeMonth9 = "9个月"
    ///10个月
    case OwnerRentFreePeriodTypeMonth10 = "10个月"
    ///11个月
    case OwnerRentFreePeriodTypeMonth11 = "11个月"
    ///12个月
    case OwnerRentFreePeriodTypeMonth12 = "12个月"
}

/*
 空调费
 中央空调 “包含在物业费内，加时另计”
 独立空调 “按电表计费”
 无空调 “无“
 */
public enum OwnerAircontiditonFeeType: String {
    case OwnerAircontiditonFeeTypeDefault = ""
    case OwnerAircontiditonFeeTypeCenter = "包含在物业费内，加时另计"
    case OwnerAircontiditonFeeTypeIndividual = "按电表计费"
    case OwnerAircontiditonFeeTypeNone = "无"
}

///所在楼层
public enum OwnerBuildingTotalFloorType: String {
    case OwnerBuildingTotalFloorTypeDefault = ""
    case OwnerBuildingTotalFloorTypeOne = "单层      "
    case OwnerBuildingTotalFloorTypeMore = "多层      "
}


///业主 - 更多操作
public enum OWnerFYMoreSettingEnum: String {
    case xiaJiaEnum = "下架"
    case deleteEnum = "删除房源"
}

///业主 - 添加楼盘 楼盘类型
public enum OWnerBuildingTypeEnum: String {
    case xieziEnum = "写字楼"
    case chuangyiEnum = "创意园"
    case chanyeEnum = "产业园"
}
