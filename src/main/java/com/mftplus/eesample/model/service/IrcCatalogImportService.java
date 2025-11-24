package com.mftplus.eesample.model.service;

import com.mftplus.eesample.model.entity.IrcCatalogItem;
import jakarta.ejb.Stateless;
import jakarta.inject.Named;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.usermodel.Row.MissingCellPolicy;

import java.io.InputStream;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.text.DecimalFormatSymbols;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Stateless
@Named
public class IrcCatalogImportService {

    @PersistenceContext(unitName = "mft")
    private EntityManager em;

    public static class ImportResult {
        public int totalRows;
        public int inserted;
        public int updated;
        public List<String> messages = new ArrayList<>();
    }

    public ImportResult importXlsx(InputStream in, String sheetNameOpt) throws Exception {
        try (Workbook wb = WorkbookFactory.create(in)) {
            Sheet sheet = (sheetNameOpt != null && !sheetNameOpt.isBlank())
                    ? wb.getSheet(sheetNameOpt)
                    : wb.getNumberOfSheets() > 0 ? wb.getSheetAt(0) : null;

            if (sheet == null) throw new IllegalArgumentException("Sheet not found.");

            // Header row
            Row header = sheet.getRow(sheet.getFirstRowNum());
            if (header == null) throw new IllegalArgumentException("Header row is empty.");

            List<String> headers = new ArrayList<>();
            for (int c = header.getFirstCellNum(); c < header.getLastCellNum(); c++) {
                Cell cell = header.getCell(c, MissingCellPolicy.RETURN_BLANK_AS_NULL);
                headers.add(cell == null ? "" : cell.toString().trim());
            }

            // شناسایی ستون‌های کلیدی
            int idxIrc   = findIndex(headers, List.of("irc", "کد irc", "كد irc", "irc code", "آی آر سی"));
            int idxName  = findIndex(headers, List.of("name", "نام", "شرح", "title"));
            int idxPrice = findIndex(headers, List.of("price", "قیمت", "قيمت", "فی", "في", "fee", "cost", "amount"));

            ImportResult res = new ImportResult();

            // ساخت نقشهٔ header→field با همین نام‌سازی‌ای که در Entity استفاده کردی:
            Map<String, Field> headerToField = buildHeaderToFieldMap(headers, IrcCatalogItem.class);

            // Parse rows
            for (int r = sheet.getFirstRowNum() + 1; r <= sheet.getLastRowNum(); r++) {
                Row row = sheet.getRow(r);
                if (row == null) continue;

                res.totalRows++;

                String irc = readString(row, idxIrc);
                String nm  = readString(row, idxName);
                BigDecimal price = readPrice(row, idxPrice);

                if (irc == null || irc.isBlank()) {
                    res.messages.add("Row " + (r+1) + ": skipped (no IRC).");
                    continue;
                }

                // Upsert by IRC
                IrcCatalogItem item = findByIrcCode(irc);
                boolean isNew = false;
                if (item == null) {
                    item = new IrcCatalogItem();
                    isNew = true;
                }
                item.setIrcCode(irc);
                if (nm != null && !nm.isBlank()) item.setItemName(nm);
                if (price != null) item.setItemPrice(price);

                // ست‌کردن باقی ستون‌ها روی فیلدهای متناظر
                for (int c = 0; c < headers.size(); c++) {
                    String h = headers.get(c);
                    Field f = headerToField.get(h);
                    if (f == null) continue;

                    Class<?> type = f.getType();
                    Object val = (type == BigDecimal.class) ? readPrice(row, c) : readString(row, c);
                    try {
                        f.setAccessible(true);
                        f.set(item, val);
                    } catch (Exception e) {
                        res.messages.add("Row " + (r+1) + " col '" + h + "': " + e.getMessage());
                    }
                }

                if (isNew) {
                    em.persist(item);
                    res.inserted++;
                } else {
                    em.merge(item);
                    res.updated++;
                }
            }

            return res;
        }
    }

    private IrcCatalogItem findByIrcCode(String irc) {
        List<IrcCatalogItem> list = em
                .createQuery("select i from IrcCatalogItem i where i.ircCode = :x", IrcCatalogItem.class)
                .setParameter("x", irc)
                .setMaxResults(1)
                .getResultList();
        return list.isEmpty() ? null : list.get(0);
    }

    private static int findIndex(List<String> headers, List<String> needles) {
        List<String> low = headers.stream()
                .map(s -> s == null ? "" : s.toLowerCase(Locale.ROOT))
                .collect(Collectors.toList());
        for (int i = 0; i < low.size(); i++) {
            for (String n : needles) {
                if (low.get(i).contains(n.toLowerCase(Locale.ROOT))) return i;
            }
        }
        return -1;
    }

    private static String readString(Row row, int idx) {
        if (idx < 0) return null;
        Cell c = row.getCell(idx, MissingCellPolicy.RETURN_BLANK_AS_NULL);
        if (c == null) return null;
        c.setCellType(CellType.STRING);
        String s = c.getStringCellValue();
        if (s != null) s = s.trim();
        return (s == null || s.isBlank()) ? null : s;
    }

    private static BigDecimal readPrice(Row row, int idx) {
        if (idx < 0) return null;
        Cell c = row.getCell(idx, MissingCellPolicy.RETURN_BLANK_AS_NULL);
        if (c == null) return null;
        try {
            if (c.getCellType() == CellType.NUMERIC) {
                return BigDecimal.valueOf(c.getNumericCellValue());
            } else {
                String s = c.toString().trim();
                if (s.isBlank()) return null;
                // حذف , یا جداکنندهٔ هزارگان فارسی
                char grouping = DecimalFormatSymbols.getInstance().getGroupingSeparator();
                s = s.replace(String.valueOf(grouping), "").replace(",", "").replace("٬", "");
                return new BigDecimal(s);
            }
        } catch (Exception e) {
            return null;
        }
    }

    /** نگاشت هدر اکسل → فیلد Entity (با همان روشی که فیلدها را ساخته‌ای) */
    private static Map<String, Field> buildHeaderToFieldMap(List<String> headers, Class<?> entity) {
        Map<String, Field> map = new LinkedHashMap<>();
        // همان تابع camelCase که هنگام تولید فیلد استفاده شد:
        Function<String, String> toFieldName = (String col) -> {
            String s = col == null ? "" : col.trim();
            s = s.replace("\u200c", " ");
            s = s.replaceAll("[()\\[\\]\\-–—:/\\\\.,]", " ");
            String[] parts = s.trim().split("\\s+");
            String base = parts.length == 0 ? "col" : (parts[0].toLowerCase(Locale.ROOT) +
                    Arrays.stream(parts).skip(1).map(p -> p.substring(0,1).toUpperCase() + p.substring(1)).reduce("", String::concat));
            base = base.replaceAll("[^A-Za-z0-9_]", "");
            if (base.isEmpty() || Character.isDigit(base.charAt(0))) base = "f_" + (base.isEmpty() ? "col" : base);
            return base;
        };
        for (String h : headers) {
            String fn = toFieldName.apply(h);
            try {
                Field f = entity.getDeclaredField(fn);
                map.put(h, f);
            } catch (NoSuchFieldException ignored) {
                // اگر به خاطر یکتاسازی در تولید کلاس نام فرق کرده بود، می‌شود اینجا fallback نوشت
            }
        }
        return map;
    }
}
