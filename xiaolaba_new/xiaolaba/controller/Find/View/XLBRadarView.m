//
//  XLBRadarView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/6.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBRadarView.h"
#import "XLBRadarSubView.h"
#import "XLBSRadarView.h"
#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
@interface XLBRadarView()<BMKLocationServiceDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong)UIImageView * bView;
@property (nonatomic, strong)UIImageView * iconImageView;

@property (nonatomic, strong)UILabel * contentLabel;
@property (nonatomic, strong)UIButton * shareBtn;
@property (nonatomic, strong)BMKMapView *mapView;
@property (nonatomic, strong)MKMapView *mapSubView;
@property (nonatomic, strong)CLLocationManager *locManager;

@end

@implementation XLBRadarView

- (void)dealloc {
//    _service.delegate = nil;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    img.image = [UIImage imageNamed:@"bg_cy_ld"];
    [self addSubview:img];
    
    _mapSubView = [[MKMapView alloc] init];
    if (iPhoneX) {
        _mapSubView.frame = CGRectMake(-25, 70, self.frame.size.width + 50, self.frame.size.width + 50);
    }else {
        _mapSubView.frame = CGRectMake(-25, 50, self.frame.size.width + 50, self.frame.size.width + 50);
    }
    _mapSubView.mapType = MKMapTypeStandard;
    _mapSubView.layer.masksToBounds = YES;
    _mapSubView.layer.cornerRadius = (self.frame.size.width + 50) / 2;
    _mapSubView.centerX = self.centerX;
    MKCoordinateSpan span=MKCoordinateSpanMake(0.021251, 0.016093);
    [_mapSubView setRegion:MKCoordinateRegionMake(self.mapSubView.userLocation.coordinate, span) animated:NO];
    [self addSubview:_mapSubView];
    
    [self.locManager startUpdatingLocation];
    
    
//    _mapView = [[BMKMapView alloc] init];
//    if (iPhoneX) {
//        _mapView.frame = CGRectMake(15, 104, self.frame.size.width - 50, self.frame.size.width - 50);
//    }else {
//        _mapView.frame = CGRectMake(15, 84, self.frame.size.width - 50, self.frame.size.width - 50);
//    }
//    [_mapView setMapType:BMKMapTypeNone];
//    _mapView.zoomLevel = 15;
//    _mapView.layer.masksToBounds = YES;
//    _mapView.layer.cornerRadius = (self.frame.size.width - 50) / 2;
//    _mapView.centerX = self.centerX;
//    [self addSubview:_mapView];
    
//    _bView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 84, self.frame.size.width - 50, self.frame.size.width - 50)];
//    _bView.userInteractionEnabled = YES;
//    _bView.centerX = self.centerX;
//    _bView.image = [UIImage imageNamed:@"icon_ditu"];
//    _bView.backgroundColor = nil;
//    _bView.layer.masksToBounds = YES;
//    _bView.contentMode = UIViewContentModeScaleAspectFill;
//    _bView.layer.cornerRadius = (self.frame.size.width - 50)/2;
//    [self addSubview:_bView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_mapView addGestureRecognizer:tap];

    XLBRadarSubView * view = [[XLBRadarSubView alloc] initWithFrame:_mapSubView.bounds];
    view.backgroundColor = [UIColor clearColor];
    [_mapSubView addSubview:view];

//    XLBSRadarView *sradar = [[XLBSRadarView alloc] initWithFrame:_bView.bounds];
//    sradar.backgroundColor = [UIColor clearColor];
//    [_bView addSubview:sradar];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mapSubView.frame.size.width * .20, _mapSubView.frame.size.width * .20)];
    _iconImageView.center = _mapSubView.center;
    _iconImageView.layer.cornerRadius = _mapSubView.frame.size.width * .20 / 2;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconImageView.layer.borderWidth = 1.0;
    [self addSubview:_iconImageView];

    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _mapSubView.bottom + 50, self.frame.size.width, 20)];
    _contentLabel.text = @"正在查找附近的人....";
    _contentLabel.font = [UIFont systemFontOfSize:18];
    _contentLabel.textColor = [UIColor commonTextColor];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_contentLabel];
}

- (void)setIconImageViewImg {
    if([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[XLBUser user].userModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    }else {
        self.iconImageView.image = [UIImage imageNamed:@"weitouxiang"];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //得到当前位置
    [self.locManager stopUpdatingHeading];
    CLLocation *currentLocation = locations.lastObject;
    self.mapSubView.centerCoordinate = currentLocation.coordinate;
    //需要将地图的显示区域变小
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 3000, 3000);
    [_mapSubView setRegion:region animated:NO];
}
#pragma mark - tapAction
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    if (fabs(point.x - _mapSubView.center.x) <= 40 && fabs(point.y - _mapSubView.center.y) <= 40) {
        [self animationRadarIconImageView:_iconImageView];
    }
}

- (void)animationRadarIconImageView:(UIImageView *)iconImageView
{
    [UIView animateWithDuration:.25 animations:^{
        iconImageView.transform = CGAffineTransformMakeScale(.8, .8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25 animations:^{
            iconImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.25 animations:^{
                iconImageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}


- (CLLocationManager *)locManager{
    
    if (!_locManager) {
        _locManager = [[CLLocationManager alloc]init];
//        _locManager.activityType = CLActivityTypeFitness;   ///<步行导航
        _locManager.delegate = self;
    }
    
    return _locManager;
}


@end
