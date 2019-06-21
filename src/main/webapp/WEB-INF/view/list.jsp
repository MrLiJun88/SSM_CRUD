<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<!doctype html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <title>员工列表</title>
    <% application.setAttribute("APP_PATH",request.getContextPath());
    %>
    <script type="text/javascript"src="${APP_PATH}/static/js/jquery-3.1.1.min.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary">
                <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                新增</button>
            <button class="btn btn-danger">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
                删除</button>
        </div>
    </div>
    <!--显示表格数据 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover">
                <tr>
                    <th>员工号</th>
                    <th>员工姓名</th>
                    <th>性别</th>
                    <th>email</th>
                    <th>所在部门</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                <tr>
                    <td>${emp.empId}</td>
                    <td>${emp.empName}</td>
                    <td>${emp.gender == "M"?"男":"女"}</td>
                    <td>${emp.email}</td>
                    <td>${emp.department.deptName}</td>
                    <td>
                        <button class="btn btn-info btn-sm">
                            <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                            编辑
                        </button>
                        <button class="btn btn-danger btn-sm">
                            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                            删除
                        </button>
                    </td>
                </tr>
                </c:forEach>
            </table>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6">
            当前记录数：xxxxx
        </div>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li>
                        <a href="#">首页</a>
                    </li>
                    <li>
                        <a href="#">末页</a>
                    </li>
                    <li>
                        <a href="#" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <li><a href="#">1</a></li>
                    <li><a href="#">2</a></li>
                    <li><a href="#">3</a></li>
                    <li><a href="#">4</a></li>
                    <li><a href="#">5</a></li>
                    <li>
                        <a href="#" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
