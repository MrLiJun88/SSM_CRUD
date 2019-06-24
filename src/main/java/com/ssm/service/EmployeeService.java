package com.ssm.service;

import com.ssm.dao.EmployeeMapper;
import com.ssm.entity.Employee;
import com.ssm.entity.EmployeeExample;
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
    /**保存员工信息*/
    public void saveEmpl(Employee employee){
        employeeMapper.insertSelective(employee);
    }

    /**检查员工姓名是否已经在数据库中存在*/
    public boolean checkEmp(String empName){
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(employeeExample);
        return count == 0 ? true:false;
    }

    /**根据员工id获取到员工信息*/
    public Employee getEmp(Integer empId){
        return employeeMapper.selectByPrimaryKey(empId);
    }

    /**更新员工信息*/
    public void updateEmp(Employee employee){
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**删除员工信息*/
    public void deleteEmp(Integer empId){
        employeeMapper.deleteByPrimaryKey(empId);
    }

    /**批量删除呐信息*/
    public void deleteBatch(List<Integer> list){
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpIdIn(list);
        employeeMapper.deleteByExample(employeeExample);
    }
}
