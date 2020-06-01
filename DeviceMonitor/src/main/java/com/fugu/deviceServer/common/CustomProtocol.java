package com.fugu.deviceServer.common;

import java.io.Serializable;

/**
 * Created by chris on 2019/03/07.
 */
public class CustomProtocol implements Serializable {


    private static final long serialVersionUID = 290429819365476544L;
    private long id;
    private String content;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public CustomProtocol(long id, String content) {
        this.id = id;
        this.content = content;
    }
    public CustomProtocol(){

    }

    @Override
    public String toString() {
        return "CustomProtocol{" +
                "id=" + id +
                ", content='" + content + '\'' +
                '}';
    }
}
