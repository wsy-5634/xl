package com.fugu.utils;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.EnumMap;
import java.util.Iterator;
import java.util.Map.Entry;
import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

public class FileTypeUtil
{
    public final static EnumMap<FileTypeEnum, String> FILE_TYPE_MAP = new EnumMap<FileTypeEnum, String>(FileTypeEnum.class);

    private FileTypeUtil(){}

    static{
        getAllFileType();  //初始化文件类型信息
    }

    /**
     * Created on 2010-7-1
     * <p>Discription:[getAllFileType,常见文件头信息]</p>
     * @author:[shixing_11@sina.com]
     */
    private static void getAllFileType()
    {
        FILE_TYPE_MAP.put(FileTypeEnum.jpg, "FFD8FF"); //JPEG (jpg)
        FILE_TYPE_MAP.put(FileTypeEnum.png, "89504E47");  //PNG (png)
        FILE_TYPE_MAP.put(FileTypeEnum.gif, "47494638");  //GIF (gif)
        FILE_TYPE_MAP.put(FileTypeEnum.tif, "49492A00");  //TIFF (tif)
        FILE_TYPE_MAP.put(FileTypeEnum.bmp, "424D"); //Windows Bitmap (bmp)
        FILE_TYPE_MAP.put(FileTypeEnum.dwg, "41433130"); //CAD (dwg)
        FILE_TYPE_MAP.put(FileTypeEnum.html, "68746D6C3E");  //HTML (html)
        FILE_TYPE_MAP.put(FileTypeEnum.rtf, "7B5C727466");  //Rich Text Format (rtf)
        FILE_TYPE_MAP.put(FileTypeEnum.xml, "3C3F786D6C");
        FILE_TYPE_MAP.put(FileTypeEnum.rar, "52617221");
        FILE_TYPE_MAP.put(FileTypeEnum.psd, "38425053");  //Photoshop (psd)
        FILE_TYPE_MAP.put(FileTypeEnum.eml, "44656C69766572792D646174653A");  //Email [thorough only] (eml)
        FILE_TYPE_MAP.put(FileTypeEnum.dbx, "CFAD12FEC5FD746F");  //Outlook Express (dbx)
        FILE_TYPE_MAP.put(FileTypeEnum.pst, "2142444E");  //Outlook (pst)
        FILE_TYPE_MAP.put(FileTypeEnum.xls, "D0CF11E0");  //MS Word
        FILE_TYPE_MAP.put(FileTypeEnum.xlsx, "504B0304");  //MS Word
        FILE_TYPE_MAP.put(FileTypeEnum.wps, "d0cf11e0a1b11ae10000"); //WPS
        FILE_TYPE_MAP.put(FileTypeEnum.doc, "D0CF11E0");  //MS Excel 注意：word 和 excel的文件头一样
        FILE_TYPE_MAP.put(FileTypeEnum.docx, "504B0304");  //MS Excel 注意：word 和 excel的文件头一样
        FILE_TYPE_MAP.put(FileTypeEnum.ppt, "D0CF11E0");  //MS Excel 注意：word 和 excel的文件头一样
        FILE_TYPE_MAP.put(FileTypeEnum.mdb, "5374616E64617264204A");  //MS Access (mdb)
        FILE_TYPE_MAP.put(FileTypeEnum.wpd, "FF575043"); //WordPerfect (wpd)
        FILE_TYPE_MAP.put(FileTypeEnum.eps, "252150532D41646F6265");
        FILE_TYPE_MAP.put(FileTypeEnum.ps, "252150532D41646F6265");
        FILE_TYPE_MAP.put(FileTypeEnum.pdf, "255044462D312E");  //Adobe Acrobat (pdf)
        FILE_TYPE_MAP.put(FileTypeEnum.qdf, "AC9EBD8F");  //Quicken (qdf)
        FILE_TYPE_MAP.put(FileTypeEnum.pwl, "E3828596");  //Windows Password (pwl)
        FILE_TYPE_MAP.put(FileTypeEnum.wav, "57415645");  //Wave (wav)
        FILE_TYPE_MAP.put(FileTypeEnum.avi, "41564920");
        FILE_TYPE_MAP.put(FileTypeEnum.ram, "2E7261FD");  //Real Audio (ram)
        FILE_TYPE_MAP.put(FileTypeEnum.rm, "2E524D46");  //Real Media (rm)
        FILE_TYPE_MAP.put(FileTypeEnum.mpg, "000001BA");  //
        FILE_TYPE_MAP.put(FileTypeEnum.mov, "6D6F6F76");  //Quicktime (mov)
        FILE_TYPE_MAP.put(FileTypeEnum.asf, "3026B2758E66CF11"); //Windows Media (asf)
        FILE_TYPE_MAP.put(FileTypeEnum.mid, "4D546864");  //MIDI (mid)
        FILE_TYPE_MAP.put(FileTypeEnum.blank, "");  //空白文件
    }

