package com.ssm.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ssm.entity.Employee;
import com.ssm.entity.Message;
import com.ssm.service.EmployeeService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    /**
     * 当向数据库存放用户信息时，对用户的信息进行校验，并绑定错误事件
     * */
    public Message saveEmp(@Validated Employee employee, BindingResult result){
        if(result.hasErrors()){
            /**将错误信息放在Map中，以json的形式返回给页面*/
            Map<String,Object> errorMap = new HashMap<>();
            List<FieldError> erros = result.getFieldErrors();
            for(FieldError error : erros){
                errorMap.put(error.getField(),error.getDefaultMessage());
                System.out.println("错误字段名 " + error.getField());
                System.out.println("错误信息 " + error.getDefaultMessage());
            }
            return Message.fail().add("errorMap",errorMap);
        }
        else {
            employeeService.saveEmpl(employee);
            return Message.success();
        }
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

    /**根据员工id获取到员工信息
     * @PathVariable("empId") 指定从url路径中获取empId值
     * */
    @RequestMapping(value = "/getEmp/{empId}",method = RequestMethod.GET)
    @ResponseBody
    public Message getEmp(@PathVariable("empId")Integer empId){
        Employee employee = employeeService.getEmp(empId);
        return Message.success().add("employee",employee);
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
