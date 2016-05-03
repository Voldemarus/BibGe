//
//  DebugPrint.h
//  Portal Picture
//
//  Created by Водолазкий В.В. on 31.12.14.
//  Copyright (c) 2014 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#ifndef Portal_Picture_DebugPrint_h
#define Portal_Picture_DebugPrint_h

//
// See http://stackoverflow.com/questions/969130/how-to-print-out-the-method-name-and-line-number-and-conditionally-disable-NSLog
//

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// iphone only!!! --  UIAlert.
//#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
//#else
//#   define ULog(...)
//#endif

/**
 RStr - Resource String
 Provides localized string from default localization storage
 */
#define RStr(name) NSLocalizedString(name, name)


#endif

