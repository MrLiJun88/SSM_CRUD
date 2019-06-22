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
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>员工号</th>
                    <th>员工姓名</th>
                    <th>性别</th>
                    <th>email</th>
                    <th>所在部门</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>

    <div class="row">
        <!-- 标签信息 -->
        <div class="col-md-6" id="page_info_area">

        </div>
        <!-- 导航栏信息 -->
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>
<!--在页面加载完成后，直接向服务器发送请求获取返回来的 json 数据 -->
<script type="text/javascript">

    $(function () {
        //当页面一旦加载好就去访问服务器的首页
        to_page(1);
    });
    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn=" + pn,
            type:"GET",
            success:function(result){
                // console.log(result);
                //1.解释并显示员工信息
                build_emps_table(result);
                //2.解释并显示分布信息
                build_page_info(result);
                build_page_nav(result);
            }
        });
    };
    //1.解释并显示员工信息
    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        //获取到Controller层返回来的json数据
        var emps = result.resultMap.pageInfo.list;
        $.each(emps,function(index,item){
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd= $("<td></td>").append(item.empName);
            var genderTd=$("<td></td>").append(item.gender=='M'?"男":"女");
            var emailTd=$("<td></td>").append(item.email);
            var deptName=$("<td></td>").append(item.department.deptName);
            var editBtn=$("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            var delBtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            var btnTd=$("<td></td>").append(editBtn).append(" ").append(delBtn);
            $("<tr></tr>").append(empIdTd).
            append(empNameTd).
            append(genderTd).
            append(emailTd).
            append(deptName).
            append(btnTd).
            appendTo("#emps_table tbody");
        });
    };
    //解析显示分页信息
    function build_page_info(result) {
        $("#page_info_area").empty();
        $("#page_info_area").append("当前第" +result.resultMap.pageInfo.pageNum+ "页，共有" +
            result.resultMap.pageInfo.pages+
            "页，共有" +result.resultMap.pageInfo.total+ "条记录");
    };
    //2.//解析显示分页条信息
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        var ul=$("<ul></ul>").addClass("pagination");
        var firstPageLi= $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi= $("<li></li>").append($("<a></a>").append("&laquo;"));
        if(result.resultMap.pageInfo.hasPreviousPage==false){
            //判断是否有前一页
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }
            //为元素添加点击翻页的事件
            firstPageLi.click(function(){
                to_page(1);
            });
            prePageLi.click(function(){
                to_page(result.resultMap.pageInfo.pageNum-1);
            });
        ul.append(firstPageLi).append(prePageLi);
        var nextPageLi= $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi= $("<li></li>").append($("<a></a>").append("末页"));
        if(result.resultMap.pageInfo.hasNextPage==false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }
            //为末页和下一页添加点击跳转事件
            nextPageLi.click(function () {
                to_page(result.resultMap.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.resultMap.pageInfo.pages);
            });
        $.each(result.resultMap.pageInfo.navigatepageNums,function(index,item){
            var numLi=$("<li></li>").append($("<a></a>").append(item));
            if(result.resultMap.pageInfo.pageNum==item){
                //判断是否是当前页，如果是就高亮显示
                numLi.addClass("active");
            };
            numLi.click(function(){
                //调用ajax请求，跳转到指定页面
                to_page(item);
            });
            ul.append(numLi);
        });
        ul.append(nextPageLi).append(lastPageLi);
        var navEle=$("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    };
</script>
</body>
</html>
