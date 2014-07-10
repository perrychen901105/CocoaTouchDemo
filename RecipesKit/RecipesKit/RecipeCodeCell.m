//
//  RecipeCodeCell.m
//  RecipesKit
//
//  Created by Perry on 14-7-10.
//  Copyright (c) 2014年 Felipe Last Marsetti. All rights reserved.
//

#import "RecipeCodeCell.h"

@implementation RecipeCodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.servingsLabel = [[UILabel alloc] init];
        self.servingsLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:13];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:12];
        
        self.servingsLabel.frame = CGRectMake(10, 21, 270, 21);
        self.nameLabel.frame = CGRectMake(10, 2, 270, 21);
        [self.contentView addSubview:self.servingsLabel];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)reuseIdentifier
{
    return RecipeCodeCellReuseIdentifier;
}

@end
