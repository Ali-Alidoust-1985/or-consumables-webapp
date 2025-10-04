package com.mftplus.eesample.model.service.asr;

import com.mftplus.eesample.model.service.DictationService;

public class MockAsrGateway implements AsrGateway {
    @Override
    public void startSession(Long dictationId, String initialPrompt) { /* no-op */ }


    @Override
    public void sendPcmChunk(Long dictationId, byte[] pcm16le) {
    // به‌جای ASR واقعی، فقط «…» می‌افزاییم (partial)
        DictationService.get().addSegment(dictationId, "…", false, null, null);
    }

    @Override
    public void stopSession(Long dictationId) {
        DictationService.get().addSegment(dictationId, " [پایان جلسه] ", true, null, null);
    }
}
