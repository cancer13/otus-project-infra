#!/bin/bash
SVC_ACCT="otus-project-sa-terraform"
FOLDER_ID=$(yc config list | yq '.folder-id')

yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
sleep 5
ACCT_ID=$(yc iam service-account get $SVC_ACCT | \
grep ^id | \
awk '{print $2}')

yc resource-manager folder add-access-binding --id $FOLDER_ID \
--role editor \
--service-account-id $ACCT_ID
sleep 5

yc iam key create --service-account-id $ACCT_ID --output ../../"$SVC_ACCT"_"$FOLDER_ID"_key.json
export TF_VAR_service_account_key_file="../../../$(echo $SVC_ACCT)_$(echo $FOLDER_ID)_key.json"
