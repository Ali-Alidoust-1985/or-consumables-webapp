DROP TABLE my_user_role;

CREATE TABLE my_user_role (
                              user_id NUMBER NOT NULL,
                              role_id NUMBER NOT NULL,
                              PRIMARY KEY (user_id, role_id),

                              CONSTRAINT fk_user_role_user FOREIGN KEY (user_id)
                                  REFERENCES user_tbl(user_id)
                                      ON DELETE CASCADE,

                              CONSTRAINT fk_user_role_role FOREIGN KEY (role_id)
                                  REFERENCES role_tbl(role_id)
                                      ON DELETE CASCADE
);