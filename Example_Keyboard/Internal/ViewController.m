
#import "ViewController.h"
#import "MAOKeyboardHelper.h"

@interface ViewController () <MAOKeyboardHelperDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *formScrollView;
@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;
@property (nonatomic, strong) IBOutletCollection(UISwitch) NSArray *switches;

@property (nonatomic, strong) MAOKeyboardHelper *keyboardHelper;

@end

@implementation ViewController

- (void)viewWillUnload
{
    [super viewWillUnload];
    self.keyboardHelper = nil;
    self.textFields = nil;
    self.switches = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.keyboardHelper =
    [[MAOKeyboardHelper alloc] initWithScrollView:self.formScrollView
                                  textFieldsArray:self.textFields];
    self.keyboardHelper.delegate = self;
}

- (IBAction)switchDidChanged:(UISwitch *)sender
{
    int index = [self.switches indexOfObject:sender];
    [[self.textFields objectAtIndex:index] setEnabled:sender.on];
}


const int dateIndex = 2;

- (void)datePickerDidChanged:(UIDatePicker *)picker
{
    [[self.textFields objectAtIndex:dateIndex] setText:picker.date.description];
}

#pragma mark - MAOKeyboardHelperDelegate

- (UIView *)maoKeyboardHelperCustomInputViewForTextField:(UITextField *)textField
{
    int index = [self.textFields indexOfObject:textField];
    if (index != dateIndex) return nil;

    static UIDatePicker *pv = nil;
    if (!pv) {
        pv = [[UIDatePicker alloc] init];
        [pv addTarget:self
               action:@selector(datePickerDidChanged:)
     forControlEvents:UIControlEventValueChanged];
    }
    return pv;
}

- (void)maoKeyboardHelperDidCompleteLastTextField
{
    [[[UIAlertView alloc] initWithTitle:@"Alert"
                                message:@"Done!"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
