//  MAOKeyboardHelper.m
//
//  Copyright (c) 2011-2013 mik ( https://github.com/mik69/MAOKit )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Except as contained in this notice, the name(s) of the above copyright holders
//  shall not be used in advertising or otherwise to promote the sale, use or
//  other dealings in this Software without prior written authorization.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "MAOKeyboardHelper.h"
#import "UIView+maoDimensions.h"
#import "UIView+maoAnimation.h"

static CGFloat const maoKeyboardHelperAnimationDuration = 0.3f;

@interface MAOKeyboardHelper ()

@property (nonatomic, strong) NSMutableArray *enabledTextFields;
@property (nonatomic, strong) UIView *lastCustomInputView;

@property (nonatomic, strong, readonly) UIView<MAOInputAccessoryViewProtocol> *commonInputAccessoryView;
@property (nonatomic, strong, readonly) UIView *customInputViewContainer;

@end

@implementation MAOKeyboardHelper

static const NSUInteger beastNumber = 666;

#pragma mark - properties

@synthesize delegate = delegate_;
@synthesize textFields = textFields_;
@synthesize scrollView = scrollView_;
@synthesize currentTextField = currentTextField_;
@synthesize commonInputAccessoryView = commonInputAccessoryView_;
@synthesize customInputViewContainer = customInputViewContainer_;
@synthesize inputAccessoryViewHidden = inputAccessoryViewHidden_;
@synthesize enabledTextFields = enabledTextFields_;
@synthesize lastCustomInputView = lastCustomInputView_;

- (UIView<MAOInputAccessoryViewProtocol> *)defaultInputAccessoryView
{
    return [[MAOInputAccessoryView alloc] init];
}

- (UIView<MAOInputAccessoryViewProtocol> *)innerInputAccessoryView
{
    UIView<MAOInputAccessoryViewProtocol> *view = self.defaultInputAccessoryView;
    view.height = [view.class viewHeight];
    [view setTarget:self
         actionNext:@selector(activateNextTextfield)
         actionPrev:@selector(activatePrevTextfield)
         actionDone:@selector(closeKeyboardByDone)];
    return view;
}

- (id<MAOInputAccessoryViewProtocol>)commonInputAccessoryView
{
    if (!commonInputAccessoryView_) {
        commonInputAccessoryView_ = [self innerInputAccessoryView];
    }
    return commonInputAccessoryView_;
}

- (UIView *)customInputViewContainer
{
    if (!customInputViewContainer_) {
        UIView<MAOInputAccessoryViewProtocol> *const iav = [self innerInputAccessoryView];
        iav.tag = beastNumber;

        customInputViewContainer_ = [[UIView alloc] initWithFrame:(CGRect){
            CGPointZero, UIScreen.mainScreen.bounds.size.width,
            keyboardHeight + [iav.class viewHeight]
        }];
        [customInputViewContainer_ addSubview:iav];
    }
    return customInputViewContainer_;
}

- (void)setInputAccessoryViewHidden:(BOOL)hidden
{
    inputAccessoryViewHidden_ = hidden;
    self.commonInputAccessoryView.hidden = hidden; //= (hidden) ? 0.f : [self.class.commonInputAccessoryViewClass viewHeight];
}

- (void)setTextFields:(NSArray *)textFields
{
    [self clearTextFieldsFromSelf];
    self.enabledTextFields = [NSMutableArray array];
    
    NSMutableArray * fields = [NSMutableArray array];
    for (id candidate in textFields) {
        if ([candidate isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)candidate;
            textField.delegate = self;
            textField.returnKeyType = UIReturnKeyNext;
            textField.inputAccessoryView = self.commonInputAccessoryView;
            [fields addObject:textField];
            [textField addObserver:self forKeyPath:@"enabled" options:0 context:nil];
            if (textField.enabled) [self.enabledTextFields addObject:textField];
        }
    }
    [[fields lastObject] setReturnKeyType:UIReturnKeyDone];
    
    textFields_ = fields;
    self.inputAccessoryViewHidden = (textFields_.count < 2);
}

