<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>新闻管理系统</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* 基础样式 */
        body { 
            font-family: Arial, sans-serif; 
            background-color: #f4f4f4; 
            margin: 0; 
            padding: 20px; 
        }
        
        /* 表格样式 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        
        th {
            background-color: #4CAF50;
            color: white;
        }
        
        /* 按钮样式 */
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 0 5px;
        }
        
        .btn-add {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-edit {
            background-color: #2196F3;
            color: white;
        }
        
        .btn-delete {
            background-color: #f44336;
            color: white;
        }
        
        /* 模态框样式 */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 20px;
            width: 50%;
            border-radius: 5px;
            position: relative;
        }
        
        .close {
            position: absolute;
            right: 10px;
            top: 5px;
            font-size: 24px;
            cursor: pointer;
        }
        
        /* 表单样式 */
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        /* 头部按钮容器 */
        .header-actions {
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="header-actions">
        <button class="btn btn-add" onclick="showAddModal()">添加新闻</button>
    </div>

    <!-- 新闻列表 -->
    <table>
        <thead>
            <tr>
                <th>编号</th>
                <th>标题</th>
                <th>作者</th>
                <th>内容</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody id="newsTableBody">
        </tbody>
    </table>

    <!-- 添加/编辑新闻的模态框 -->
    <div id="newsModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2 id="modalTitle">添加新闻</h2>
            <form id="newsForm">
                <input type="hidden" id="newsId" name="id">
                <div class="form-group">
                    <label for="title">标题:</label>
                    <input type="text" id="title" name="title" required>
                </div>
                <div class="form-group">
                    <label for="author">作者:</label>
                    <input type="text" id="author" name="author" required>
                </div>
                <div class="form-group">
                    <label for="content">内容:</label>
                    <textarea id="content" name="content" rows="4" required></textarea>
                </div>
                <div class="form-group">
                    <label for="fileName">图片/视频:</label>
                    <input type="file" id="fileName" name="fileName">
                </div>
                <button type="submit" class="btn btn-add">提交</button>
            </form>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            loadNewsList();
            
            // 表单提交处理
            $('#newsForm').on('submit', function(e) {
                e.preventDefault();
                const isEdit = $('#newsId').val() !== '';
                submitNews(isEdit);
            });
        });

        function loadNewsList() {
            $.ajax({
                url: 'ListNewsServlet',
                type: 'GET',
                success: function(data) {
                    const tbody = $('#newsTableBody');
                    tbody.empty();
                    
                    data.forEach(function(news) {
                        const row = `
                            <tr>
                                <td>${news.id}</td>
                                <td>${news.title}</td>
                                <td>${news.author}</td>
                                <td>${news.content}</td>
                                <td>
                                    <button class="btn btn-edit" onclick="showEditModal(${news.id})">修改</button>
                                    <button class="btn btn-delete" onclick="deleteNews(${news.id})">删除</button>
                                </td>
                            </tr>
                        `;
                        tbody.append(row);
                    });
                },
                error: function(xhr, status, error) {
                    alert('加载新闻列表失败: ' + error);
                }
            });
        }

        function showAddModal() {
            $('#modalTitle').text('添加新闻');
            $('#newsForm')[0].reset();
            $('#newsId').val('');
            $('#newsModal').show();
        }

        function showEditModal(newsId) {
            $('#modalTitle').text('修改新闻');
            $('#newsId').val(newsId);
            
            $.ajax({
                url: 'EditNewsServlet',
                type: 'GET',
                data: { id: newsId },
                success: function(response) {
                    if (response.success) {
                        $('#title').val(response.title);
                        $('#author').val(response.author);
                        $('#content').val(response.content);
                        $('#newsModal').show();
                    } else {
                        alert(response.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('加载新闻数据失败: ' + error);
                }
            });
        }

        function closeModal() {
            $('#newsModal').hide();
        }

        function submitNews(isEdit) {
            const formData = new FormData($('#newsForm')[0]);
            
            $.ajax({
                url: isEdit ? 'EditNewsServlet' : 'AddNewsServlet',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response.success) {
                        alert(response.message);
                        closeModal();
                        loadNewsList();
                    } else {
                        alert(response.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('操作失败: ' + error);
                }
            });
        }

        function deleteNews(newsId) {
            if (confirm('确定要删除这条新闻吗？')) {
                $.ajax({
                    url: 'DeleteNewsServlet',
                    type: 'POST',
                    data: { id: newsId },
                    success: function(response) {
                        if (response.success) {
                            alert('删除成功');
                            loadNewsList();
                        } else {
                            alert('删除失败: ' + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('删除失败: ' + error);
                    }
                });
            }
        }

        // 点击模态框外部时关闭
        $(window).click(function(event) {
            if ($(event.target).is('#newsModal')) {
                closeModal();
            }
        });
    </script>
</body>
</html>