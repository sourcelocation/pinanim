#import "UIKit/UIKit.h"
#import <SpringBoard/SpringBoard.h>
#include <RemoteLog.h>

@interface SBUIPasscodeLockViewSimpleFixedDigitKeypad : UIView {

}
-(unsigned long long)numberOfDigits;
@end

@interface CSPasscodeViewController : UIViewController {

}
@end

@interface SBUISimpleFixedDigitPasscodeEntryField : UIView {
    double  _backgroundAlpha;
    NSMutableArray * _characterIndicators;
    UIView * _characterIndicatorsContainerView;
    UIView * _leftPaddingView;
    UIView * _rightPaddingView;
    UIView * _springView;
    UIView * _springViewParent;
}
@end


@interface SBSimplePasscodeEntryFieldButton : UIView {
    BOOL _revealed; 
}
-(void)animate:(BOOL)deletion;
@end
