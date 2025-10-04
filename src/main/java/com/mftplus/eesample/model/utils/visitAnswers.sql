CREATE TABLE visit_answers (
                               id NUMBER PRIMARY KEY,
                               record_id NUMBER NOT NULL,
                               question_id NUMBER NOT NULL,
                               answer CLOB, -- برای متن‌های طولانی‌تر از VARCHAR2

                               CONSTRAINT fk_record FOREIGN KEY (record_id) REFERENCES visit_records(id),
                               CONSTRAINT fk_question FOREIGN KEY (question_id) REFERENCES visit_questions(id)
);

-- ایجاد sequence برای تولید شناسه
CREATE SEQUENCE seq_visit_answer START WITH 1 INCREMENT BY 1 NOCACHE;

-- ایجاد trigger برای اختصاص شناسه هنگام insert
CREATE OR REPLACE TRIGGER trg_visit_answer_before_insert
    BEFORE INSERT ON visit_answers
    FOR EACH ROW
BEGIN
    SELECT seq_visit_answer.NEXTVAL INTO :NEW.id FROM dual;
END;