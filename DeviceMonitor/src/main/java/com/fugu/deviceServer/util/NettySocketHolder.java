package com.fugu.deviceServer.util;

import io.netty.channel.socket.nio.NioSocketChannel;

import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by chris
 */
public class NettySocketHolder {

    private static final Map<Long, NioSocketChannel> MAP = new ConcurrentHashMap<>(16);
    private static final  Map<Long, Integer> TIMEOUTMAP = new ConcurrentHashMap<>(16);

    public static void put(Long id, NioSocketChannel socketChannel) {
        MAP.put(id, socketChannel);
    }

    public static NioSocketChannel get(Long id) {
        return MAP.get(id);
    }

    public static Long get(NioSocketChannel channel) {
        Optional<Map.Entry<Long, NioSocketChannel>> set = MAP.entrySet().stream().filter(entry -> entry.getValue() == channel).findFirst();
        Map.Entry<Long, NioSocketChannel> entry = set.get();
        return entry.getKey();
    }

    public static Map<Long, NioSocketChannel> getMAP() {
        return MAP;
    }

    public static void remove(NioSocketChannel nioSocketChannel) {
        MAP.entrySet().stream().filter(entry -> entry.getValue() == nioSocketChannel).forEach(entry -> MAP.remove(entry.getKey()));
    }

    public static Integer getTimoutNum(Long id) {
        return TIMEOUTMAP.get(id);
    }

    public static void setTimeOutNumber(Long id, int num) {
        TIMEOUTMAP.replace(id, num);
    }

    public static Map<Long, Integer> getTimeOutMAP() {
        return TIMEOUTMAP;
    }

    public static void removeTimeOut(Long id) {
        TIMEOUTMAP.entrySet().stream().filter(entry -> entry.getValue().longValue() == id).forEach(entry -> TIMEOUTMAP.remove(entry.getKey()));
    }
}