#pragma mark - lifecycle

- (void)dealloc
{
    [self clearTextFieldsFromSelf];
}

- (id)init
{
    NSAssert(NO, @"this class should be initialized with some parameters");
    return nil;
}

- (id)initWithScrollView:(UIScrollView *)view
{
    NSAssert(view, @"view should not be nil");
    if ((self = [super init])) {
        scrollView_ = view;
    }
    return self;
}

- (id)initWithScrollView:(UIScrollView *)view textFieldsArray:(NSArray *)textFields
{
    self = [self initWithScrollView:view];
    self.textFields = textFields;
    return self;
}

#pragma mark - actions and helper methods

- (void)clearTextFieldsFromSelf
{
    [textFields_ enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
        [textField removeObserver:self forKeyPath:@"enabled"];
        textField.returnKeyType = UIReturnKeyDefault;
        textField.inputAccessoryView = nil;
        textField.delegate = nil;
    }];
}

- (void)closeLastCustomInputViewAnimated:(BOOL)animated
{
    if (!self.lastCustomInputView) return;
    if (animated) {
        [self.lastCustomInputView removeFromSuperviewWithAnimationEffect:UIViewAnimationEffectFlyBottom
                                                                duration:maoKeyboardHelperAnimationDuration];
    } else {
        [self.lastCustomInputView removeFromSuperview];
    }
    self.lastCustomInputView = nil;
}

- (void)closeKeyboardByDone
{
    [self closeKeyboard];
    if ([self.delegate respondsToSelector:@selector(maoKeyboardHelperDidCompleteLastTextField)]) {
        [self.delegate maoKeyboardHelperDidCompleteLastTextField];
    }
}

- (void)closeKeyboard
{
    [self performAnimatedShiftForTextField:nil];
    [self closeLastCustomInputViewAnimated:YES];
    [self.scrollView endEditing:YES];
    currentTextField_ = nil;
}

- (void)updateNavigationButtons:(id<MAOInputAccessoryViewProtocol>)iav withIndex:(NSUInteger)index
{
    iav.actionNextEnabled = (index + 1 < self.enabledTextFields.count);
    iav.actionPrevEnabled = (index > 0);

    if ((self.enabledTextFields.count > 1) && (iav.actionsNextPrevHidden)) {
        iav.actionsNextPrevHidden = NO;
    }
    if ((self.enabledTextFields.count <=1) && (!iav.actionsNextPrevHidden)) {
        iav.actionsNextPrevHidden = YES;
    }
}

- (void)updateNavigationButtonsWithTextField:(UITextField *)textField
{
    const NSUInteger index = [self.enabledTextFields indexOfObject:textField];
    [self updateNavigationButtons:self.commonInputAccessoryView withIndex:index];
    [self updateNavigationButtons:(MAOInputAccessoryView *)[self.customInputViewContainer viewWithTag:beastNumber] withIndex:index];
}

- (void)activateEnabledTextFieldWithIndex:(NSUInteger)index
{
    [[self.enabledTextFields objectAtIndex:index] becomeFirstResponder];
}

- (void)activateNextTextfield
{
    [self activateEnabledTextFieldWithIndex:
     [self.enabledTextFields indexOfObject:self.currentTextField] + 1];
}

- (void)activatePrevTextfield
{
    [self activateEnabledTextFieldWithIndex:
     [self.enabledTextFields indexOfObject:self.currentTextField] - 1];
}

#pragma mark - view shifts with animation

