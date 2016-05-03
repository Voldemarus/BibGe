//
//  CommonHeader.h
//  Gospel
//
//  Created by AAA_Develooper on 19/04/16.
//  Copyright © 2016 Aron. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h

#define RED_COLOR [UIColor colorWithRed:214.0/255.0 green:64.0/255.0 blue:79.0/255.0 alpha:1.0]
#define BLACK_COLOR [UIColor blackColor]
#define BLUE_COLOR [UIColor colorWithRed:19.0/255.0 green:141.0/255.0 blue:255.0/255.0 alpha:1.0]



#define GETVALUE(key)   [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define GETBOOL(key)   [[NSUserDefaults standardUserDefaults] boolForKey:key]

#define UPDATE_DEFAULTS(key,value){\
[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define UPDATE_DEFAULTS_BOOL(key,value){\
[[NSUserDefaults standardUserDefaults] setBool:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}


#import "ListTableViewCell.h"

#endif /* CommonHeader_h */
