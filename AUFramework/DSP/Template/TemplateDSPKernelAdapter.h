//
//  TemplateDSPKernelAdapter.h
//  Template
//
//  Created by Amelia Murphy on 6/21/22.
//

#import <AudioToolbox/AudioToolbox.h>

@class TemplateAudioUnitViewController;

NS_ASSUME_NONNULL_BEGIN

@interface TemplateDSPKernelAdapter : NSObject

@property (nonatomic) AUAudioFrameCount maximumFramesToRender;
@property (nonatomic, readonly) AUAudioUnitBus *inputBus;
@property (nonatomic, readonly) AUAudioUnitBus *outputBus;

- (void)setParameter:(AUParameter *)parameter value:(AUValue)value;
- (AUValue)valueForParameter:(AUParameter *)parameter;

- (void)allocateRenderResources;
- (void)deallocateRenderResources;
- (AUInternalRenderBlock)internalRenderBlock;

@end

NS_ASSUME_NONNULL_END
