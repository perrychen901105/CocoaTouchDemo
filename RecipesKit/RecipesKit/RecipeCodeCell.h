//
//  RecipeCodeCell.h
//  RecipesKit
//
//  Created by Perry on 14-7-10.
//  Copyright (c) 2014年 Felipe Last Marsetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RecipeCodeCellReuseIdentifier @"RecipeCodeCell"
#define RecipeCodeCellSegue           @"RecipeCodeCellSegue"

@interface RecipeCodeCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *servingsLabel;

@end
