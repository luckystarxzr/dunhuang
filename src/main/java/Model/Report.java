package Model;

import java.sql.Timestamp;

public class Report {
    private int reportId;
    private int newsId;
    private int commentId;
    private String reportedBy;
    private String reportReason;
    private Timestamp reportTime;

    public Report(int reportId, int newsId, int commentId, String reportedBy, String reportReason, Timestamp reportTime) {
        this.reportId = reportId;
        this.newsId = newsId;
        this.commentId = commentId;
        this.reportedBy = reportedBy;
        this.reportReason = reportReason;
        this.reportTime = reportTime;
    }

    // Getters and setters
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }
    public int getNewsId() { return newsId; }
    public void setNewsId(int newsId) { this.newsId = newsId; }
    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }
    public String getReportedBy() { return reportedBy; }
    public void setReportedBy(String reportedBy) { this.reportedBy = reportedBy; }
    public String getReportReason() { return reportReason; }
    public void setReportReason(String reportReason) { this.reportReason = reportReason; }
    public Timestamp getReportTime() { return reportTime; }
    public void setReportTime(Timestamp reportTime) { this.reportTime = reportTime; }
}
