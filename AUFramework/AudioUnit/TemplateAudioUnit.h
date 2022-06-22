//
//  TemplateAudioUnit.h
//  Template
//
//  Created by Amelia Murphy on 6/21/22.
//

#import <AudioToolbox/AudioToolbox.h>
#import "TemplateDSPKernelAdapter.h"

// Define parameter addresses.
extern const AudioUnitParameterID myParam1;

@interface TemplateAudioUnit : AUAudioUnit

@property (nonatomic, readonly) TemplateDSPKernelAdapter *kernelAdapter;
- (void)setupAudioBuses;
- (void)setupParameterTree;
- (void)setupParameterCallbacks;
@end
