package com.fugu.deviceServer.encode;

import com.fugu.deviceServer.common.ByteUtils;
import com.fugu.deviceServer.common.CustomProtocol;
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
        //读取数据
        byte[] bytes = new byte[byteBuf.readableBytes()];
        byteBuf.readBytes(bytes);
        //解析协议
        CustomProtocol customProtocol = parseBuffer(bytes);
        list.add(customProtocol);
    }

    private CustomProtocol parseBuffer(byte[] bytes) {
        CustomProtocol customProtocol = new CustomProtocol();

        if (bytes[0] == 0xAA & bytes[1] == 0x55){//孚谷包头
            byte[] lengthByte = {bytes[2], bytes[3]};
            short length = ByteUtils.bytes2Short(lengthByte);
            byte[] content = ByteUtils.splitBytes(bytes, 2, length);


//            customProtocol.setId(id);
//            customProtocol.setContent(content);
        } else {
            customProtocol.setId(-1);
            customProtocol.setContent("");
        }
        return  customProtocol;
    }

}
