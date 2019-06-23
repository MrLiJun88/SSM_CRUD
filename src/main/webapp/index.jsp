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
<!-- 添加员工模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_input" class="col-sm-2 control-label">员工号</label>
                        <div class="col-sm-10">
                            <input type="text" name="empId" class="form-control" id="empId_input" placeholder="001">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="empName_input" class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_input" placeholder="李俊">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">所在部门</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId" id="dept_add_select">

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_but">保存</button>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary">
                <span class="glyphicon glyphicon-plus" id="emp_add_modal_btn" aria-hidden="true"></span>
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
    //总记录数
    var totalPages = 0;
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
        totalPages = result.resultMap.pageInfo.total;
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
        } else {
            //为元素添加点击翻页的事件
            firstPageLi.click(function(){
                to_page(1);
            });
            prePageLi.click(function(){
                to_page(result.resultMap.pageInfo.pageNum-1);
            });
        }
        ul.append(firstPageLi).append(prePageLi);
        var nextPageLi= $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi= $("<li></li>").append($("<a></a>").append("末页"));
        if(result.resultMap.pageInfo.hasNextPage==false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else {
            //为末页和下一页添加点击跳转事件
            nextPageLi.click(function () {
                to_page(result.resultMap.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.resultMap.pageInfo.pages);
            });
        }
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
    //表单数据重置函数
    function reset_form(ele){
        $(ele)[0].reset();
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");

    };
    //点击新增按钮，弹出模态框
    $("#emp_add_modal_btn").click(function () {
        //弹出之前，表单数据重置
        reset_form("#empAddModal form");
        //从数据库中获取部门信息显示在下拉列表中
        getDepartments();
        //弹出模态框
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });
    //从数据库中获取部门信息
    function getDepartments() {
        $.ajax({
            url:"${APP_PATH}/getDepts",
            type:"GET",
            success:function (result) {
                $.each(result.resultMap.departmentList,function () {
                    var optionEle=$("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEle.appendTo($("#dept_add_select"));
                });
            }
        });
    }
    //当点击保存按钮时，向数据库存入新的用户信息
    $("#emp_save_but").click(function () {
        //新添的员工信息要先提交给服务器进行校验，正确才可以保存到数据库
        if(! validate_add_form()){
            return false;
        };
        //校验新添用户名是否已经存在，如果存在则，不可以保存
        if($(this).attr("ajax_va") == "error"){
            return false;
        }
        $.ajax({
            url:"${APP_PATH}/saveEmp",
            type:"POST",
            data:$("#empAddModal form").serialize(),
            success:function(result) {
            /*
            当员工保存成功后
            1.关闭模态框
            2.到表单最后一行查看
             */
            $("#empAddModal").modal('hide');
            //显示表单最后一行数据
            to_page(totalPages);
        }
        });
    });
    //校验新添员工表单的信息是否合理
    function validate_add_form() {
        //校验员工的姓名与email
        var empName = $("#empName_input").val();
        //使用jquery自带的正则表达式
        var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        //1、校验用户名
        if(!regName.test(empName)){
            //让输入框变色，添加has-error类
            //给输入框下的span元素添加错误信息
            //调用用户信息状态判断函数
            show_validate_msg("#empName_input","error","用户名可以是2-5位中文或6-16位英文和数字的组合");
            return false;
        }else{
            show_validate_msg("#empName_input","success","");
        };
        var email = $("#email_add_input").val();
        //校验邮箱
        var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            show_validate_msg("#email_add_input","error","邮箱格式不正确");
            return false;
        }else{
            show_validate_msg("#email_add_input","success","");
        };
        return true;
    };
    //提取一个用于校验用户信息状态的函数
    function show_validate_msg(ele,status,msg){
        //先清空之前的状态信息
        $(ele).parent().removeClass("has-error has-success");
        $(ele).next("span").text("");
        if(status=="success"){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        };
        if(status=="error"){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        };
    };
    //给员工姓名绑定事件，当内容发生改变时，就发送ajax 请求
    //判断员工姓名是否已经存在于数据库中，若已经存在则返回提示信息
    $("#empName_input").change(function () {
        var empName = this.value;
        $.ajax({
            url:"${APP_PATH}/checkEmp",
            data:"empName=" + empName,
            type:"POST",
            success:function (result) {
                if(result.stateCode == 200){
                    show_validate_msg("#empName_input","success","用户名可用");
                    $("#emp_save_but").attr("ajax_va","success");
                }
                else {
                    show_validate_msg("#empName_input","error",result.resultMap.va_msg);
                    $("#emp_save_but").attr("ajax_va","error");
                }
            }
        });
    });
</script>
</body>
</html>
