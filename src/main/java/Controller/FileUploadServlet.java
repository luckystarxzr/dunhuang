package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet(name = "FileUploadServlet", value = {"/file-upload"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 10, // 10 MB
        maxFileSize = 1024 * 1024 * 500,      // 500 MB
        maxRequestSize = 1024 * 1024 * 1000   // 1 GB
)
public class FileUploadServlet extends HttpServlet {

    private String getFilename(Part part) {
        // 从 content-disposition 中提取文件名
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String token : contentDisposition.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 文件上传路径
        String uploadPath = "C:\\Users\\lucky\\Desktop\\web\\src\\main\\web\\news";
        File uploadDir = new File(uploadPath);

        // 如果上传目录不存在，则创建
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 获取文件字段的 Part 对象
        Part part = request.getPart("fileName");

        // 验证 Part 是否存在
        if (part == null || part.getSize() == 0) {
            request.setAttribute("errorMessage", "未选择文件或文件为空！");
            request.getRequestDispatcher("addNews.jsp").forward(request, response);
            return;
        }

        // 验证文件大小
        if (part.getSize() > 1024 * 1024 * 100) { // 超过 100 MB
            request.setAttribute("errorMessage", "文件太大，不能上传！");
            request.getRequestDispatcher("addNews.jsp").forward(request, response);
            return;
        }

        // 获取文件名并验证
        String filename = getFilename(part);
        if (filename == null || filename.isEmpty()) {
            request.setAttribute("errorMessage", "文件名未找到！");
            request.getRequestDispatcher("addNews.jsp").forward(request, response);
            return;
        }

        // 安全处理文件名（去除非法字符）
        filename = filename.replaceAll("[^a-zA-Z0-9\\.\\-_]", "");

        try {
            // 保存文件
            part.write(uploadDir + File.separator + filename);
            request.setAttribute("successMessage", "文件上传成功！");
        } catch (IOException e) {
            request.setAttribute("errorMessage", "文件上传失败：" + e.getMessage());
        }

        // 转发到 JSP 页面显示结果
        request.getRequestDispatcher("addNews.jsp").forward(request, response);
    }
}
