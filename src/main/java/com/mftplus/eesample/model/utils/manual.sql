CREATE TABLE manual_types (
                              manual_type_id VARCHAR(100) PRIMARY KEY,
                              equipmentName VARCHAR(100),
                              brand           VARCHAR(100) NOT NULL,
                              model           VARCHAR(100) NOT NULL,
                              file_path       VARCHAR(500),
                              file_name       VARCHAR(200),
                              content_type    VARCHAR(100),
                              upload_date     TIMESTAMP

);

-- ایندکس روی ترکیب brand+model برای سرعت lookup
DROP INDEX UX_MANUAL_TYPES_TRIPLE;
CREATE UNIQUE INDEX UX_MANUAL_TYPES_TRIPLE ON manual_types (equipmentName, brand, model);