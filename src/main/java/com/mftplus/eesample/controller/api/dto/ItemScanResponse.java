package com.mftplus.eesample.controller.api.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ItemScanResponse {
    private Long surgeryCaseId;
    private String itemCode;   // GTIN یا IRC
    private String itemName;
    private int qty;           // مقدار همین اسکن
    private int totalQtyForItem; // مجموع این آیتم در این کیس
}
