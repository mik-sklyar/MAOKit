//  MAOKeyboardHelper.h
//
//  Copyright (c) 2011-2013 mik
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

#import <UIKit/UIKit.h>
#import "MAOInputAccessoryView.h"

static CGFloat const keyboardHeight = 216.f;

@protocol MAOKeyboardHelperDelegate <NSObject>
@optional

// "done" button has been touched
- (void)maoKeyboardHelperDidCompleteLastTextField;

- (UIView *)maoKeyboardHelperCustomInputViewForTextField:(UITextField *)textField;

@end


@interface MAOKeyboardHelper: NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id<MAOKeyboardHelperDelegate> delegate;

@property (nonatomic, strong) NSArray *textFields;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UITextField *currentTextField;

@property (nonatomic, assign) BOOL inputAccessoryViewHidden;

- (id)initWithScrollView:(UIScrollView *)view;
- (id)initWithScrollView:(UIScrollView *)view textFieldsArray:(NSArray *)textFields;

- (void)closeKeyboard;

// override it for replacing default inputAccessoryView of helper
- (UIView<MAOInputAccessoryViewProtocol> *)defaultInputAccessoryView;

@end