    /**
     * Created on 2010-7-1
     * <p>Discription:[getImageFileType,获取图片文件实际类型,若不是图片则返回null]</p>
     * @param f
     * @return fileType
     * @author:[shixing_11@sina.com]
     */
    public final static String getImageFileType(File f)
    {
        if (isImage(f))
        {
            try
            {
                ImageInputStream iis = ImageIO.createImageInputStream(f);
                Iterator<ImageReader> iter = ImageIO.getImageReaders(iis);
                if (!iter.hasNext())
                {
                    return null;
                }
                ImageReader reader = iter.next();
                iis.close();
                return reader.getFormatName();
            }
            catch (IOException e)
            {
                return null;
            }
            catch (Exception e)
            {
                return null;
            }
        }
        return null;
    }

    /**
     * Created on 2010-7-1
     * <p>Discription:[getFileByFile,获取文件类型,包括图片,若格式不是已配置的,则返回null]</p>
     * @param file
     * @return fileType
     * @author:[shixing_11@sina.com]
     */
    public final static FileTypeEnum getFileTypeByFile(File file)
    {
        FileTypeEnum filetype = null;
        byte[] b = new byte[50];
        try
        {
            InputStream is = new FileInputStream(file);
            is.read(b);
            filetype = getFileTypeByStream(b);
            is.close();
        }
        catch (FileNotFoundException e)
        {
            e.printStackTrace();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        return filetype;
    }

    public final static FileTypeEnum getFileTypeByFileInputStream(InputStream is)
    {
        FileTypeEnum filetype = null;
        byte[] b = new byte[50];
        try
        {
            is.read(b);
            filetype = getFileTypeByStream(b);
            is.close();
        }
        catch (FileNotFoundException e)
        {
            e.printStackTrace();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        return filetype;
    }

    /**
     * Created on 2010-7-1
     * <p>Discription:[getFileTypeByStream]</p>
     * @param b
     * @return fileType
     * @author:[shixing_11@sina.com]
     */
    private final static FileTypeEnum getFileTypeByStream(byte[] b)
    {
        String filetypeHex = String.valueOf(getFileHexString(b));
        Iterator<Entry<FileTypeEnum, String>> entryiterator = FILE_TYPE_MAP.entrySet().iterator();
        while (entryiterator.hasNext()) {
            Entry<FileTypeEnum,String> entry =  entryiterator.next();
            String fileTypeHexValue = entry.getValue();
            if (filetypeHex.toUpperCase().startsWith(fileTypeHexValue)) {
                return entry.getKey();
            }
        }
        return FileTypeEnum.blank;
    }

    /**
     * Created on 2010-7-2
     * <p>Discription:[isImage,判断文件是否为图片]</p>
     * @param file
     * @return true 是 | false 否
     * @author:[shixing_11@sina.com]
     */
    public static final boolean isImage(File file){
        boolean flag = false;
        try
        {
            BufferedImage bufreader = ImageIO.read(file);
            int width = bufreader.getWidth();
            int height = bufreader.getHeight();
            if(width==0 || height==0){
                flag = false;
            }else {
                flag = true;
            }
        }
        catch (IOException e)
        {
            flag = false;
        }catch (Exception e) {
            flag = false;
        }
        return flag;
    }

    /**
     * Created on 2010-7-1
     * <p>Discription:[getFileHexString]</p>
     * @param b
     * @return fileTypeHex
     * @author:[shixing_11@sina.com]
     */
    public final static String getFileHexString(byte[] b)
    {
        StringBuilder stringBuilder = new StringBuilder();
        if (b == null || b.length <= 0)
        {
            return null;
        }
        for (int i = 0; i < b.length; i++)
        {
            int v = b[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2)
            {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        return stringBuilder.toString();
    }
}
