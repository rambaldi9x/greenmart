package com.greenmart.model;

import java.io.Serializable;

public class ServiceResult<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    private boolean success;
    private String message;
    private T data;

    public ServiceResult() {}

    public ServiceResult(boolean success, String message, T data) {
        this.success = success;
        this.message = message;
        this.data = data;
    }

    public static <T> ServiceResult<T> ok(T data, String message) {
        return new ServiceResult<>(true, message, data);
    }

    public static <T> ServiceResult<T> ok(T data) {
        return new ServiceResult<>(true, null, data);
    }

    public static <T> ServiceResult<T> okMessage(String message) {
        return new ServiceResult<>(true, message, null);
    }

    public static <T> ServiceResult<T> error(String message) {
        return new ServiceResult<>(false, message, null);
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
