//
//  RecipeDetailViewController.m
//  RecipesKit
//
//  Created by Felipe on 8/6/12.
//  Copyright (c) 2012 Felipe Last Marsetti. All rights reserved.
//

#import "RecipeDetailViewController.h"

@interface RecipeDetailViewController ()

@end

@implementation RecipeDetailViewController

#pragma mark - Properties

- (void)setRecipe:(Recipe *)newRecipe
{
    // Only set the new recipe if it's not the same one that's currently stored
    if (_recipe != newRecipe)
    {
        _recipe = newRecipe;
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
