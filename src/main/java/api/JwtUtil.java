package api;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;

public class JwtUtil {

    private static final String SECRET = "SmartEduSecretKey2024SmartEduSecretKey2024";
    private static final long EXPIRATION = 86400000;
    private static final Key KEY = Keys.hmacShaKeyFor(SECRET.getBytes());

    public static String generate(String username, String role) {
        return Jwts.builder()
                .setSubject(username)
                .claim("role", role)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION))
                .signWith(KEY)
                .compact();
    }

    public static Claims validate(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(KEY)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            return null;
        }
    }

    public static String getUsername(String token) {
        Claims claims = validate(token);
        return claims != null ? claims.getSubject() : null;
    }

    public static String getRole(String token) {
        Claims claims = validate(token);
        return claims != null ? (String) claims.get("role") : null;
    }
}