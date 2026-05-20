package ma.bibliotheque.unit;

import ma.bibliotheque.util.PasswordUtil;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class PasswordUtilTest {

    @Test
    void memeMotDePasseProduiteMemHash() {
        assertEquals(PasswordUtil.hash("Admin@123"), PasswordUtil.hash("Admin@123"));
    }

    @Test
    void hashFaitSoixanteQuatreCaracteres() {
        assertEquals(64, PasswordUtil.hash("quelconque").length());
    }

    @Test
    void hashContientUniquementHexadecimal() {
        assertTrue(PasswordUtil.hash("test").matches("[0-9a-f]+"));
    }

    @Test
    void verificationMotDePasseCorrect() {
        String hash = PasswordUtil.hash("secret42");
        assertTrue(PasswordUtil.verify("secret42", hash));
    }

    @Test
    void verificationMotDePasseIncorrect() {
        String hash = PasswordUtil.hash("correct");
        assertFalse(PasswordUtil.verify("mauvais", hash));
    }

    @Test
    void hashDifferentSelonCasse() {
        assertNotEquals(PasswordUtil.hash("Admin"), PasswordUtil.hash("admin"));
    }

    @Test
    void hashAdminParDefaut() {
        String expected = "e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7";
        assertEquals(expected, PasswordUtil.hash("Admin@123"));
    }
}
