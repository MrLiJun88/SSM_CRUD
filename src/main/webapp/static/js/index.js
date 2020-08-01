<!--在页面加载完成后，直接向服务器发送请求获取返回来的 json 数据 -->
//总记录数
var totalPages = 0;
//当前页
var currentPage = 0;
$(function () {
    //当页面一旦加载好就去访问服务器的首页
    to_page(1);
});

//加载首页第一页
function to_page(pn) {
    $.ajax({
        url: "/emps",
        data: "pn=" + pn,
        type: "GET",
        success: function (result) {
            // console.log(result);
            //1.解析并显示员工信息
            build_emps_table(result);
            //2.解析并显示分布信息
            build_page_info(result);
            build_page_nav(result);
        }
    });
};

//1.解析并显示员工信息
function build_emps_table(result) {
    $("#emps_table tbody").empty();
    //获取到Controller层返回来的json数据
    var emps = result.resultMap.pageInfo.list;
    $.each(emps, function (index, item) {
        var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
        var empIdTd = $("<td></td>").append(item.empId);
        var empNameTd = $("<td></td>").append(item.empName);
        var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
        var emailTd = $("<td></td>").append(item.email);
        var deptName = $("<td></td>").append(item.department.deptName);
        var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
            .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
        //为编辑按钮添加一个自定义属性，来表示当前员工id
        editBtn.attr("edit_ID", item.empId);
        var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
            .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
        //为编辑按钮添加一个自定义属性，来表示当前员工id
        delBtn.attr("del_ID", item.empId);
        var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
        $("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd).append(genderTd).append(emailTd).append(deptName).append(btnTd).appendTo("#emps_table tbody");
    });
};

//解析显示分页信息
function build_page_info(result) {
    $("#page_info_area").empty();
    $("#page_info_area").append("当前第" + result.resultMap.pageInfo.pageNum + "页，共有" +
        result.resultMap.pageInfo.pages +
        "页，共有" + result.resultMap.pageInfo.total + "条记录");
    totalPages = result.resultMap.pageInfo.total;
    currentPage = result.resultMap.pageInfo.pageNum;
};

//2.//解析显示分页条信息
function build_page_nav(result) {
    $("#page_nav_area").empty();
    var ul = $("<ul></ul>").addClass("pagination");
    var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
    var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
    if (result.resultMap.pageInfo.hasPreviousPage == false) {
        //判断是否有前一页
        firstPageLi.addClass("disabled");
        prePageLi.addClass("disabled");
    } else {
        //为元素添加点击翻页的事件
        firstPageLi.click(function () {
            to_page(1);
        });
        prePageLi.click(function () {
            to_page(result.resultMap.pageInfo.pageNum - 1);
        });
    }
    ul.append(firstPageLi).append(prePageLi);
    var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
    var lastPageLi = $("<li></li>").append($("<a></a>").append("末页"));
    if (result.resultMap.pageInfo.hasNextPage == false) {
        nextPageLi.addClass("disabled");
        lastPageLi.addClass("disabled");
    } else {
        //为末页和下一页添加点击跳转事件
        nextPageLi.click(function () {
            to_page(result.resultMap.pageInfo.pageNum + 1);
        });
        lastPageLi.click(function () {
            to_page(result.resultMap.pageInfo.pages);
        });
    }
    $.each(result.resultMap.pageInfo.navigatepageNums, function (index, item) {
        var numLi = $("<li></li>").append($("<a></a>").append(item));
        if (result.resultMap.pageInfo.pageNum == item) {
            //判断是否是当前页，如果是就高亮显示
            numLi.addClass("active");
        }
        ;
        numLi.click(function () {
            //调用ajax请求，跳转到指定页面
            to_page(item);
        });
        ul.append(numLi);
    });
    ul.append(nextPageLi).append(lastPageLi);
    var navEle = $("<nav></nav>").append(ul);
    navEle.appendTo("#page_nav_area");
};

//表单数据重置函数
function reset_form(ele) {
    $(ele)[0].reset();
    $(ele).find("*").removeClass("has-error has-success");
    $(ele).find(".help-block").text("");

};
//点击新增按钮，弹出模态框
$("#emp_add_modal_btn").click(function () {
    //弹出之前，表单数据重置
    reset_form("#empAddModal form");
    //从数据库中获取部门信息显示在下拉列表中
    getDepartments($("#dept_add_select"));
    //弹出模态框
    $("#empAddModal").modal({
        backdrop: "static"
    });
});

//从数据库中获取部门信息
function getDepartments(ele) {
    //清空之前下拉列表中的数据
    $(ele).empty();
    $.ajax({
        url: "/getDepts",
        type: "GET",
        success: function (result) {
            $.each(result.resultMap.departmentList, function () {
                var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                optionEle.appendTo(ele);
            });
        }
    });
}

//当点击保存按钮时，向数据库存入新的用户信息
$("#emp_save_but").click(function () {
    //新添的员工信息要先提交给ajax进行校验，正确才可以保存到数据库
    if (!validate_add_form()) {
        return false;
    }
    ;
    //校验新添用户名是否已经存在，如果存在则，不可以保存
    if ($(this).attr("ajax_va") == "error") {
        return false;
    }
    $.ajax({
        url: "/saveEmp",
        type: "POST",
        data: $("#empAddModal form").serialize(),
        success: function (result) {
            if (result.stateCode == 200) {
                /*
                 当员工保存成功后
                 1.关闭模态框
                 2.到表单最后一行查看
                */
                $("#empAddModal").modal('hide');
                //显示表单最后一行数据
                to_page(totalPages);
            } else {
                //显示失败信息
                //有哪个字段的错误信息，就显示哪个字段的错误信息
                if (undefined != result.resultMap.errorMap.email) {
                    show_validate_msg("#email_add_input", "error", result.resultMap.errorMap.email);
                }
                if (undefined != result.resultMap.errorMap.empName) {
                    show_validate_msg("#empName_input", "error", result.resultMap.errorMap.empName);
                }
            }
        }
    });
});

//校验新添员工表单的信息是否合理
function validate_add_form() {
    //校验员工的姓名与email
    var empName = $("#empName_input").val();
    //使用jquery自带的正则表达式
    var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
    //1、校验用户名
    if (!regName.test(empName)) {
        //让输入框变色，添加has-error类
        //给输入框下的span元素添加错误信息
        //调用用户信息状态判断函数
        show_validate_msg("#empName_input", "error", "用户名可以是2-5位中文或6-16位英文和数字的组合");
        return false;
    } else {
        show_validate_msg("#empName_input", "success", "");
    }
    ;
    var email = $("#email_add_input").val();
    //校验邮箱
    var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
    if (!regEmail.test(email)) {
        show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
        return false;
    } else {
        show_validate_msg("#email_add_input", "success", "");
    }
    ;
    return true;
};

//提取一个用于校验用户信息状态的函数
function show_validate_msg(ele, status, msg) {
    //先清空之前的状态信息
    $(ele).parent().removeClass("has-error has-success");
    $(ele).next("span").text("");
    if (status == "success") {
        $(ele).parent().addClass("has-success");
        $(ele).next("span").text(msg);
    }
    ;
    if (status == "error") {
        $(ele).parent().addClass("has-error");
        $(ele).next("span").text(msg);
    }
    ;
};
//给员工姓名绑定事件，当内容发生改变时，就发送ajax 请求
//判断员工姓名是否已经存在于数据库中，若已经存在则返回提示信息
$("#empName_input").change(function () {
    var empName = this.value;
    $.ajax({
        url: "/checkEmp",
        data: "empName=" + empName,
        type: "POST",
        success: function (result) {
            if (result.stateCode == 200) {
                show_validate_msg("#empName_input", "success", "用户名可用");
                $("#emp_save_but").attr("ajax_va", "success");
            } else {
                show_validate_msg("#empName_input", "error", result.resultMap.va_msg);
                $("#emp_save_but").attr("ajax_va", "error");
            }
        }
    });
});
/**为每个员工修改信息按钮绑定事件
 * on : 可以为后来的元素添加事件
 */
$(document).on("click", ".edit_btn", function () {
    //在弹出修改员工信息模态框时，也要显示部门信息
    getDepartments($("#empUpdateModal select"));
    //查询员工信息，并显示
    getEmp($(this).attr("edit_ID"));
    //将员工id传入模态框中，便于员工更新信息的提交
    $("#emp_update_btn").attr("edit_ID", $(this).attr("edit_ID"));
    //弹出模态框
    $("#empUpdateModal").modal({
        backdrop: "static"
    });
});
//删除员工信息
$(document).on("click", ".delete_btn", function () {
    //获取员工姓名
    var empName = $(this).parents("tr").find("td:eq(1)").text();
    //获取员工id
    var empId = $(this).attr("del_ID");
    //弹出是否确定删除对象框
    if (confirm("确认删除[" + empName + " ]吗？")) {
        //确认，即发送ajax请求
        $.ajax({
            url: "/deleteEmp/" + empId,
            type: "DELETE",
            success: function (result) {
                //回到本页
                to_page(currentPage);
            }
        });
    }
});

//获取到员工信息
function getEmp(empId) {
    $.ajax({
        url: "/getEmp/" + empId,
        type: "GET",
        success: function (result) {
            //获取从Controller层返回来的员工
            var employee = result.resultMap.employee;
            $("#empName_update_static").text(employee.empName);
            $("#email_update_input").val(employee.email);
            $("#empUpdateModal select").val([employee.dId]);
        }
    });
};
//为员工更新按钮绑定事件
$("#emp_update_btn").click(function () {
    //验证邮箱是否合法
    var email = $("#email_update_input").val();
    //获取到员工id
    var empId = $(this).attr("edit_ID");
    var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
    if (!regEmail.test(email)) {
        show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
        return false;
    } else {
        show_validate_msg("#email_add_input", "success", "");
    }
    ;
    /**发送ajax请求，更新员工*/
    $.ajax({
        url: "/updateEmp/" + empId,
        type: "PUT",
        data: $("#empUpdateModal form").serialize(),
        success: function (result) {
            //关闭模态框
            $("#empUpdateModal").modal("hide");
            //跳转到本页面
            to_page(currentPage);
        }
    });
});
//点击复选框，选择全选，全不选
$("#check_all").click(function () {
    $(".check_item").prop("checked", $("#check_all").prop("checked"));
});
//当下面的复选框被点满时，最上面的复选框也要自动选上
$(document).on("click", ".check_item", function () {
    var flag = $(".check_item:checked").length == $(".check_item").length;
    $("#check_all").prop("checked", flag);
});
//批量删除员工信息
$("#emp_delete_all_btn").click(function () {
    var empNames = "";
    var del_idstr = "";
    $.each($(".check_item:checked"), function () {
        empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
        del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
    });
    empNames = empNames.substring(0, empNames.length - 1);
    del_idstr = del_idstr.substring(0, del_idstr.length - 1);
    if (confirm("确认要删除【" + empNames + "】吗？")) {
        $.ajax({
            url: "/delAllEmp/" + del_idstr,
            type: "DELETE",
            success: function (result) {
                //删除成功后，跳转到本页
                to_page(currentPage);
            }
        });
    }
});
