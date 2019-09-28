//
//  KeyboardViewController.h


#import <UIKit/UIKit.h>

@interface KeyboardViewController : UIViewController

@property (nonatomic, readonly) CGRect keyboardFrame;
@property (nonatomic, readonly) CGRect keyboardIntersectionFrame;

- (void) keyboardWillShow:(NSNotification*)note;
- (void) keyboardDidShow:(NSNotification*)note;
- (void) keyboardWillHide:(NSNotification*)note;
- (void) keyboardDidHide:(NSNotification*)note;
- (void) keyboardWilChangeFrame:(NSNotification*)note;
- (void) keyboardDidChangeFrame:(NSNotification*)note;
- (void) animateKeyboardChange:(CGRect)beginFrame endRect:(CGRect)endFrame intersection:(CGRect)intersection;

@end


@protocol KeyboardProtocol <NSObject>

@optional
- (void) keyboardWillShow:(NSNotification*)note;
- (void) keyboardDidShow:(NSNotification*)note;
- (void) keyboardWillHide:(NSNotification*)note;
- (void) keyboardDidHide:(NSNotification*)note;
- (void) keyboardWilChangeFrame:(NSNotification*)note;
- (void) keyboardDidChangeFrame:(NSNotification*)note;
- (void) animateKeyboardChange:(CGRect)beginFrame endRect:(CGRect)endFrame intersection:(CGRect)intersection;

@end

@interface UIViewController (MLGKeyboardViewController)

- (BOOL) startObserveKeyboardNotifications;
- (void) stopObserveKeybordNotifications;

@end
