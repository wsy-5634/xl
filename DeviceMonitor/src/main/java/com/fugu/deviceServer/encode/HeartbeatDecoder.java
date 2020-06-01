package com.fugu.deviceServer.encode;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.ByteToMessageDecoder;

import java.util.List;

/**
 * Created by Chris. 2020/05/10
 * 服务端解码器
 */
public class HeartbeatDecoder extends ByteToMessageDecoder {
    @Override
    protected void decode(ChannelHandlerContext channelHandlerContext, ByteBuf byteBuf, List<Object> list) throws Exception {
        long id = byteBuf.readLong();
        byte[] bytes = new byte[byteBuf.readableBytes()];
        byteBuf.readBytes(bytes);
        String content = new String(bytes);
//        CustomProtocol customProtocol = new CustomProtocol();
//        customProtocol.setId(id);
//        customProtocol.setContent(content);
//        list.add(customProtocol);
    }
}
