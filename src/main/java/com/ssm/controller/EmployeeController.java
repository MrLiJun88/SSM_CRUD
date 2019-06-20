package com.ssm.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ssm.entity.Employee;
import com.ssm.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 处理页面对员工的crud请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping(value = "/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
        /**
         * 对查询到的员工信息进行分布
         * 引入PageHelper分页插件
         */
        /**传入开始页码，及每页多少数据 */
        PageHelper.startPage(pn,5);
        List<Employee> employeeList =  employeeService.getAll();
        /**用PageInfo对结果进行包装,连续显示的页数5*/
        PageInfo pageInfo = new PageInfo(employeeList,5);
        model.addAttribute("pageInfo",pageInfo);
        return "list";
    }
}
