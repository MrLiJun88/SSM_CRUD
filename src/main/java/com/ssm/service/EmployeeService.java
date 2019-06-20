package com.ssm.service;

import com.ssm.dao.EmployeeMapper;
import com.ssm.entity.Employee;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    EmployeeMapper employeeMapper;

    /**查询所有员工信息*/
    public List<Employee> getAll(){
        return employeeMapper.selectByExampleWithDept(null);
    }
}
