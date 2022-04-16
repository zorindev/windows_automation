import sys
from os.path import exists
import errno
import os
import sqlite3


def main(args):
    """
    main
    """
    db_file_name = ""
    if(len(args) > 1):
        db_file_name = args[1]
        if(not exists(db_file_name)):
            
            """
            raise FileNotFoundError(
                errno.ENOENT, 
                os.strerror(errno.ENOENT), 
                db_file_name
            )
            """
            print("file not found: " + db_file_name)

        else:

            conn = sqlite3.connect(db_file_name)
            cursor = conn.execute(
                "   select      count(*)    \
                    from        ad_events   \
                    group by    uuid        \
                "
            )

            count = len(cursor.fetchall())
            print(count)

    else:
        print("usage error: " + os.path.basename(__file__) + " </abs/path/to/sql.db>")

if __name__ == "__main__":
    main(sys.argv)
