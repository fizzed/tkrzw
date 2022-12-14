package tkrzw;

import org.junit.Test;

import java.util.UUID;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

public class DBMTest {

    @Test
    public void load() {
        final DBM dbm = new DBM();

        final Status status = dbm.open("target/"+ UUID.randomUUID()+".tkh", true);

        if (!status.isOK()) {
            throw new RuntimeException("tkrzw open error: " + status.getMessage());
        }

        dbm.set("hello".getBytes(), "world".getBytes());

        assertThat(dbm.get("hello".getBytes()), is("world".getBytes()));
    }

}