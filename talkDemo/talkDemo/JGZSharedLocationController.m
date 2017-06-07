//
//  JGZSharedLocationController.m
//  talkDemo
//
//  Created by 江贵铸 on 2017/6/6.
//  Copyright © 2017年 江贵铸. All rights reserved.
//

#import "JGZSharedLocationController.h"
#import "MAAnnotationView+JGZMAAnnotationView.h"
#import "JGZLocationModel.h"
#import "JGZAccountTool.h"
#import "JGZAccount.h"
#import "CustomAnnotationView.h"
#import "CustomAnnotation.h"
@interface JGZSharedLocationController ()<EMChatManagerDelegate,MAMapViewDelegate>
@property (nonatomic,strong) EMConversation *ConverSation;
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) NSMutableArray<CustomAnnotationView *> *UserLocationArray;
@end

@implementation JGZSharedLocationController

//-(NSMutableArray *)UserLocationArray{
//    if (_UserLocationArray) {
//        _UserLocationArray = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _UserLocationArray;
//}
-(instancetype)initWith:(EMConversation *)ConverSation{
    if (self=[super init]) {
        self.ConverSation=ConverSation;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.UserLocationArray=[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=self.ConverSation.conversationId;
    [[EMClient sharedClient].chatManager addDelegate:self];
    //[self sendCmdMessage:self.ConverSation.conversationId];
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.desiredAccuracy= kCLLocationAccuracyBest;
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
//    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(31.332951931423613, 121.38373128255208);
//    [self createAnnotationWithCoords:coords1];
//    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(31.352951931423613, 121.38373128255208);
//    [self createAnnotationWithCoords:coords2];
  
}

//创建大头针方法
-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords userID:(NSString *)userID {
    CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
    annotation.coordinate = coords;
    annotation.title = @"标题";
    annotation.subtitle = @"子标题";
    annotation.icon = @"arrow.png";
    annotation.UserID = userID;
    [self.mapView addAnnotation:annotation];
}
-(void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    NSLog(@"87878");
}
//自定义大头针模型
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(CustomAnnotation *)annotation
{

    // 如果返回nil, 就会按照系统的默认做法
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
                MAAnnotationView *userView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"UserAnnotationIdentifer"];
                if (userView == nil) {
                    userView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"UserAnnotationIdentifer"];
                }
                userView.image = [UIImage imageNamed:@"arrow.png"];
                return userView;
    }else if ([annotation isKindOfClass:[CustomAnnotation class]]){
    // 1.创建annoView
    CustomAnnotationView *annoView = [CustomAnnotationView annotationViewWithMapView:mapView];
    // 2.给大头针控件传递模型数据
        annotation.icon = @"arrow.png";
    annoView.annotation = annotation;
        
        
        BOOL ishave = NO;
        for (CustomAnnotationView *AnnotationView in self.UserLocationArray) {
            
            if ([AnnotationView.UserID isEqualToString:annoView.UserID]) {
                ishave=YES;
            }
        }
        if (ishave==NO) {
            annoView.UserID = annotation.UserID;
            [self.UserLocationArray addObject:annoView];
        }
    return annoView;
        
    }
    return nil;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
   MAAnnotationView *userView = [mapView viewForAnnotation:userLocation];
    CLHeading *userHeading = userLocation.heading;
    [userView rotateWithHeading:userHeading];
    
    [self sendCmdMessage:self.ConverSation.conversationId Heading:userHeading Location:userLocation.location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendCmdMessage:(NSString *)conversationId Heading:(CLHeading*)userHeading Location:(CLLocation*)Location{
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"shareLocation"];

    if (userHeading==nil) {
        return;
    }
    NSString * latitude= [NSString stringWithFormat:@"%f",Location.coordinate.latitude];
    NSString * longitude= [NSString stringWithFormat:@"%f",Location.coordinate.longitude];
    NSDictionary *ext = @{@"UserAccount":[JGZAccountTool LoginAccount].Account,@"latitude":latitude,@"longitude":longitude,@"magneticHeading":@(userHeading.magneticHeading),@"trueHeading":@(userHeading.trueHeading),@"headingAccuracy":@(userHeading.headingAccuracy),@"x":@(userHeading.x),@"y":@(userHeading.y),@"z":@(userHeading.z),@"timestamp":@""};
    NSString *currentUsername = [EMClient sharedClient].currentUsername;
    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversationId
                                                              from:currentUsername
                                                                to:conversationId
                                                              body:body
                                                               ext:ext];
    message.chatType = EMChatTypeGroupChat;
    [[EMClient sharedClient].chatManager sendMessage:message
                                            progress:nil
                                          completion:^(EMMessage *message, EMError *error) {
                                              if (!error) {
                                                  NSLog(@"发送成功");
                                              }
                                          }
     ];
}
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    [aCmdMessages enumerateObjectsWithOptions:NSEnumerationReverse
                                   usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
   if ([obj isKindOfClass:[EMMessage class]]) {
       EMMessage *cmdMessage = (EMMessage *)obj;
       // 判断是否是位置共享消息
       EMCmdMessageBody *body = (EMCmdMessageBody *)cmdMessage.body;
       if ([body.action isEqualToString:@"shareLocation"]) {
           //解析出来的经纬度
           NSLog(@"%@",cmdMessage.ext);
           double latitude = [[cmdMessage.ext objectForKey:@"latitude"] doubleValue];
           double longitude = [[cmdMessage.ext objectForKey:@"longitude"] doubleValue];
//           CGFloat x =[[cmdMessage.ext objectForKey:@"x"] floatValue];
//           CGFloat y =[[cmdMessage.ext objectForKey:@"y"] floatValue];
//           CGFloat z =[[cmdMessage.ext objectForKey:@"z"] floatValue];
           CGFloat magneticHeading =[[cmdMessage.ext objectForKey:@"magneticHeading"] floatValue];
//           CGFloat trueHeading =[[cmdMessage.ext objectForKey:@"trueHeading"] floatValue];
//           CGFloat headingAccuracy =[[cmdMessage.ext objectForKey:@"headingAccuracy"] floatValue];
           NSString *AccountString =[cmdMessage.ext objectForKey:@"UserAccount"];
           if ([AccountString isEqualToString:[JGZAccountTool LoginAccount].Account]) {
               return ;
           }
           BOOL ishave = NO;
           for (CustomAnnotationView *AnnotationView in self.UserLocationArray) {
               
               if ([AnnotationView.UserID isEqualToString:AccountString]) {
                   ishave=YES;
                   [AnnotationView rotateWithmagneticHeading:magneticHeading];
                   CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latitude, longitude);
                   AnnotationView.annotation.coordinate=coords;
                   break;
               }
           }
           if (ishave==NO) {
               CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latitude, longitude);
              [self createAnnotationWithCoords:coords userID:AccountString];
 
           }
           
       }
   }
     }
     ];
}
@end

