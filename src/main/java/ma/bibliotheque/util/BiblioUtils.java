package ma.bibliotheque.util;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public final class BiblioUtils {

    private BiblioUtils() {}

    public static BigDecimal calculerFrais(int dureeJours, BigDecimal tarifJournalier) {
        return tarifJournalier.multiply(BigDecimal.valueOf(dureeJours));
    }

    public static BigDecimal calculerPenalite(LocalDate dateFinPrevue,
                                               LocalDate dateFinReelle,
                                               BigDecimal tarifJournalier) {
        long joursExces = ChronoUnit.DAYS.between(dateFinPrevue, dateFinReelle);
        if (joursExces <= 0) return BigDecimal.ZERO;
        return tarifJournalier
                .multiply(BigDecimal.valueOf(joursExces))
                .multiply(new BigDecimal("1.5"))
                .setScale(2, java.math.RoundingMode.HALF_UP);
    }
}
