package ma.bibliotheque.unit;

import ma.bibliotheque.util.BiblioUtils;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

class BiblioUtilsTest {

    // ------------------------------------------------------------------ frais

    @Test
    void fraisSetJoursATarifCinq() {
        BigDecimal frais = BiblioUtils.calculerFrais(7, new BigDecimal("5.00"));
        assertEquals(new BigDecimal("35.00"), frais);
    }

    @Test
    void fraisUnJour() {
        assertEquals(new BigDecimal("3.50"),
                BiblioUtils.calculerFrais(1, new BigDecimal("3.50")));
    }

    @Test
    void fraisQuatorzeJoursATarifDecimal() {
        assertEquals(new BigDecimal("63.00"),
                BiblioUtils.calculerFrais(14, new BigDecimal("4.50")));
    }

    // --------------------------------------------------------------- penalite

    @Test
    void aucunePenaliteSiRetourAvantEcheance() {
        BigDecimal p = BiblioUtils.calculerPenalite(
                LocalDate.of(2026, 5, 10),
                LocalDate.of(2026, 5, 8),
                new BigDecimal("5.00"));
        assertEquals(BigDecimal.ZERO, p);
    }

    @Test
    void aucunePenaliteSiRetourJourJ() {
        LocalDate echeance = LocalDate.of(2026, 5, 10);
        assertEquals(BigDecimal.ZERO,
                BiblioUtils.calculerPenalite(echeance, echeance, new BigDecimal("5.00")));
    }

    @Test
    void penaliteDeuxJoursDeRetard() {
        BigDecimal p = BiblioUtils.calculerPenalite(
                LocalDate.of(2026, 5, 10),
                LocalDate.of(2026, 5, 12),
                new BigDecimal("5.00"));
        assertEquals(new BigDecimal("15.00"), p);  // 2 * 5.00 * 1.5
    }

    @Test
    void penaliteTroisJoursLesMillerables() {
        BigDecimal p = BiblioUtils.calculerPenalite(
                LocalDate.of(2026, 4, 19),
                LocalDate.of(2026, 4, 22),
                new BigDecimal("5.00"));
        assertEquals(new BigDecimal("22.50"), p);  // 3 * 5.00 * 1.5
    }

    @Test
    void penaliteArrondieDemiUnite() {
        BigDecimal p = BiblioUtils.calculerPenalite(
                LocalDate.of(2026, 5, 1),
                LocalDate.of(2026, 5, 2),
                new BigDecimal("3.50"));
        assertEquals(new BigDecimal("5.25"), p);  // 1 * 3.50 * 1.5
    }
}
