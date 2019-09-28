//
//  KeyboardViewController.m

#import "KeyboardViewController.h"

@interface KeyboardViewController ()

@end

@implementation KeyboardViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _subscribeToKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self _unsubscribeFromKeyboardNotifications];
}

- (void)dealloc {
    [self _unsubscribeFromKeyboardNotifications];
}


#pragma mark - Private

- (void) _subscribeToKeyboardNotifications {
    [self _unsubscribeFromKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWilChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void) _unsubscribeFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

#pragma mark - Notifications

- (void) keyboardWillShow:(NSNotification*)note {
    
}

- (void) keyboardDidShow:(NSNotification*)note {
    
}

- (void) keyboardWillHide:(NSNotification*)note {
    
}

- (void) keyboardDidHide:(NSNotification*)note {
    
}

- (void) keyboardWilChangeFrame:(NSNotification*)note {
    
    const CGRect beginFrame = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    const CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardFrame = endFrame;
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect viewFrame = [self.view convertRect:self.view.bounds toView:nil];
    UIWindow *w = self.view.window;
    CGFloat maxHeight = w.bounds.size.height - viewFrame.origin.y;
    if (w && (viewFrame.size.height > maxHeight)) {
        viewFrame.size.height = maxHeight;
    }
    CGRect intersection = CGRectIntersection(endFrame, viewFrame);
    _keyboardIntersectionFrame = intersection;
    [self animateKeyboardChange:beginFrame endRect:endFrame intersection:intersection];
    
    [UIView commitAnimations];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)note {
    
}

- (void) animateKeyboardChange:(CGRect)beginFrame endRect:(CGRect)endFrame intersection:(CGRect)intersection {
    NSLog(@"keyboardWilChangeFrame: %@ to %@, intersect: %@", NSStringFromCGRect(beginFrame), NSStringFromCGRect(endFrame), NSStringFromCGRect(intersection));
}


@end


#pragma mark -


@implementation UIViewController (KeyboardViewController)

- (BOOL) startObserveKeyboardNotifications {
    
    BOOL success = NO;
    [self stopObserveKeybordNotifications];
    
    if ([self conformsToProtocol:@protocol(KeyboardProtocol)]) {
        
        if ([self respondsToSelector:@selector(keyboardWillShow:)]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            success = YES;
        }
        if ([self respondsToSelector:@selector(keyboardDidShow:)]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
            success = YES;
        }
        if ([self respondsToSelector:@selector(keyboardWillHide:)]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            success = YES;
        }
        if ([self respondsToSelector:@selector(keyboardDidHide:)]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
            success = YES;
        }
        if ([self respondsToSelector:@selector(keyboardWilChangeFrame:)]
            || [self respondsToSelector:@selector(animateKeyboardChange:endRect:intersection:)]) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWilChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
            success = YES;
        }
        if ([self respondsToSelector:@selector(keyboardDidChangeFrame:)]) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
            success = YES;
        }
    }
    
    return success;
}

- (void) stopObserveKeybordNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];

}

- (void) keyboardWilChangeFrame:(NSNotification*)note {
    
    const CGRect beginFrame = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    const CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect viewFrame = [self.view convertRect:self.view.bounds toView:nil];
    UIWindow *w = self.view.window;
    CGFloat maxHeight = w.bounds.size.height - viewFrame.origin.y;
    if (w && (viewFrame.size.height > maxHeight)) {
        viewFrame.size.height = maxHeight;
    }
    CGRect intersection = CGRectIntersection(endFrame, viewFrame);
    if ([self respondsToSelector:@selector(animateKeyboardChange:endRect:intersection:)]) {
        [self animateKeyboardChange:beginFrame endRect:endFrame intersection:intersection];
    }
    
    [UIView commitAnimations];
    
}

- (void) animateKeyboardChange:(CGRect)beginFrame endRect:(CGRect)endFrame intersection:(CGRect)intersection { }

@end
