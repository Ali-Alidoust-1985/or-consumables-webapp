package com.mftplus.eesample.model.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "IRC_CATALOG", indexes = @Index(name = "IX_IRC_CODE", columnList = "IRC_CODE"))
public class IrcCatalogItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "IRC_CODE", length = 128)
    private String ircCode; // normalized from: كد IRC
    @Column(name = "ITEM_NAME", length = 512)
    private String itemName; // normalized from: نام
    @Column(name = "ITEM_PRICE")
    private BigDecimal itemPrice; // normalized from: قيمت
    @Column(name = "ردیف")
    private BigDecimal f_col; // original header: ردیف
    @Column(name = "نام", length = 1000)
    private String f_col_2; // original header: نام
    @Column(name = "نام_لاتين", length = 1000)
    private String f_col_3; // original header: نام لاتين
    @Column(name = "فعال")
    private BigDecimal f_col_4; // original header: فعال
    @Column(name = "نام_تجاري", length = 1000)
    private String f_col_5; // original header: نام تجاري
    @Column(name = "كد")
    private BigDecimal f_col_6; // original header: كد
    @Column(name = "قيمت")
    private BigDecimal f_col_7; // original header: قيمت
    @Column(name = "ارز_ترجيحي")
    private BigDecimal f_col_8; // original header: ارز ترجيحي
    @Column(name = "واحد_فروش", length = 1000)
    private String f_col_9; // original header: واحد(فروش)
    @Column(name = "قلم_هتلينگ")
    private BigDecimal f_col_10; // original header: قلم هتلينگ
    @Column(name = "گروه_بندي", length = 1000)
    private String f_col_11; // original header: گروه‌بندي
    @Column(name = "دسته_بندي", length = 1000)
    private String f_col_12; // original header: دسته‌بندي
    @Column(name = "حق_فني")
    private BigDecimal f_col_13; // original header: حق‌فني
    @Column(name = "باركد")
    private BigDecimal f_col_14; // original header: باركد
    @Column(name = "كد_ژنريك")
    private BigDecimal f_col_15; // original header: كد ژنريك
    @Column(name = "كد_IRC")
    private BigDecimal Irc; // original header: كد IRC
    @Column(name = "كد_اختصاصي_بيمارستان")
    private BigDecimal f_col_16; // original header: كد اختصاصي بيمارستان
    @Column(name = "شكل_دارو_لوازم", length = 1000)
    private String f_col_17; // original header: شكل دارو/لوازم
    @Column(name = "تاريخ_انقضا_ندارد")
    private BigDecimal f_col_18; // original header: تاريخ انقضا ندارد
    @Column(name = "حداقل_فاصله_زماني_تكرار_بر_حسب_ساعت")
    private BigDecimal f_col_19; // original header: حداقل فاصله زماني تكرار بر حسب ساعت
    @Column(name = "اعمال_محدوديت_بيمه_اي")
    private BigDecimal f_col_20; // original header: اعمال محدوديت بيمه اي
    @Column(name = "وضعيت_گلوبال", length = 1000)
    private String f_col_21; // original header: وضعيت گلوبال
    @Column(name = "مصرف_عمومي")
    private BigDecimal f_col_22; // original header: مصرف عمومي
    @Column(name = "داروي_تركيبي")
    private BigDecimal f_col_23; // original header: داروي تركيبي
    @Column(name = "دسته_بندي_طرح_سلامت", length = 1000)
    private String f_col_24; // original header: دسته بندي طرح سلامت
    @Column(name = "يخچالي")
    private BigDecimal f_col_25; // original header: يخچالي
    @Column(name = "گران_قيمت")
    private BigDecimal f_col_26; // original header: گران قيمت
    @Column(name = "پرخطر")
    private BigDecimal f_col_27; // original header: پرخطر
    @Column(name = "نحوه_مصرف")
    private BigDecimal f_col_28; // original header: نحوه مصرف
    @Column(name = "نيازمند_تاييد_اصالت_دارو")
    private BigDecimal f_col_29; // original header: نيازمند تاييد اصالت دارو
    @Column(name = "كشور_سازنده", length = 1000)
    private String f_col_30; // original header: كشور سازنده
    @Column(name = "كد_ايندكس")
    private BigDecimal f_col_31; // original header: كد ايندكس

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getIrcCode() { return ircCode; }
    public void setIrcCode(String ircCode) { this.ircCode = ircCode; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public BigDecimal getItemPrice() { return itemPrice; }
    public void setItemPrice(BigDecimal itemPrice) { this.itemPrice = itemPrice; }
    public BigDecimal getF_col() { return f_col; }
    public void setF_col(BigDecimal f_col) { this.f_col = f_col; }
    public String getF_col_2() { return f_col_2; }
    public void setF_col_2(String f_col_2) { this.f_col_2 = f_col_2; }
    public String getF_col_3() { return f_col_3; }
    public void setF_col_3(String f_col_3) { this.f_col_3 = f_col_3; }
    public BigDecimal getF_col_4() { return f_col_4; }
    public void setF_col_4(BigDecimal f_col_4) { this.f_col_4 = f_col_4; }
    public String getF_col_5() { return f_col_5; }
    public void setF_col_5(String f_col_5) { this.f_col_5 = f_col_5; }
    public BigDecimal getF_col_6() { return f_col_6; }
    public void setF_col_6(BigDecimal f_col_6) { this.f_col_6 = f_col_6; }
    public BigDecimal getF_col_7() { return f_col_7; }
    public void setF_col_7(BigDecimal f_col_7) { this.f_col_7 = f_col_7; }
    public BigDecimal getF_col_8() { return f_col_8; }
    public void setF_col_8(BigDecimal f_col_8) { this.f_col_8 = f_col_8; }
    public String getF_col_9() { return f_col_9; }
    public void setF_col_9(String f_col_9) { this.f_col_9 = f_col_9; }
    public BigDecimal getF_col_10() { return f_col_10; }
    public void setF_col_10(BigDecimal f_col_10) { this.f_col_10 = f_col_10; }
    public String getF_col_11() { return f_col_11; }
    public void setF_col_11(String f_col_11) { this.f_col_11 = f_col_11; }
    public String getF_col_12() { return f_col_12; }
    public void setF_col_12(String f_col_12) { this.f_col_12 = f_col_12; }
    public BigDecimal getF_col_13() { return f_col_13; }
    public void setF_col_13(BigDecimal f_col_13) { this.f_col_13 = f_col_13; }
    public BigDecimal getF_col_14() { return f_col_14; }
    public void setF_col_14(BigDecimal f_col_14) { this.f_col_14 = f_col_14; }
    public BigDecimal getF_col_15() { return f_col_15; }
    public void setF_col_15(BigDecimal f_col_15) { this.f_col_15 = f_col_15; }
    public BigDecimal getIrc() { return Irc; }
    public void setIrc(BigDecimal Irc) { this.Irc = Irc; }
    public BigDecimal getF_col_16() { return f_col_16; }
    public void setF_col_16(BigDecimal f_col_16) { this.f_col_16 = f_col_16; }
    public String getF_col_17() { return f_col_17; }
    public void setF_col_17(String f_col_17) { this.f_col_17 = f_col_17; }
    public BigDecimal getF_col_18() { return f_col_18; }
    public void setF_col_18(BigDecimal f_col_18) { this.f_col_18 = f_col_18; }
    public BigDecimal getF_col_19() { return f_col_19; }
    public void setF_col_19(BigDecimal f_col_19) { this.f_col_19 = f_col_19; }
    public BigDecimal getF_col_20() { return f_col_20; }
    public void setF_col_20(BigDecimal f_col_20) { this.f_col_20 = f_col_20; }
    public String getF_col_21() { return f_col_21; }
    public void setF_col_21(String f_col_21) { this.f_col_21 = f_col_21; }
    public BigDecimal getF_col_22() { return f_col_22; }
    public void setF_col_22(BigDecimal f_col_22) { this.f_col_22 = f_col_22; }
    public BigDecimal getF_col_23() { return f_col_23; }
    public void setF_col_23(BigDecimal f_col_23) { this.f_col_23 = f_col_23; }
    public String getF_col_24() { return f_col_24; }
    public void setF_col_24(String f_col_24) { this.f_col_24 = f_col_24; }
    public BigDecimal getF_col_25() { return f_col_25; }
    public void setF_col_25(BigDecimal f_col_25) { this.f_col_25 = f_col_25; }
    public BigDecimal getF_col_26() { return f_col_26; }
    public void setF_col_26(BigDecimal f_col_26) { this.f_col_26 = f_col_26; }
    public BigDecimal getF_col_27() { return f_col_27; }
    public void setF_col_27(BigDecimal f_col_27) { this.f_col_27 = f_col_27; }
    public BigDecimal getF_col_28() { return f_col_28; }
    public void setF_col_28(BigDecimal f_col_28) { this.f_col_28 = f_col_28; }
    public BigDecimal getF_col_29() { return f_col_29; }
    public void setF_col_29(BigDecimal f_col_29) { this.f_col_29 = f_col_29; }
    public String getF_col_30() { return f_col_30; }
    public void setF_col_30(String f_col_30) { this.f_col_30 = f_col_30; }
    public BigDecimal getF_col_31() { return f_col_31; }
    public void setF_col_31(BigDecimal f_col_31) { this.f_col_31 = f_col_31; }
}
