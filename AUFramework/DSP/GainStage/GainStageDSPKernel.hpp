//
//  GainStageDSPKernel.hpp
//  GainStage
//
//  Created by Amelia Murphy on 6/21/22.
//

#ifndef GainStageDSPKernel_hpp
#define GainStageDSPKernel_hpp

#import "DSPKernel.hpp"

enum {
    gain = 0,
};

/*
 GainStageDSPKernel
 Performs simple copying of the input signal to the output.
 As a non-ObjC class, this is safe to use from render thread.
 */
class GainStageDSPKernel : public DSPKernel {
public:
    
    // MARK: Member Functions

    GainStageDSPKernel() {}

    void init(int channelCount, double inSampleRate) {
        chanCount = channelCount;
        sampleRate = float(inSampleRate);
    }

    void reset() {
    }

    bool isBypassed() {
        return bypassed;
    }

    void setBypass(bool shouldBypass) {
        bypassed = shouldBypass;
    }

    void setParameter(AUParameterAddress address, AUValue value) {
        switch (address) {
            case gain:
                gain_dB = value;
                break;
        }
    }

    AUValue getParameter(AUParameterAddress address) {
        switch (address) {
            case gain:
                // Return the goal. It is not thread safe to return the ramping value.
                return gain_dB;

            default: return 0.f;
        }
    }

    void setBuffers(AudioBufferList* inBufferList, AudioBufferList* outBufferList) {
        inBufferListPtr = inBufferList;
        outBufferListPtr = outBufferList;
    }

    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override {
        if (bypassed) {
            // Pass the samples through
            for (int channel = 0; channel < chanCount; ++channel) {
                if (inBufferListPtr->mBuffers[channel].mData ==  outBufferListPtr->mBuffers[channel].mData) {
                    continue;
                }
                
                for (int frameIndex = 0; frameIndex < frameCount; ++frameIndex) {
                    const int frameOffset = int(frameIndex + bufferOffset);
                    const float* in  = (float*)inBufferListPtr->mBuffers[channel].mData  + frameOffset;
                    float* out = (float*)outBufferListPtr->mBuffers[channel].mData + frameOffset;
                    *out = *in;
                }
            }
            return;
        }
        
        // Perform per sample dsp on the incoming float *in before assigning it to *out
        for (int channel = 0; channel < chanCount; ++channel) {
        
            // Get pointer to immutable input buffer and mutable output buffer
            const float* in = (float*)inBufferListPtr->mBuffers[channel].mData;
            float* out = (float*)outBufferListPtr->mBuffers[channel].mData;
            
            for (int frameIndex = 0; frameIndex < frameCount; ++frameIndex) {
                const int frameOffset = int(frameIndex + bufferOffset);
                
                // Do your sample by sample dsp here...
                out[frameOffset] = in[frameOffset] * gain_dB;
            }
        }
    }

    // MARK: Member Variables

private:
    int chanCount = 0;
    float sampleRate = 44100.0;
    bool bypassed = false;
    AudioBufferList* inBufferListPtr = nullptr;
    AudioBufferList* outBufferListPtr = nullptr;
    
    float gain_dB;
};

#endif /* GainStageDSPKernel_hpp */
