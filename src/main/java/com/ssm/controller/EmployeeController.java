package com.ssm.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ssm.entity.Employee;
import com.ssm.entity.Message;
import com.ssm.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理页面对员工的crud请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 将从数据库中查询出的所有员工信息以 json 的形式返回给前端
     * @param pn 从前端传来当前要查询的开始页数，默认是 1
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Message getEmplsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
        /**
         * 对查询到的员工信息进行分布
         * 引入PageHelper分页插件
         */
        /**传入开始页码，及每页多少数据 */
        PageHelper.startPage(pn,5);
        List<Employee> employeeList =  employeeService.getAll();
        /**用PageInfo对结果进行包装,连续显示的页数5*/
        PageInfo pageInfo = new PageInfo(employeeList,5);
        /**返回一个通用类，并将数据封闭在该类中，返回*/
        return Message.success().add("pageInfo",pageInfo);
    }

    /**保存新添员工信息*/
    @RequestMapping(value = "/saveEmp",method = RequestMethod.POST)
    @ResponseBody
    public Message saveEmp(Employee employee){
        employeeService.saveEmpl(employee);
        return Message.success();
    }

    /**检查页面传来的员工姓名是否可用*/
    @RequestMapping(value = "/checkEmp",method = RequestMethod.POST)
    @ResponseBody
    public Message checkEmp(@RequestParam("empName") String empName){
        /**
         * 在判断用户名是否已经存在时，先判断用户名是否合理，再判断
         */
        String check = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if(! empName.matches(check)){
            return Message.fail().add("va_msg","用户名可以是2-5位中文或6-16位英文和数字的组合");
        }
        /**数据库用户名重复校验*/
        boolean b = employeeService.checkEmp(empName);
        if(b){
            return Message.success();
        }
        return Message.fail().add("va_msg","用户名不可用");
    }






//    @RequestMapping(value = "/emps")
//    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
//        /**
//         * 对查询到的员工信息进行分布
//         * 引入PageHelper分页插件
//         */
//        /**传入开始页码，及每页多少数据 */
//        PageHelper.startPage(pn,5);
//        List<Employee> employeeList =  employeeService.getAll();
//        /**用PageInfo对结果进行包装,连续显示的页数5*/
//        PageInfo pageInfo = new PageInfo(employeeList,5);
//        model.addAttribute("pageInfo",pageInfo);
//        return "list";
//    }
}
