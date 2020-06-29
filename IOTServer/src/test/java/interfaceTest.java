import com.fugu.modules.system.api.SysUserController;
import com.fugu.modules.system.entity.User;
import org.junit.Test;

public class interfaceTest {

    @Test
    public void test1(){
        SysUserController sysUserController = new SysUserController();
        User user = sysUserController.getById(4);
        System.out.println(user);
    }


}
