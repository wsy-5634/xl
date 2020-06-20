package com.fugu.deviceServer.common;

import java.util.Arrays;

public class ByteUtils {

    /**
     * int 转 byte数组 (地位在前)
     * @param integer
     * @return
     */
    public static byte[] int2BytesLower(int integer)
    {
        byte[] bytes = new byte[4];

        bytes[3] = (byte)(integer>>24 & 0xff);

        bytes[2] = (byte)(integer>>16 & 0xff);

        bytes[1] = (byte)(integer>>8 & 0xff);

        bytes[0] = (byte) (integer & 0xff);

        return bytes;
    }

    /**
     * int 转 byte数组 (地位在前)
     * @param integer
     * @return
     */
    public static byte[] int2BytesHigh(int integer)
    {
        byte[] bytes = new byte[4];

        bytes[0] = (byte)(integer>>24 & 0xff);

        bytes[1] = (byte)(integer>>16 & 0xff);

        bytes[2] = (byte)(integer>>8 & 0xff);

        bytes[3] = (byte) (integer & 0xff);

        return bytes;
    }

    /**
     * byte数组转int
     * @param bytes
     * @return
     */
    public static int bytes2Int(byte[] bytes )
    {
        //如果不与0xff进行按位与操作，转换结果将出错，有兴趣的同学可以试一下。
        int int1=bytes[0]&0xff;

        int int2 = 0xff;
        if (bytes.length > 1) {
            int2 = (bytes[1] & 0xff) << 8;
        }

        int int3 = 0xff;
        if (bytes.length > 2) {
            int3 = (bytes[2] & 0xff) << 16;
        }

        int int4 = 0xff;
        if (bytes.length > 3) {
            int4 = (bytes[3] & 0xff) << 24;
        }

        return int1|int2|int3|int4;
    }

    /**
     * short 转 byte数组 (地位在前)
     * @param shortValue
     * @return
     */
    public static byte[] short2BytesLower(short shortValue)
    {
        byte[] bytes = new byte[2];
        bytes[1] = (byte)(shortValue>>8 & 0xff);
        bytes[0] = (byte) (shortValue & 0xff);
        return bytes;
    }

    /**
     * short 转 byte数组 (地位在前)
     * @param shortValue
     * @return
     */
    public static byte[] short2BytesHigh(int shortValue)
    {
        byte[] bytes = new byte[2];
        bytes[0] = (byte)(shortValue>>8& 0xff);
        bytes[1] = (byte) (shortValue & 0xff);

        return bytes;
    }

    /**
     * byte数组转int
     * @param bytes
     * @return
     */
    public static short bytes2Short(byte[] bytes)
    {
        //如果不与0xff进行按位与操作，转换结果将出错，有兴趣的同学可以试一下。
        int int1 = bytes[0]&0xff;

        int int2 = 0xff;
        if (bytes.length > 1) {
            int2 = (bytes[1] & 0xff) << 8;
        }

        return (short) (int1|int2);
    }

    /**
     * 拆分byte数组
     *
     * @param bytes
     *            要拆分的数组
     * @param size
     *            要按几个组成一份
     * @return
     */
    public static byte[][] splitBytes(byte[] bytes, int size) {
        double splitLength = Double.parseDouble(size + "");
        int arrayLength = (int) Math.ceil(bytes.length / splitLength);
        byte[][] result = new byte[arrayLength][];
        int from, to;
        for (int i = 0; i < arrayLength; i++) {
            from = (int) (i * splitLength);
            to = (int) (from + splitLength);
            if (to > bytes.length)
                to = bytes.length;
            result[i] = Arrays.copyOfRange(bytes, from, to);
        }
        return result;
    }

    /**
     * 拆分byte数组
     *
     * @param bytes
     *            要拆分的数组
     * @param size
     *            要按几个组成一份
     * @return
     */
    public static byte[] splitBytes(byte[] bytes, int offset, int size) {
        double splitLength = Double.parseDouble(size + "");
        int arrayLength = (int) Math.ceil(bytes.length / splitLength);
        byte[] result = Arrays.copyOfRange(bytes, offset, offset + size);
        return result;
    }

    public static void main(String[] args ) {
        int i = 5;
        byte[] arr = int2BytesHigh(i);

        int j = bytes2Int(arr);

    }
}
