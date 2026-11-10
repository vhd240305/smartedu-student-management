package api;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@WebFilter(filterName = "RateLimitFilter", urlPatterns = "/api/*")
public class RateLimitFilter implements Filter {

    private static final Gson gson = new Gson();
    private static final int MAX_REQUESTS = 60; // tối đa 60 request
    private static final long TIME_WINDOW = 60000; // mỗi 60 giây

    // Lưu số request theo IP
    private static final Map<String, RequestCount> requestMap = new ConcurrentHashMap<>();

    static class RequestCount {
        AtomicInteger count = new AtomicInteger(0);
        long startTime = System.currentTimeMillis();

        void reset() {
            count.set(0);
            startTime = System.currentTimeMillis();
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String ip = getClientIp(req);

        requestMap.putIfAbsent(ip, new RequestCount());
        RequestCount rc = requestMap.get(ip);

        long now = System.currentTimeMillis();

        // Reset nếu đã qua time window
        if (now - rc.startTime > TIME_WINDOW) {
            rc.reset();
        }

        int count = rc.count.incrementAndGet();

        // Thêm header thông tin rate limit
        res.setHeader("X-RateLimit-Limit", String.valueOf(MAX_REQUESTS));
        res.setHeader("X-RateLimit-Remaining", String.valueOf(Math.max(0, MAX_REQUESTS - count)));
        res.setHeader("X-RateLimit-Reset", String.valueOf(rc.startTime + TIME_WINDOW));

        if (count > MAX_REQUESTS) {
            res.setStatus(429);
            res.setContentType("application/json");
            res.setCharacterEncoding("UTF-8");
            res.getWriter().write(gson.toJson(
                new ApiResponse(429, "Quá nhiều request. Vui lòng thử lại sau 1 phút.", null)));
            return;
        }

        chain.doFilter(request, response);
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty()) {
            ip = request.getRemoteAddr();
        }
        // Lấy IP đầu tiên nếu có nhiều
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}