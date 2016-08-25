//
//  MenuModel.h
//  PopMenuTableView
//


#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *itemName;

+ (instancetype)MenuModelWithDict:(NSDictionary *)dict;

@end
