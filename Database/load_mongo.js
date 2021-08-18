for( i = 1; i < 5; i++){db.test.insert({
        "_id" : NumberLong(i),
        "instructedAmountCents" : 0,
        "addressVisited" : false,
        "customData" : {
                "institutionId" : "CBW01"
        },
        "customerOperator" : {
                "contact" : {
                        "primaryEmail" : "anp@bankcbw.com",
                        "primaryPhone" : "0017852077563"
                },
                "institution" : {
                        "institutionId" : "CBW01",
                        "institutionName" : "CBW"
                },
                "name" : "admin",
                "operatorFor" : "MASTER",
                "type" : "BANK_ADMIN"
        },
        "dateCreated" : ISODate("2019-10-15T07:17:27.727Z"),
        "ignorePatterns" : false,
        "isRound" : false,
        "lastTxnId" : "-1",
        "lastTxnIdForStats" : "-1",
        "mAccount" : {
                "institution" : {
                        "institutionId" : "01",
                        "institutionName" : "MASTER BANK"
                },
                "isSelfCheck" : false
        },
        "mAccountHolder" : {
                "address" : {
                        "addressLine1" : "Rua Iguatemi, 151, 6 andar, Itaim Bibi",
                        "addressLine2" : "",
                        "city" : "SAO PAULO",
                        "countryCode" : "76",
                        "municipality" : "",
                        "neighborhood" : "",
                        "state" : "Sao Paulo",
                        "zipCode" : "01451-011"
                },
                "contact" : {
                        "primaryEmail" : "testuser@masterbank.com",
                        "primaryPhone" : "111130711655"
                },
                "customerNumber" : "375658886876657",
                "customerType" : "ACCOUNT_HOLDER_BUSINESS",
                "dateOfBirth" : {
                        "dateOfBirth" : "19880108"
                },
                "holderId" : "XXXXX500003AB076",
                "holderIdType" : "GIIN",
                "holderName" : "Master BANK",
                "status" : "ACTIVE"
        },
        "mAmountList" : [
                {
                        "amount" : NumberLong(0),
                        "amountType" : "OPERATION",
                        "amountValue" : "0.0",
                        "credit" : false,
                        "currency" : "USD",
                        "currentCode" : "USD"
                }
        ],
        "mParticipantId" : NumberLong(1),
        "machineFingerprint" : {
                "ipAddress" : "70:163:40:37",
                "operatingSystem" : "Windows 7",
                "sessionId" : "812F5BD26C3A989698807866C1ECDA6E",
                "webBrowser" : "Chrome"
        },
        "patternKeyList" : [
                "CUST_TYPE:ACCOUNT_HOLDER_BUSINESS",
                "CUST_NUM:375658886876657",
                "ID_TYPE:GIIN",
                "ACCT_HLD_ID:XXXXX500003AB076",
                "DATE_OF_BIRTH:19880108",
                "ACCT_HLD_ENTITY_AGE:31",
                "ACCT_HLD_NAME:MASTER BANK",
                "ACCT_HLD_NAME_TOKEN:MASTER",
                "ACCT_HLD_NAME_TOKEN_IDX:1:MASTER",
                "ACCT_HLD_NAME_TOKEN:BANK",
                "ACCT_HLD_NAME_TOKEN_IDX:2:BANK",
                "ADDRESS:RUA IGUATEMI, 151, 6 ANDAR, ITAIM BIBI",
                "CITY:SAO PAULO",
                "STATE:SAO PAULO",
                "ZIP_CODE:76:01451-011",
                "COUNTRY_CODE:76",
                "FULL_ADDRESS:76:01451-011:SAO PAULO:SAO PAULO:RUA IGUATEMI, 151, 6 ANDAR, ITAIM BIBI",
                "EMAIL:TESTUSER@MASTERBANK.COM",
                "PHONE:76:111130711655",
                "BANK_ID:01",
                "BANK_NAME:MASTER BANK",
                "CLIENT_ID:LEDGER01",
                "BATCH_NUM:1571123846589",
                "TXN_NUM:QA1571015228793",
                "PURPOSE:PROFILE_CREATION",
                "PURPOSE_TOKEN:PROFILE_CREATION",
                "TXN_DATE:20191015",
                "TXN_DATE_FIN_TXN:20191015:NO",
                "TXN_WEEK:201942",
                "TXN_MONTH:201910",
                "TXN_YEAR:2019",
                "TXN_HOUR:02",
                "TXN_DAY:TUESDAY",
                "ITXN_DATE:20191015",
                "ITXN_WEEK:201942",
                "ITXN_MONTH:201910",
                "ITXN_YEAR:2019",
                "IP_ADDR:70:163:40:37",
                "TXN_CODE:PROFILE_CREATION01",
                "TXN_TYPE:PROFILE_CREATION",
                "TERMINAL:CE_DIR_SERVER:CE_DIR_SERVER01",
                "CUST_OP_NAME:BANK_ADMIN:ADMIN",
                "FINANCIAL_TXN:NO",
                "DATE_PROF_A2B:1:ALL:ALL",
                "DATE_PROF_A2B:1:ALL:20191015",
                "DATE_PROF_A2B:1:ALL:201942W",
                "DATE_PROF_A2B:1:ALL:201910",
                "DATE_PROF_A2B:1:ALL:2019",
                "NEW_CUST_PROFILE:ACCOUNT_HOLDER_BUSINESS:SENDER",
                "NEW_SENDER:Y"
        ],
        "profileList" : [
                "CUST:1",
                "MCUST:1"
        ],
        "purpose" : {
                "purposeDescription" : "PROFILE_CREATION"
        },
        "recal" : false,
        "rejected" : false,
        "senderCount" : NumberLong(0),
        "senderLastTransactionTime" : NumberLong(0),
        "senderRecipientCount" : NumberLong(0),
        "source" : {
                "batchNumber" : "1571123846589",
                "clientId" : "LEDGER01",
                "clientName" : "LEDGER",
                "institutionId" : "CBW01",
                "institutionName" : "CBW"
        },
        "stopRealTimeStat" : false,
        "terminal" : {
                "name" : "CE_DIR_SERVER",
                "number" : "CE_DIR_SERVER01",
                "type" : "CE_DIR_SERVER_WEB"
        },
        "timeTakenToSave" : NumberLong(1142),
        "transactionAmountCents" : NumberLong(0),
        "transactionCode" : "PROFILE_CREATION01",
        "transactionDateTime" : ISODate("2019-10-15T07:17:25.871Z"),
        "transactionNumber" : "QA1571015228793",
        "transactionType" : "PROFILE_CREATION",
        "version" : 0,
        "timeTaken" : {
                "step1Toc" : NumberLong(51),
                "step2Toc" : NumberLong(494),
                "step3Toc" : NumberLong(494),
                "step3Toc1" : NumberLong(730),
                "step4Toc" : NumberLong(792),
                "step5Toc" : NumberLong(923),
                "step6Toc" : NumberLong(925),
                "step7Toc" : NumberLong(925),
                "step8Toc" : NumberLong(955),
                "step8aToc" : NumberLong(975),
                "step9Toc" : NumberLong(1001),
                "step10Toc" : NumberLong(1142),
                "step11Toc" : NumberLong(1142)
        }
})}

