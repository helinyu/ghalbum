//
//  YDAlbumModel.m
//  jsonParser
//
//  Created by mac on 15/6/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "YDAlbumModel.h"

@implementation YDAlbumModel

- (void)setResult:(id)result needFetchAssets:(BOOL)needFetchAssets {
    _result = result;
    if (needFetchAssets) {
//        [[TZImageManager manager] getAssetsFromFetchResult:result completion:^(NSArray<TZAssetModel *> *models) {
//            self->_models = models;
//            if (self->_selectedModels) {
//                [self checkSelectedModels];
//            }
//        }];
    }
}


@end
