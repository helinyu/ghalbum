//
//  YDImgBrowserCCell.m
//  SportsBar
//
//  Created by Aka on 2017/11/20.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgBrowserCCell.h"
#import "YDAlbumAssetService.h"
#import "YDPreviewBottomView.h"
#import "YDObtainManagerMgr.h"
#import "UIView+YYAdd.h"

@interface YDImgBrowserCCell ()

@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

@property (nonatomic, strong) UIImageView *iconPlayImgView;
@property (nonatomic, strong) AVPlayerLayer *playlayer;

@end

static CGFloat const kPlayIconLength = 44.f;

@implementation YDImgBrowserCCell

- (void)baseInit {
    [super baseInit];
    
    {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressGRAction:)];
        [self addGestureRecognizer:longPress];
        [self addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGRAction:)]];
    }
    
    {
        _iconPlayImgView = [UIImageView new];
        [self.contentView addSubview:_iconPlayImgView];
        [_iconPlayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.height.mas_equalTo(DWF(kPlayIconLength));
        }];
        _iconPlayImgView.image = [UIImage imageNamed:@"icon_circle_editor_player"];
        _iconPlayImgView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
        [_iconPlayImgView addGestureRecognizer:tapGR];
        _iconPlayImgView.userInteractionEnabled = YES;
        _iconPlayImgView.hidden = YES;
    }
    
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.indexBtn.hidden = YES;
    }
}

- (void)onTapAction:(UIButton *)sender {
    !_tapPlayVideoblock? :_tapPlayVideoblock();
}

- (void)onLongPressGRAction:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        !_longPressBlock? :_longPressBlock();
    }
}

- (void)onTapGRAction:(UITapGestureRecognizer *)recognizer {
    !_tapBlock? :_tapBlock();
}

- (void)configureWithImg:(UIImage *)img longPress:(VoidBlock)longPressBlock tap:(VoidBlock)tapBlock {
    self.imgView.image = img;
    _longPressBlock = longPressBlock;
    _tapBlock = tapBlock;
}

- (void)setAssetItem:(TZAssetModel *)assetItem {
    _assetItem = assetItem;
    [self setPlayIconHidden:assetItem];
    
    if (_assetItem && _imageRequestID) {
//        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
//    __weak __typeof(self) weakSelf = self;
//    _imageRequestID = [[TZImageManager manager] getPhotoWithAsset:assetItem.asset photoWidth:self.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//        if (![assetItem isEqual:_assetItem]) return;
//        self.imgView.image = photo;
//        if (weakSelf.imageProgressUpdateBlock) {
//            weakSelf.imageProgressUpdateBlock(1);
//        }
//        if (!isDegraded) {
//            weakSelf.imageRequestID = 0;
//        }
//    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//        if (![assetItem isEqual:_assetItem]) return;
//        if (weakSelf.imageProgressUpdateBlock && progress < 1) {
//            weakSelf.imageProgressUpdateBlock(progress);
//        }
//
//        if (progress >= 1) {
//            weakSelf.imageRequestID = 0;
//        }
//    } networkAccessAllowed:YES];
}

- (void)setPlayIconHidden:(TZAssetModel *)assetItem {
//    if (assetItem.type == TZAssetModelMediaTypeVideo) {
//        _iconPlayImgView.hidden = NO;
//    }
//    else {
//        _iconPlayImgView.hidden = YES;
//    }
}

- (void)prepareForReuse {
    _iconPlayImgView.hidden = YES;
}

- (void)showVideoWithPlayerLayer:(AVPlayerLayer *)playerLayer {
//    if (_assetItem.type == TZAssetModelMediaTypeVideo) {
//        _iconPlayImgView.hidden = YES;
//        _playlayer.hidden = NO;
//        _playlayer = playerLayer;
//        [self.imgBgView.layer addSublayer:_playlayer];
//        _playlayer.frame = self.imgView.bounds;
//    }
}

- (void)showImg {
//    if (_assetItem.type == TZAssetModelMediaTypeVideo) {
//        _iconPlayImgView.hidden = NO;
//        _playlayer.hidden = YES;
//        [_playlayer removeFromSuperlayer];
//        _playlayer = nil;
//    }
}

@end
