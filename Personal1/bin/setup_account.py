#!/usr/bin/env python

import argparse
from botocore.exceptions import ClientError
import boto3
import os


class SetupAccount:

    def __init__(self):
        self.args = self.parse_args()
        self.session = boto3.Session(region_name=self.args.region)
        self.deployment_role_name = self.args.env+"DeploymentRole"

    @staticmethod
    def parse_args():
        parser = argparse.ArgumentParser(
            formatter_class=argparse.RawTextHelpFormatter,
            description='''

                Initial bootstrap for PDU account.

                The script requires the options:

                    - env               Environment to use as target
                    - account-id        PDU account ID

                The option "bucket" create a bucket to use for storing the Terraform state files.

                The option "dynamo-db" create a Dynamo DB table to use for the Terraform state locks.

                If all the options are set, the script generates a back

            ''')

        parser.add_argument('--env',
                            required=True, help='The environment to use as target')
        parser.add_argument('--account-id',
                            required=True, help='Account ID')
        parser.add_argument('--bucket',
                            help='Name of bucket')
        parser.add_argument('--kms-key',
                            help='Name of the kms key')
        parser.add_argument('--dynamo-db',
                            help='Create DynamoDB table for locking Terraform states')
        parser.add_argument('--region',
                            default='eu-west-2', help='AWS Region to use')
        parser.add_argument('--deployment-role-policy',
                            default='policies/deployment_role.json', help='Deployment role policy')
        parser.add_argument('--trust-relationship-policy',
                            default='policies/trust_relationship_policy.json',
                            help='Trust Relationship policy for deployment role')

        return parser.parse_args()

    def create_bucket(self):
        try:
            client = self.session.client('s3')
            print(client.list_buckets())
            if not any(d for d in client.list_buckets()["Buckets"] if d['Name'] == self.args.bucket):
                print('creating bucket ' + self.args.bucket)
                client.create_bucket(Bucket=self.args.bucket,
                                     CreateBucketConfiguration={'LocationConstraint': self.args.region})
            else:
                print('bucket ' + self.args.bucket + ' already exists')
        except ClientError as e:
            print('Error: ' + e.response['Error']['Message'])
        except Exception as exc:
            print(exc)

    def create_dynamo_db_table(self):
        try:
            client = self.session.client('dynamodb', region_name=self.args.region)
            if self.args.dynamo_db not in client.list_tables()['TableNames']:
                print('creating dynamodb table %s' % self.args.dynamo_db)
                client.create_table(
                    AttributeDefinitions=[{'AttributeName': 'LockID', 'AttributeType': 'S'}],
                    TableName=self.args.dynamo_db,
                    KeySchema=[{'AttributeName': 'LockID', 'KeyType': 'HASH'}],
                    ProvisionedThroughput={'ReadCapacityUnits': 2, 'WriteCapacityUnits': 2},
                )
            else:
                print('%s table exists!' % self.args.dynamo_db)
        except ClientError as e:
            print('Error ' + e.response['Error']['Message'])
        except Exception as exc:
            print(exc)

    def create_backend_configs(self):
        abspath = os.path.abspath('%s/../terraform' % os.path.dirname(__file__))
        root, dirs, _ = next(os.walk(abspath))
        for project in dirs:
            if not os.path.exists('%s/%s/terraform.tfvars' % (root, project)):
                continue
            backend_config = '%s/%s/backend_config' % (root, project)
            if not os.path.exists(backend_config):
                os.mkdir(backend_config)
            conf_file = '%s/%s.conf' % (backend_config, self.args.env)
            with open(conf_file, 'w') as conf:
                conf.write('kms_key_id="alias/%s"\n' % self.args.kms_key)
                conf.write('bucket="%s"\n' % self.args.bucket)
                conf.write('dynamodb_table="%s"\n' % self.args.dynamo_db)

    def execute(self):
        if self.args.bucket:
            self.create_bucket()
        if self.args.dynamo_db:
            self.create_dynamo_db_table()
        if self.args.bucket and self.args.kms_key is not None and self.args.dynamo_db:
            self.create_backend_configs()


if __name__ == "__main__":
    SetupAccount().execute()
