import boto3
from datetime import datetime
import subprocess
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

# Define parameters for mysqldump
host = "my-data-base.c3oegc26yc70.us-west-2.rds.amazonaws.com"
port = "3306"
user = "admin"
password = "foobarbaz"  # Replace with the actual password
databases = ["my_database", "my_database1", "mydb"]

# Get the current date and time in the format yyyy-mm-dd_hh-mm-ss
timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
output_file = f"backup_{timestamp}.sql"  # Create a unique file name with the date

# Create the mysqldump command
command = [
    "mysqldump",
    "-h", host,
    "-P", port,
    "-u", user,
    f"-p{password}",  # Use f"-p{password}" to include the password
    "--databases",
    *databases  # Expands the list of databases into arguments
]

# Run the command and redirect output to a file
with open(output_file, "w") as outfile:
    try:
        subprocess.run(command, stdout=outfile, stderr=subprocess.PIPE, check=True)
        print(f"Backup successfully saved to {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error during backup: {e.stderr.decode()}")
# Upload to S3
def upload_to_s3(file_path, bucket_name, s3_key):
    try:
        # Explicitly pass AWS credentials
        s3 = boto3.client(
            's3',
            aws_access_key_id='',
            aws_secret_access_key='',
            region_name='us-west-2'
        )

        # Upload the file to S3
        s3.upload_file(file_path, bucket_name, s3_key)
        print(f"File '{file_path}' successfully uploaded to S3 as '{s3_key}'.")
    except FileNotFoundError:
        print(f"Error: The file '{file_path}' was not found.")
    except NoCredentialsError:
        print("Error: AWS credentials not found.")
    except PartialCredentialsError:
        print("Error: Incomplete AWS credentials provided.")
    except Exception as e:
        print(f"An error occurred during S3 upload: {e}")

def lambda_handler(event, context):
    bucket_name = "kkkki666666"  # Replace with your S3 bucket name
    s3_key = f"backups/{output_file}"  # Use the unique filename as the S3 key

    # Upload the backup file to S3
    upload_to_s3(output_file, bucket_name, s3_key)


import boto3
import subprocess
from datetime import datetime
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
import os

def lambda_handler(event, context):
    # Retrieve environment variables
    host = "my-data-base.c3oegc26yc70.us-west-2.rds.amazonaws.com"
port = "3306"
user = "admin"
password = "foobarbaz"  # Replace with the actual password
databases = ["my_database", "my_database1", "mydb"]

    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT", "3306")
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    bucket_name = os.getenv("S3_BUCKET")
    databases = os.getenv("DB_NAMES", "my_database").split(",")  # Comma-separated DB names

    # Generate the backup filename with timestamp
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    output_file = f"/tmp/backup_{timestamp}.sql"  # Use /tmp for temporary storage in Lambda

    # Create the mysqldump command
    command = [
        "mysqldump",
        "-h", host,
        "-P", port,
        "-u", user,
        f"-p{password}",  # Include password securely
        "--databases",
        *databases
    ]

    try:
        # Run the mysqldump command
        with open(output_file, "w") as outfile:
            subprocess.run(command, stdout=outfile, stderr=subprocess.PIPE, check=True)
        print(f"Backup successfully saved to {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error during backup: {e.stderr.decode()}")
        return {"statusCode": 500, "body": f"Backup failed: {e.stderr.decode()}"}

    # Upload to S3
    s3_key = f"backups/{os.path.basename(output_file)}"
    try:
        s3 = boto3.client("s3")
        s3.upload_file(output_file, bucket_name, s3_key)
        print(f"File '{output_file}' successfully uploaded to S3 as '{s3_key}'.")
        return {"statusCode": 200, "body": f"Backup successfully uploaded to S3: {s3_key}"}
    except FileNotFoundError:
        print(f"Error: The file '{output_file}' was not found.")
        return {"statusCode": 404, "body": "Backup file not found."}
    except NoCredentialsError:
        print("Error: AWS credentials not found.")
        return {"statusCode": 403, "body": "AWS credentials not found."}
    except PartialCredentialsError:
        print("Error: Incomplete AWS credentials provided.")
        return {"statusCode": 403, "body": "Incomplete AWS credentials."}
    except Exception as e:
        print(f"An error occurred during S3 upload: {e}")
        return {"statusCode": 500, "body": f"S3 upload failed: {e}"}
                                                   