//
//  RecipeCell.h
//  RecipesKit
//
//  Created by Perry on 14-7-10.
//  Copyright (c) 2014年 Felipe Last Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RecipeCellReuseIdentifier @"RecipeCell"

@interface RecipeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
