#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"org.sunnyplume.trail441";

/// The "LaunchTint" asset catalog color resource.
static NSString * const ACColorNameLaunchTint AC_SWIFT_PRIVATE = @"LaunchTint";

#undef AC_SWIFT_PRIVATE
