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

@interface RecipeDetailViewController () <UIActionSheetDelegate ,UITextFieldDelegate, UIPageViewControllerDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIBarButtonItem *actionButton;
@property (strong, nonatomic) UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *servingsButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
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

#pragma mark - UIActionSheet methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.recipe removeImages:self.recipe.images];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (buttonIndex == 1) {
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (void)cameraTapped
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete All Images"
                                                    otherButtonTitles:@"Select Image", nil];
    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
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
    
    [self.pageViewController.view setBackgroundColor:[UIColor clearColor]];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = (id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
}

- (void)keyboardWillHide:(NSNotification *)userInfo
{
    self.navigationItem.rightBarButtonItems = @[self.cameraButton, self.actionButton];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.frame = self.view.bounds;
}

- (void)keyboardWillShow:(NSNotification *)userInfo
{
    self.navigationItem.rightBarButtonItems = @[self.doneButton, self.actionButton];
    
    CGRect keyboardFrame = [[userInfo.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardFrame.size.height);
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
    if ([self.view window] == nil) {
        _actionButton = nil;
        _cameraButton = nil;
        _doneButton = nil;
        _imagePickerController = nil;
        _notesTextView = nil;
        _pageViewController = nil;
        _scrollView = nil;
        _servingsButton = nil;
        _titleTextField = nil;
        self.view = nil;
    }
}

#pragma mark - UIImagePickerControll
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = ((UIImage *)[info objectForKey:UIImagePickerControllerEditedImage]);
    
    float actualHeight = selectedImage.size.height;
    float actualWidth = selectedImage.size.width;
    float imgRatio = actualWidth / actualHeight;
    float maxRatio = 320.0/180;
    
    // 获取图片纵横比
    if (imgRatio != maxRatio) {
        if (imgRatio < maxRatio) {
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0f;
        } else {
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    
    // 3
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [selectedImage drawInRect:rect];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 4
    Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
                                                 inManagedObjectContext:self.managedObjectContext];
    image.image = croppedImage;
    
    [self.recipe addImagesObject:image];
    
    // 5
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Append Data Save Error = %@", [error localizedDescription]);
    }
    
    // 6
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pageViewController"]) {
        if (self.recipe.images.count > 0) {
            self.pageViewController = segue.destinationViewController;
            self.pageViewController.dataSource = self;
            PhotosViewController *photosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosViewController"];
            photosViewController.index = 0;
            Image *image = [[self.recipe.images allObjects] objectAtIndex:0];
            photosViewController.image = image.image;
            [self.pageViewController setViewControllers:@[photosViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    PhotosViewController *previousViewController = (PhotosViewController *)viewController;
    NSUInteger pagesCount = self.recipe.images.count;
    pagesCount--;
    if (previousViewController.index == pagesCount) {
        return nil;
    }
    PhotosViewController *photosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosViewController"];
    photosViewController.index = previousViewController.index + 1;
    
    photosViewController.image = [[[self.recipe.images allObjects] objectAtIndex:photosViewController.index] image];
    return photosViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    PhotosViewController *previousViewController = (PhotosViewController *)viewController;
    if (previousViewController.index == 0) {
        return nil;
    }
    
    PhotosViewController *photosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosViewController"];
    photosViewController.index = previousViewController.index - 1;
    photosViewController.image = [[[self.recipe.images allObjects] objectAtIndex:photosViewController.index] image];
    return photosViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // 返回页面视图控制器拥有的页面总数
    return self.recipe.images.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    // 用来确定page view controller的当前索引
    PhotosViewController *photosViewController = [pageViewController.viewControllers lastObject];
    return photosViewController.index;
}

@end
