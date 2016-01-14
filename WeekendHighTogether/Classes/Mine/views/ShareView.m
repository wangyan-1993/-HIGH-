//
//  ShareView.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/1/14.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ShareView.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "WXApiObject.h"
@interface ShareView()<WBHttpRequestDelegate>
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *blackView;


@end
@implementation ShareView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeigth)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [window addSubview:self.blackView];
    
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeigth, kWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.shareView];
    
    
    
    //微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(40, 20, 80, 120);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    image.image = [UIImage imageNamed:@"share_weibo"];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 80, 20)];
    label1.text = @"分享到微博";
    label1.font = [UIFont systemFontOfSize:12];
    
    [weiboBtn addSubview:image];
    [weiboBtn addSubview:label1];
    [weiboBtn addTarget:self action:@selector(weiboShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weiboBtn];
    //朋友
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(140, 20, 80, 120);
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(120, 20, 60, 60)];
    image1.image = [UIImage imageNamed:@"weixin"];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(120, 80, 80, 20)];
    label2.text = @"分享给朋友";
    [weiboBtn addSubview:image1];
    [weiboBtn addSubview:label2];
    label2.font = [UIFont systemFontOfSize:12];
    
    [friendBtn addTarget:self action:@selector(friendShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:friendBtn];
    
    
    //朋友圈
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(240, 20, 80, 120);
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(220, 20, 60, 60)];
    image2.image = [UIImage imageNamed:@"circle"];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(220, 80, 80, 20)];
    label3.text = @"分享到朋友圈";
    label3.font = [UIFont systemFontOfSize:12];
    [weiboBtn addSubview:image2];
    [weiboBtn addSubview:label3];
    
    [circleBtn addTarget:self action:@selector(circleShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:circleBtn];
    
    //取消按钮
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(70, 130, kWidth - 140, 40);
    removeBtn.backgroundColor = mainColor;
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.blackView.alpha = 0.6;
        self.shareView.frame = CGRectMake(0, kHeigth - 200, kWidth, 200);
    }];
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [WeiboSDK logOutWithToken:myDelegate.wbtoken delegate:self withTag:@"user1"];
}

- (void)removeView{
    [UIView animateWithDuration:0.6 animations:^{
        self.shareView.frame = CGRectMake(0, kHeigth, kWidth, 200);
        self.blackView.frame = CGRectMake(0, 0, kWidth, kHeigth);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }];
    
}

#pragma mark---btn method

- (void)cancel{
    [self removeView];
}

//微博
- (void)weiboShare{
    [self removeView];
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    
    WBSendMessageToWeiboRequest *requestSend = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]authInfo:request access_token:myDelegate.wbtoken];
    [WeiboSDK sendRequest:requestSend];
    
}

- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = NSLocalizedString(@"周末HIGH起来", nil);
    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"周末HIGH起来", nil), [[NSDate date] timeIntervalSince1970]];
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share_weibo" ofType:@"png"]];
    webpage.webpageUrl = @"http://www.baidu.com";
    message.mediaObject = webpage;
    WBImageObject *image = [WBImageObject object];
    
    return message;
}
//朋友
- (void)friendShare{
    [self removeView];
    //分享APP
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"tubiao"]];
    message.title = @"周末HIGH起来";
    message.description = @"周末一块来吧,吃喝玩乐,应有尽有,走过路过,不要错过,带上自己的小伙伴一起来吧,GO,GO,GO！";
//    WXImageObject *imageObject = [WXImageObject object];
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"002" ofType:@".jpg"];
//    imageObject.imageData = [NSData dataWithContentsOfFile:filePath];
//    message.mediaObject = imageObject;
    
    
 //分享APP
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    /** 若第三方程序不存在，微信终端会打开该url所指的App下载地址
     * @note 长度不能超过10K
     */
    ext.url = @"http://www.qq.com";
    
    Byte* pBuffer = (Byte *)malloc(1024 * 100);
    memset(pBuffer, 0, 1024 * 100);
    NSData* data = [NSData dataWithBytes:pBuffer length:1024 * 100];
    ext.fileData = data;
    message.mediaObject = ext;

    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;//分享给好友
    [WXApi sendReq:req];
}
//朋友圈
- (void)circleShare{
    [self removeView];    
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"跟我一起来百度 周末HIGH起来";
    [message setThumbImage:[UIImage imageNamed:@"tubiao"]];
    WXWebpageObject *web = [WXWebpageObject object];
    web.webpageUrl = @"http://www.baidu.com";
    message.mediaObject = web;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
