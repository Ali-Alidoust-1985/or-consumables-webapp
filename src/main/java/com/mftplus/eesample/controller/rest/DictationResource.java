package com.mftplus.eesample.controller.rest;



import com.mftplus.eesample.model.entity.Dictation;
import com.mftplus.eesample.model.entity.TranscriptSegment;
import com.mftplus.eesample.model.service.DictationService;
import com.mftplus.eesample.model.service.asr.AsrGateway;
import com.mftplus.eesample.model.service.asr.MockAsrGateway;


import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;


@Path("/dictations")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class DictationResource {


    private static final AsrGateway ASR = new MockAsrGateway();


    public static class StartDictationRequest {
        public String departmentCode;
        public String language; // "fa"
        public String modelHint; // optional
        public String initialPrompt; // optional
    }
    public static class DictationResponse { public Long id; public String status; }
    public static class AppendTextRequest { public String text; public boolean finalize; }


    @POST
    public Response start(StartDictationRequest req, @HeaderParam("X-User") String user) {
        Dictation d = DictationService.get().start(user, req.departmentCode, req.language, req.modelHint);
        ASR.startSession(d.getId(), req.initialPrompt);
        DictationResponse dto = new DictationResponse();
        dto.id = d.getId(); dto.status = d.getStatus().name();
        return Response.ok(dto).build();
    }


    @GET @Path("/{id}/segments")
    public List<TranscriptSegment> segments(@PathParam("id") Long id) {
        return DictationService.get().segments(id);
    }


    @POST @Path("/{id}/finalize")
    public Response finalize(@PathParam("id") Long id, AppendTextRequest req) {
        Dictation d = DictationService.get().finalizeText(id, req.text);
        DictationResponse dto = new DictationResponse();
        dto.id = d.getId(); dto.status = d.getStatus().name();
        return Response.ok(dto).build();
    }
}
