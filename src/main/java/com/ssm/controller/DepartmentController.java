package com.ssm.controller;

import com.ssm.entity.Department;
import com.ssm.entity.Message;
import com.ssm.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DepartmentController {

    @Autowired
    DepartmentService departmentService;

    @RequestMapping("/getDepts")
    @ResponseBody
    public Message getEmplsWithJson(){
        List<Department> departmentList = departmentService.getDepts();
        Message result = Message.success().add("departmentList",departmentList);
        return result;
    }
}
