#!/bin/bash

# This script downloads all part-files from a specified S3 directory
# and concatenates them into a single local file.
# The heavy processing (symmetrizing, sorting) is now done in AWS Glue.

# --- Configuration ---
# PLEASE EDIT THESE VARIABLES TO MATCH YOUR ENVIRONMENT

# The S3 bucket where your Glue job output is located.
S3_BUCKET="openalex-outputs"

# The S3 prefix (folder) containing the final, bidirectional part-files.
# IMPORTANT: Make sure this ends with a trailing slash '/'.
S3_PREFIX="cwts/query2/network_assets/version3/edges_bidirectional.txt/"

# The full path for the final, combined output file on the local EC2 instance.
FINAL_OUTPUT_FILE="./data/edges_bidirectional.txt"

# A temporary local directory to store the downloaded part-files.
LOCAL_TEMP_DIR="/tmp/query2/"

# --- Script Logic ---

set -e

echo "Starting S3 file download and combine process..."

echo "Step 1: Creating temporary directory at ${LOCAL_TEMP_DIR}"
mkdir -p ${LOCAL_TEMP_DIR}

echo "Step 2: Downloading files from s3://${S3_BUCKET}/${S3_PREFIX} to ${LOCAL_TEMP_DIR}"
aws s3 cp "s3://${S3_BUCKET}/${S3_PREFIX}" "${LOCAL_TEMP_DIR}" --recursive

echo "Step 3: Concatenating downloaded files into ${FINAL_OUTPUT_FILE}"
cat "${LOCAL_TEMP_DIR}"* > "${FINAL_OUTPUT_FILE}"

echo "Step 4: Cleaning up temporary directory..."
rm -rf "${LOCAL_TEMP_DIR}"

echo "----------------------------------------------------"
echo "Success! Bidirectional file created at: ${FINAL_OUTPUT_FILE}"
echo "----------------------------------------------------"
