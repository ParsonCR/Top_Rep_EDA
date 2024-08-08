WITH CUST_REP AS (SELECT DISTINCT 
    "dimCustomer"."ADDRESS_BOOK_HK" as "Customer_Key",
    "dimCustomer"."ADDR_NUM" AS "Customer_Number", 
    "dimCustomer"."NAME_ALPHA" AS "Customer_Name", 
    Decode("dimCustomer"."ADDR_TYPE_1", 'CO', 'Closed', 'Active') AS "Customer_Status", 
    "dimCustomer"."CUST_TYPE_GROUP" as "Customer_Segment",
    "dimCustomer"."RPT_CD_ADD_BK_003" AS "Customer_Territory", 
    "dimCustomer"."TOT_DTHS" AS "Total_Deaths", 
    "dimCustomer"."CSKTD_DTHS" AS "Casket_Deaths", 
    "dimCustomer"."BURIALS" AS "Burials", 
    "dimCustomer"."NON_CSKT_CREMS" AS "Non_Casket_Cremations", 
    "dimCustomer"."CREM_CSKT" AS "Casket_Cremations", 
    "dimCustomer"."SELECTION_ROOM_SIZE" AS "Room_Size_Selections", 
    "dimCustomer"."RPT_CD_ADD_BK_001" AS "Customer_Division", 
    "dimCustomer"."RPT_CD_ADD_BK_002" AS "Customer_Region", 
    "dimCustomer"."RPT_CD_ADD_BK_003" AS "Customer_Territory1", 
    "dimDivision"."DIVISION_CD" AS "Division_Code", 
    "dimDivision"."DIVISION_DESCRIPTION" AS "Division_Description", 
    "dimRegion"."REGION_CD" AS "Region_Code", 
    "dimRegion"."REGION_NAME" AS "Region_Description", 
    SUBSTR("dimTerritory"."TERRITORY_CD", 1, 2) AS "Territory__First_2_Digits_", 
    "dimTerritory"."TERRITORY_CD" AS "Territory_Code", 
    "dimTerritory"."TERRITORY_NAME" AS "Territory_Description", 
    Decode("dimTerritory"."MAILING_NAME", ' ', 
        CASE 
            WHEN SUBSTR("dimTerritory"."TERRITORY_CD", 1, 2) IS NULL THEN NULL
            ELSE 'OPEN-' || SUBSTR("dimTerritory"."TERRITORY_CD", 1, 2)
        END, "dimTerritory"."MAILING_NAME") AS "Territory_Rep_Name", 
    "dimCustomer"."ADDR_TYPE_1" AS "Customer_Status_Code", 
    "dimCustomer"."STANDARD_INDUSTRY_CD" AS "Industry_Code", 
    "dimCustomer"."RPT_CD_ADD_BK_015" AS "Supplier_Customer_Type", 
    "dimCustomer"."RPT_CD_ADD_BK_018" AS "Top_Competitor", 
    Decode("dimTerritory"."MAILING_NAME", ' ', 
        CASE 
            WHEN SUBSTR("dimTerritory"."TERRITORY_CD", 1, 2) IS NULL THEN NULL
            ELSE 'OPEN-' || SUBSTR("dimTerritory"."TERRITORY_CD", 1, 2)
        END, "dimTerritory"."MAILING_NAME") AS "Territory_Rep_Name1"
FROM
    "EDW"."CUSTOMER" "dimCustomer"
        INNER JOIN "EDW"."TERRITORY" "dimTerritory"
        ON "dimCustomer"."RPT_CD_ADD_BK_003" = "dimTerritory"."TERRITORY_CD"
            INNER JOIN "EDW"."REGION" "dimRegion"
            ON "dimRegion"."REGION_CD" = "dimTerritory"."REGION_CODE"
                INNER JOIN "EDW"."DIVISION" "dimDivision"
                ON "dimDivision"."DIVISION_CD" = "dimRegion"."DIVISION_CD" 
WHERE 
    "dimCustomer"."ADDR_TYPE_1" IN ( 
        'C', 
        'CO' ) AND
    NOT ( LOWER("dimCustomer"."RPT_CD_ADD_BK_003") LIKE 'g%' ) AND --exclude SCI
    NOT ( LOWER("dimCustomer"."RPT_CD_ADD_BK_003") LIKE 'k%' ) AND --
    NOT ( LOWER("dimCustomer"."RPT_CD_ADD_BK_003") LIKE 't%' ) AND
    NOT ( LOWER("dimCustomer"."RPT_CD_ADD_BK_003") LIKE 'ns%' ) -- AND
    --LOWER("dimTerritory"."TERRITORY_NAME") like '%hickerson%'
--    "dimTerritory"."TERRITORY_CD" IN ('33', 'DW', '17', 'W2', 'JM', 'DK', 'JV',
--                                      '04', '10', '03', 'ZT', 'JP', 'ZW')
)
SELECT CUST_REP.*,
"Orders"."GL_DATE",
"Orders"."GL_DATE_ID",
"Orders"."DESCRIPTION",
"Orders"."CSC",
"Orders"."AMT_EXTENDED_PRICE",
"Orders"."UNITS_SHIPPED",
"Orders"."UNITS_BILLED",
"Orders"."DT_REQUESTED_ID",
"Orders"."SCHEDULED_PICK_DT_ID",
"Orders"."ACTUAL_SHIP_DT_ID",
"Orders"."AMT_PRICE_PER_UNIT_2",
"Orders"."AMT_LIST_PRICE_PER_UNIT",
"Orders"."AMT_UNIT_COST",
"Orders"."AMT_EXTENDED_COST",
"Orders"."OH_DEL_INSTR_1",
"Orders"."OH_DEL_INSTR_2",
"Orders"."TERMS_DISC",
"Orders"."NET_AMOUNT",
"Product"."PRIMARY_PRODUCT_TYPE",
"Product"."LEVEL_1_DESCR",
"Product"."LEVEL_2_DESCR",
"Product"."PRICE_LIST_DESC",
"Product"."CONSUMER_DESC",
"Product"."QUOTA_CAT_CD4_BL05",
"Product"."SRP10"
FROM "CUST_REP"
JOIN EDW.order_dtl_fact "Orders"
ON "Orders".ship_to_addr_hk = CUST_REP."Customer_Key"
JOIN EDW.PRODUCT "Product"
ON "Orders".ITEM_MASTER_HK = "Product".ITEM_MASTER_HK
WHERE "Orders"."GL_DATE_ID" > '20240101'
AND "Orders"."ORDER_TYPE" IN ('SO', 'S2', 'C2', 'S9', 'C9')