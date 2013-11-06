//
//  MediaViewController.h
//  FORCE
//
//  Created by Nathan Reale on 11/2/13.
//  Copyright (c) 2013 Middle Tennessee State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MediaViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioSessionDelegate, AVAudioRecorderDelegate> {
    AVAudioRecorder *recorder;
    
    NSURL *temporaryRecFile;
    AVAudioPlayer *player;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;

- (IBAction)takePhoto:(id)sender;

@end
