package com.mycode.crm.settings.web.pojo;

import org.springframework.stereotype.Component;

import java.util.Objects;

public class User {
    private Character id;
    private String loginAct;
    private String name;
    private String loginPwd;
    private String email;
    private Character expireTime;
    private Character lockState;
    private Character deptno;
    private String allowIps;
    private Character createTime;
    private String createBy;
    private Character editTime;
    private String editBy;

    public User() {
    }

    public User(Character id, String loginAct, String name, String loginPwd, String email, Character expireTime, Character lockState, Character deptno, String allowIps, Character createTime, String createBy, Character editTime, String editBy) {
        this.id = id;
        this.loginAct = loginAct;
        this.name = name;
        this.loginPwd = loginPwd;
        this.email = email;
        this.expireTime = expireTime;
        this.lockState = lockState;
        this.deptno = deptno;
        this.allowIps = allowIps;
        this.createTime = createTime;
        this.createBy = createBy;
        this.editTime = editTime;
        this.editBy = editBy;
    }

    public Character getId() {
        return id;
    }

    public void setId(Character id) {
        this.id = id;
    }

    public String getLoginAct() {
        return loginAct;
    }

    public void setLoginAct(String loginAct) {
        this.loginAct = loginAct;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Character getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(Character expireTime) {
        this.expireTime = expireTime;
    }

    public Character getLockState() {
        return lockState;
    }

    public void setLockState(Character lockState) {
        this.lockState = lockState;
    }

    public Character getDeptno() {
        return deptno;
    }

    public void setDeptno(Character deptno) {
        this.deptno = deptno;
    }

    public String getAllowIps() {
        return allowIps;
    }

    public void setAllowIps(String allowIps) {
        this.allowIps = allowIps;
    }

    public Character getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Character createTime) {
        this.createTime = createTime;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public Character getEditTime() {
        return editTime;
    }

    public void setEditTime(Character editTime) {
        this.editTime = editTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", loginAct='" + loginAct + '\'' +
                ", name='" + name + '\'' +
                ", loginPwd='" + loginPwd + '\'' +
                ", email='" + email + '\'' +
                ", expireTime=" + expireTime +
                ", lockState=" + lockState +
                ", deptno=" + deptno +
                ", allowIps='" + allowIps + '\'' +
                ", createTime=" + createTime +
                ", createBy='" + createBy + '\'' +
                ", editTime=" + editTime +
                ", editBy='" + editBy + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return Objects.equals(id, user.id) && Objects.equals(loginAct, user.loginAct) && Objects.equals(name, user.name) && Objects.equals(loginPwd, user.loginPwd) && Objects.equals(email, user.email) && Objects.equals(expireTime, user.expireTime) && Objects.equals(lockState, user.lockState) && Objects.equals(deptno, user.deptno) && Objects.equals(allowIps, user.allowIps) && Objects.equals(createTime, user.createTime) && Objects.equals(createBy, user.createBy) && Objects.equals(editTime, user.editTime) && Objects.equals(editBy, user.editBy);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, loginAct, name, loginPwd, email, expireTime, lockState, deptno, allowIps, createTime, createBy, editTime, editBy);
    }
}
