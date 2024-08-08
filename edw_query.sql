WITH 
"T0" AS 
    (
    SELECT
        "T1"."DESCR_001" AS "DESCR_001", 
        "T1"."USER_DEF_CD_TRIMMED" AS "USER_DEF_CD_TRIMMED"
    FROM
        "EDW"."UDC" "T1" 
    WHERE 
        "T1"."PROD_CD" = '01' AND
        "T1"."USER_DEF_CDS" = 'SC'
    )
SELECT DISTINCT 
    "dimCustomer"."PARENT_ADDR_NUM" AS "Parent_Number", 
    "dimCustomer_Alias_Parent"."NAME_ALPHA" AS "Parent_Name", 
    "dimCustomer"."ADDR_NUM" AS "Customer_Number", 
    "dimCustomer"."NAME_ALPHA" AS "Customer_Name", 
    "dimCustomer"."ADDR_NUM_1ST" AS "Ship_To_Address", 
    "dimCustomer"."ADDR_NUM_2ND" AS "Bill_To_Address", 
    "dimCustomer"."ADDR_NUM_3RD" AS "Bill_To_Urn_Address", 
    "dimCustomer"."ADDR_NUM_4TH" AS "Statement_Address", 
    "dimCustomer"."ADDR_NUM_6TH" AS "Rebate_Address", 
    "dimCustomer"."ADDR_NUM_5TH" AS "Promotional_Mailing_Address", 
    "dimCustomer"."ALT_ADDR_KEY" AS "Legacy_Code", 
    "dimCustomer"."ADDR_TYPE_1" AS "Customer_Status_Code", 
    "dimCustomer"."TOT_DTHS" AS "Total_Deaths", 
    "dimCustomer"."CSKTD_DTHS" AS "Casket_Deaths", 
    "dimCustomer"."BURIALS" AS "Burials", 
    "dimCustomer"."RPT_CD_ADD_BK_015" AS "Supplier_Customer_Type", 
    "dimCustomer"."RPT_CD_ADD_BK_016" AS "Customer_Segment", 
    "dimCustomer"."ACCT_OPEN_DT" AS "Account_Open_Date", 
    "dimCustomer"."DELETED_FLG" AS "Deleted_from_JDE", 
    "dimCustomer"."DELETED_DT" AS "Deleted_Date", 
    "dimCustomer"."STANDARD_INDUSTRY_CD" AS "Industry_Code", 
    "T0"."DESCR_001" AS "Industry_Description", 
    "dimCustomer"."ADDRESS_LINE_1" AS "Line_1", 
    "dimCustomer"."CITY" AS "City", 
    "dimCustomer"."STATE_CD" AS "State_Code", 
    "dimCustomer"."ZIP" AS "Zip_Code", 
    "dimCustomer"."ADDRESS_EFF_DATE" AS "Address_Effective_Date"
FROM
    "EDW"."CUSTOMER" "dimCustomer"
        INNER JOIN "T0"
        ON "dimCustomer"."STANDARD_INDUSTRY_CD" = "T0"."USER_DEF_CD_TRIMMED"
            INNER JOIN "EDW"."CUSTOMER" "dimCustomer_Alias_Parent"
            ON "dimCustomer"."PARENT_HK" = "dimCustomer_Alias_Parent"."ADDRESS_BOOK_HK"