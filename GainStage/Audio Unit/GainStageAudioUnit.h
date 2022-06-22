//
//  GainStageAudioUnit.h
//  GainStage
//
//  Created by Amelia Murphy on 6/21/22.
//

#import <AudioToolbox/AudioToolbox.h>
#import "GainStageDSPKernelAdapter.h"

// Define parameter addresses.
extern const AudioUnitParameterID myParam1;

@interface GainStageAudioUnit : AUAudioUnit

@property (nonatomic, readonly) GainStageDSPKernelAdapter *kernelAdapter;
- (void)setupAudioBuses;
- (void)setupParameterTree;
- (void)setupParameterCallbacks;
@end
