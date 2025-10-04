package com.mftplus.eesample.model.service.asr;


public interface AsrGateway {
    void startSession(Long dictationId, String initialPrompt);
    void sendPcmChunk(Long dictationId, byte[] pcm16le);
    void stopSession(Long dictationId);
}