- (void)performAnimatedShiftForTextField:(UITextField *)textField
{
    CGFloat newTopOffset = 0.f;
    if (textField) {
        newTopOffset = ([self.scrollView convertPoint:CGPointZero fromView:textField].y + textField.height * 0.5f) - ((self.scrollView.height - keyboardHeight - [self.commonInputAccessoryView.class viewHeight]) * 0.5f);
        if (newTopOffset < 0.f) newTopOffset = 0.f;
    }
    self.scrollView.scrollEnabled = YES;
    [self.scrollView setContentOffset:(CGPoint){0.f, newTopOffset} animated:YES];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (([object isKindOfClass:[UITextField class]]) && ([keyPath isEqualToString:@"enabled"])) {
        UITextField *tf = (UITextField *)object;
        if (tf.enabled) {
            //check if text field is one of haldled
            if ([self.enabledTextFields indexOfObjectIdenticalTo:tf] != NSNotFound) return;
            NSInteger index = [self.textFields indexOfObjectIdenticalTo:tf];
            if (index == NSNotFound) return;
            
            //search for previous text field in enabled array
            NSUInteger indexToInsert = 0;
            for (NSInteger i = index - 1; i >= 0; --i) {
                NSUInteger previousIndex = [self.enabledTextFields indexOfObjectIdenticalTo:[self.textFields objectAtIndex:i]];
                if (previousIndex != NSNotFound) {
                    indexToInsert = previousIndex + 1;
                    break;
                }
            }
            //insert
            [self.enabledTextFields insertObject:tf atIndex:indexToInsert];
        } else {
            if (tf == self.currentTextField) [self closeKeyboard];
            [self.enabledTextFields removeObject:tf];
        }
        [self updateNavigationButtonsWithTextField:self.currentTextField];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currentTextField_ = nil;
    self.scrollView.scrollEnabled = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField_ = textField;
    [self performAnimatedShiftForTextField:textField];
    [self updateNavigationButtonsWithTextField:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.currentTextField == textField) {
        return NO;
    }
    if (![self.delegate respondsToSelector:@selector(maoKeyboardHelperCustomInputViewForTextField:)]) {
        [self closeLastCustomInputViewAnimated:YES];
        return YES;
    };
    UIView *civ = [self.delegate maoKeyboardHelperCustomInputViewForTextField:textField];
    if (!civ) {
        [self closeLastCustomInputViewAnimated:YES];
        return YES;
    }

    customInputViewContainer_ = nil;
    UIView *iav = [self.customInputViewContainer viewWithTag:beastNumber];
    iav.frame = (CGRect){
        CGPointZero, self.customInputViewContainer.width,
        [self.commonInputAccessoryView.class viewHeight]
    };
    civ.frame = (CGRect){
        0, [self.commonInputAccessoryView.class viewHeight],
        self.customInputViewContainer.width, keyboardHeight
    };
    [self.customInputViewContainer addSubview:civ];
    self.customInputViewContainer.origin =
    [self.scrollView.superview convertPoint:(CGPoint){0, UIScreen.mainScreen.bounds.size.height - self.customInputViewContainer.height}
                                   fromView:self.scrollView.window];
    [self.scrollView endEditing:YES];
    if (self.lastCustomInputView) {
        [self.scrollView.superview addSubview:self.customInputViewContainer];
    } else {
        [self.scrollView.superview addSubview:self.customInputViewContainer
                          withAnimationEffect:UIViewAnimationEffectFlyBottom
                                     duration:maoKeyboardHelperAnimationDuration];
    }
    [self closeLastCustomInputViewAnimated:NO];
    [self textFieldDidBeginEditing:textField];
    self.lastCustomInputView = self.customInputViewContainer;
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textFields.lastObject) {
        // This is the last textfield.
        [self closeKeyboard];
        if ([self.delegate respondsToSelector:@selector(maoKeyboardHelperDidCompleteLastTextField)]) {
            [self.delegate maoKeyboardHelperDidCompleteLastTextField];
        }
    }
    else {
        [self activateEnabledTextFieldWithIndex:[self.enabledTextFields indexOfObject:textField] + 1];
    }

    return NO;
}

@end
