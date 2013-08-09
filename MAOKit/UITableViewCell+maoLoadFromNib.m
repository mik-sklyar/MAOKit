//  UITableViewCell+maoLoadFromNib.m
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

#import "UITableViewCell+maoLoadFromNib.h"

@implementation UITableViewCell (maoLoadFromNib)

+ (UITableViewCell *)loadFromNibNamed:(NSString *)nibName
{
  //dictionary needs if we wants to load cells from several nibs
  static __strong NSMutableDictionary * nibObjects = nil;
  if (!nibObjects) nibObjects = [NSMutableDictionary dictionary];
  
  //get nibObject from dictionary or init with filename
  NSString *fileName = (nibName.length) ? nibName : NSStringFromClass(self.class);
  UINib *nibObject = [nibObjects objectForKey:fileName];
  if (!nibObject) {
    nibObject = [UINib nibWithNibName:fileName bundle:[NSBundle mainBundle]];
    if (!nibObject) return nil;
    [nibObjects setObject:nibObject forKey:fileName];
  }
  
  //create cell
  __block UITableViewCell *cell = nil;
  NSArray *nibContent = [nibObject instantiateWithOwner:nil options:nil];
  [nibContent enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:
   ^(id obj, NSUInteger idx, BOOL *stop) {
     if ([self isSubclassOfClass:[obj class]]) {
       cell = obj;
       *stop = YES;
     }
   }];
  return cell;
}

+ (UITableViewCell *)reusableCellFromNibNamed:(NSString *)nibName
                                    tableView:(UITableView *)tableView
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
  if (!cell) cell = [self loadFromNibNamed:nibName];
  return cell;
}

@end
