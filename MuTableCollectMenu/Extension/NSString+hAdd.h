//
//  NSString+hAdd.h
//  MultilevelMenu
//
//  Created by Kingson on 2020/12/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (hAdd)

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

@end

NS_ASSUME_NONNULL_END
