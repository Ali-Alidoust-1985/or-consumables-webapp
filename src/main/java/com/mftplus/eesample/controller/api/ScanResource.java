package com.mftplus.eesample.controller.api;

import com.mftplus.eesample.controller.api.dto.ErrorResponse;
import com.mftplus.eesample.controller.api.dto.ItemScanResponse;
import com.mftplus.eesample.controller.api.dto.PatientScanResponse;
import com.mftplus.eesample.controller.api.dto.ScanRequest;
import com.mftplus.eesample.model.service.OrScanService;
import jakarta.inject.Inject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/scans")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class ScanResource {

    @Inject
    private OrScanService scanService;

    @Context
    private HttpServletRequest request;

    // ترجیحاً این را با UsageResource یکی کن (همان مقدار است):
    public static final String ATTR_ACTIVE_CASE_ID = "ACTIVE_SURGERY_CASE_ID";

    // --- اسکن مچ‌بند بیمار
    @POST
    @Path("/patient")
    public Response scanPatient(ScanRequest req) {
        if (req == null || req.getCode() == null || req.getCode().isBlank()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("کد مچ‌بند خالی است"))
                    .build();
        }

        try {
            PatientScanResponse result =
                    scanService.handlePatientScan(req.getCode().trim());

            // اگر کیس فعالی پیدا شد، id آن را در سشن ذخیره کن
            if (result.getSurgeryCaseId() != null) { // اینجا به‌جای getEncounterId
                request.getSession(true)
                        .setAttribute(ATTR_ACTIVE_CASE_ID,
                                result.getSurgeryCaseId());
            }

            return Response.ok(result).build();

        } catch (OrScanService.PatientNotFoundException e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("بیماری با این مچ‌بند پیدا نشد"))
                    .build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("خطای غیرمنتظره در اسکن مچ‌بند"))
                    .build();
        }
    }

    // --- اسکن کالای مصرفی
    @POST
    @Path("/item")
    public Response scanItem(ScanRequest req) {
        if (req == null || req.getCode() == null || req.getCode().isBlank()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("کد کالا خالی است"))
                    .build();
        }

        Long activeCaseId =
                (Long) request.getSession(true).getAttribute(ATTR_ACTIVE_CASE_ID);

        if (activeCaseId == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("ابتدا مچ‌بند بیمار را اسکن کنید"))
                    .build();
        }

        try {
            ItemScanResponse result =
                    scanService.handleItemScan(activeCaseId, req.getCode().trim());

            return Response.ok(result).build();

        } catch (OrScanService.ItemNotFoundException e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("کالا در کاتالوگ پیدا نشد"))
                    .build();
        } catch (OrScanService.CaseNotFoundException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("caseId ذخیره‌شده در سشن نامعتبر است"))
                    .build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("خطای غیرمنتظره در اسکن کالا"))
                    .build();
        }
    }
}
