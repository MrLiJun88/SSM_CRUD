package com.ssm.test;

import com.github.pagehelper.PageInfo;
import com.ssm.entity.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:spring-mvc.xml"})
public class MvcTest {

    /**传入spring mvc的IOC*/
    @Autowired
    WebApplicationContext context;
    /**虚拟mvc请求*/
    MockMvc mockMvc;

    @Before
    public void initMvc(){
        mockMvc =  MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void TestPage() throws Exception{
        /**
         * 模拟向Controller层发送http请求
         */
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn","1")).andReturn();

        /**获取Controller层返回回来的数据集合*/
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前页码：" + pageInfo.getPageNum());
        System.out.println("总页码：" + pageInfo.getPages());
        System.out.println("总记录数 " + pageInfo.getTotal());
        System.out.println("在页面连接显示的页码 ");
        int[] nums = pageInfo.getNavigatepageNums();
        for(int n : nums){
            System.out.print(" "+ n);
        }
        /**获取员工数据*/
        List<Employee> list = pageInfo.getList();
        for(Employee emp : list){
            System.out.println(emp);
        }
    }

}
