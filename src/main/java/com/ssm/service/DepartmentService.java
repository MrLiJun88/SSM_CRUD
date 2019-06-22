package com.ssm.service;

import com.ssm.dao.DepartmentMapper;
import com.ssm.entity.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    DepartmentMapper departmentMapper;

    /**查询所有员工信息*/
    public List<Department> getDepts(){
        return departmentMapper.selectByExample(null);
    }
}
