package com.ssm.test;

import com.ssm.dao.DepartmentMapper;
import com.ssm.dao.EmployeeMapper;
import com.ssm.entity.Department;
import com.ssm.entity.Employee;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao,指定使用spring的单元测试
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    private DepartmentMapper departmentMapper;
    @Autowired
    private EmployeeMapper employeeMapper;
    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Test
    public void testCRUD(){
        EmployeeMapper mapper = sqlSessionTemplate.getMapper(EmployeeMapper.class);
            String uid = UUID.randomUUID().toString().substring(0,5);
            mapper.insertSelective(new Employee(91,uid,"F",uid + "@qq.com",2));
        }
}
