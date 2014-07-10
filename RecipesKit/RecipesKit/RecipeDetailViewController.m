//
//  RecipeDetailViewController.m
//  RecipesKit
//
//  Created by Felipe on 8/6/12.
//  Copyright (c) 2012 Felipe Last Marsetti. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "AppDelegate.h"
#import "ServingsViewController.h"
#import "Image.h"
#import "PhotosViewController.h"

@interface RecipeDetailViewController () <UITextFieldDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) UIBarButtonItem *actionButton;
@property (strong, nonatomic) UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *servingsButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) UIPageViewController *pageViewController;
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

- (void)actionTapped
{
    NSString *titleString = [NSString stringWithFormat:@"I just made a delicious %@ recipe using RecipesKit",self.recipe.title];
    UIImage *activityImage;
    if (self.recipe.images.count > 0) {
        Image *image = [self.recipe.images anyObject];
        activityImage = image.image;
    }
    NSArray *items = @[titleString];
    
    if (activityImage) {
        items = @[titleString, activityImage];
    }
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)localDoneTapped
{
    if (self.notesTextView.isFirstResponder) {
        [self.notesTextView resignFirstResponder];
    } else if (self.titleTextField.isFirstResponder) {
        [self.titleTextField resignFirstResponder];
    }
    self.recipe.title = self.titleTextField.text;
    self.recipe.notes = self.notesTextView.text;
}

- (void)cameraTapped
{
    
}

- (IBAction)doneTapped:(UIStoryboardSegue *)segue
{
    ServingsViewController *servingsViewController = (ServingsViewController *)segue.sourceViewController;
    NSNumber *servings = @(([servingsViewController.pickerView selectedRowInComponent:0]) + 1);
    self.recipe.servings = servings;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleTextField resignFirstResponder];
    return YES;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionTapped)];
    self.cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped)];
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(localDoneTapped)];
    
    self.navigationItem.rightBarButtonItems = @[self.cameraButton, self.actionButton];
}

- (void)keyboardWillHide:(NSNotification *)userInfo
{
    self.navigationItem.rightBarButtonItems = @[self.cameraButton, self.actionButton];
}

- (void)keyboardWillShow:(NSNotification *)userInfo
{
    self.navigationItem.rightBarButtonItems = @[self.doneButton, self.actionButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.notesTextView.text = self.recipe.notes;
    [self.servingsButton setTitle:[self.recipe servingsString] forState:UIControlStateNormal];
    [self.servingsButton setTitle:[self.recipe servingsString] forState:UIControlStateHighlighted];
    self.titleTextField.text = self.recipe.title;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self localDoneTapped];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
