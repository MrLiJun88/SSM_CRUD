package com.ssm.entity;

import java.util.HashMap;
import java.util.Map;

/**
 * 通用的返回类
 */
public class Message {
    /**
     * 状态码：
     * 200 成功
     * 250 失败
     */
    private int stateCode;
    /**提示信息*/
    private String message;
    /**用户返回给浏览器的数据*/
    private Map<String,Object> resultMap = new HashMap<>();

    public static Message success(){
        Message result = new Message();
        result.setStateCode(200);
        result.setMessage("处理成功");
        return result;
    }

    public static Message fail(){
        Message result = new Message();
        result.setStateCode(250);
        result.setMessage("处理失败");
        return result;
    }
    /**对Controller层的数据进行封闭，便于返回给前端*/
    public Message add(String key,Object value){
        this.getResultMap().put(key,value);
        return this;
    }

    public int getStateCode() {
        return stateCode;
    }

    public void setStateCode(int stateCode) {
        this.stateCode = stateCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }


    public Map<String, Object> getResultMap() {
        return resultMap;
    }

    public void setResultMap(Map<String, Object> resultMap) {
        this.resultMap = resultMap;
    }
}
