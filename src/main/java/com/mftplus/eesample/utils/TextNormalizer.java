package com.mftplus.eesample.utils;

public final class TextNormalizer {
    private TextNormalizer() {}

    /** Trim + تبدیل ي/ك به ی/ک + حذف نیم‌فاصله + یکی‌کردن فاصله‌ها. خالی=>null */
    public static String norm(String s) {
        if (s == null) return null;
        String t = s.trim();
        if (t.isEmpty()) return null;
        t = t.replace('\u200c',' ')   // ZWNJ → space
                .replace('\u200f',' ')   // RTL mark
                .replace('ي','ی')        // Yeh Arabic → Persian
                .replace('ك','ک');       // Kaf Arabic → Persian
        t = t.replaceAll("\\s+"," "); // collapse spaces
        return t;
    }
}
