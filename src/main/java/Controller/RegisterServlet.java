package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/register") // 映射路径为 /register
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置响应内容类型为 JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 获取请求中的用户名和密码
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 简单验证（实际项目中应进行更严格的验证和密码加密）
        boolean registrationSuccess = false;
        if (username != null && !username.isEmpty() && password != null && !password.isEmpty()) {

            registrationSuccess = true; // 假设注册成功
        }

        // 返回 JSON 格式的响应
        PrintWriter out = response.getWriter();
        if (registrationSuccess) {
            response.getWriter().println("注册成功");
        } else {
            response.getWriter().println("注册失败");
        }
        out.flush();
    }
}
