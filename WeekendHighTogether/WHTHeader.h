//
//  WHTHeader.h
//  WeekendHighTogether
//  以后把所有的接口都放到这里面定义
//  Created by SCJY on 16/1/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#ifndef WHTHeader_h
#define WHTHeader_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ClassifyListType) {
    ClassifyListTypeShowRepertoire = 1,//演出剧目
    ClassifyListTypeTouristPlace,      //景点场馆
    ClassifyListTypeStudyPUZ,          //学习益智
    ClassifyListTypeFamilyTravel       //亲子旅游
};


//首页数据接口
#define kMainDataList @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&limit=30&page=1&cityid="

//活动详情接口
#define kActivityDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&cityid=1"
//活动专题接口
#define kActivityTheme @"http://e.kumi.cn/app/positioninfo.php?_s_=1b2f0563dade7abdfdb4b7caa5b36110&_t_=1452218405&channelid=appstore&cityid=1&limit=30&page=1"
//精选活动接口
#define kGoodActivity @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&limit=30&type=1"
//热门专题接口
#define kHotActivity @"http://e.kumi.cn/app/positionlist.php?_s_=e2b71c66789428d5385b06c178a88db2&_t_=1452237051&channelid=appstore&limit=30"
//分类列表接口
#define kClassifyList @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=dad924a9b9cd534b53fc2c521e9f8e84&_t_=1452495193&channelid=appstore&limit=30"
//发现接口
#define kDiscover @"http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&lat=34.62172291944134&lng=112.4149512442411"
//http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&cityid=1&lat=34.62172291944134&lng=112.4149512442411
//选择城市接口
#define kSelectCity @"http://e.kumi.cn/app/citylist.php"
//新浪微博
#define kAppKey @"730188156"
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define kAppSecret @"68aadad72d8403b956bab55c183d22f9"

//微信
#define kWeixinAppId @"wx9864cffa76e0ac88"
#define kWeixinAppSecret @"1a273c7850baeff5baec7be6cd94daf9"

#define kBmobAppKey @"e1eee030456cb5bcf9ed3ac7093f7580"

#endif /* WHTHeader_h */
