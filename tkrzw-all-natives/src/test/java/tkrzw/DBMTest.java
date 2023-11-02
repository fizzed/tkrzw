package tkrzw;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.UUID;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

public class DBMTest {
    static private final Logger log = LoggerFactory.getLogger(DBMTest.class);

    @Test
    public void load() {
        final DBM dbm = new DBM();

        final String path = "target/"+ UUID.randomUUID()+".tkh";

        log.debug("Opening database {}", path);

        final Status status = dbm.open(path, true);

        log.debug("Open status was {}", status);

        if (!status.isOK()) {
            throw new RuntimeException("tkrzw open error: " + status.getMessage());
        }

        dbm.set("hello".getBytes(), "world".getBytes());

        assertThat(dbm.get("hello".getBytes()), is("world".getBytes()));

        // close database, then re-open it
        dbm.close();

        final DBM dbm2 = new DBM();

        final Status status2 = dbm2.open(path, true);

        log.debug("Open status #2 was {}", status2);

        if (!status2.isOK()) {
            throw new RuntimeException("tkrzw open error: " + status2.getMessage());
        }

        assertThat(dbm2.get("hello".getBytes()), is("world".getBytes()));
    }

    @Test
    public void version() {
        assertThat(Utility.VERSION, is("1.0.27"));
    }

}