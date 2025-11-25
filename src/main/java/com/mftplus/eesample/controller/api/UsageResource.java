package com.mftplus.eesample.controller.api;

import com.mftplus.eesample.controller.api.dto.ErrorResponse;
import com.mftplus.eesample.controller.api.dto.MessageDTO;
import com.mftplus.eesample.model.service.OrScanService;
import jakarta.inject.Inject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/usage")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class UsageResource {

    // اسم attribute سشن که هنگام اسکن بیمار ست می‌کنیم
    public static final String ATTR_ACTIVE_CASE_ID = "OR_ACTIVE_CASE_ID";

    @Inject
    private OrScanService scanService;

    /**
     * نهایی کردن ثبت اقلام برای کیس فعالی که در سشن ذخیره شده
     * فرانت فقط یک POST ساده به /api/usage/finalize می‌زند.
     */
    @POST
    @Path("/finalize")
    public Response finalizeUsage(@Context HttpServletRequest req) {

        Long activeCaseId =
                (Long) req.getSession(true).getAttribute(ATTR_ACTIVE_CASE_ID);

        if (activeCaseId == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("بیمار/عمل فعالی انتخاب نشده است"))
                    .build();
        }

        try {
            scanService.finalizeCase(activeCaseId);
            return Response.ok(
                    new MessageDTO("ثبت نهایی اقلام برای این عمل انجام شد")
            ).build();
        } catch (IllegalArgumentException ex) {
            // مثلاً اگر finalizeCase گفت کیس پیدا نشد
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse(ex.getMessage()))
                    .build();
        } catch (Exception ex) {
            // هر خطای غیرمنتظره
            ex.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("خطای داخلی در نهایی‌سازی ثبت اقلام"))
                    .build();
        }
    }
}
