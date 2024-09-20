import boto3
import os
import logging
import json
from decimal import Decimal

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Helper function to convert Decimal to int (or float if needed)
def decimal_default(obj):
    if isinstance(obj, Decimal):
        return int(obj)  # or float(obj) if the decimal is not a whole number
    raise TypeError

def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")  # Log the complete event
    logger.info(f"Context: {context}")

    try:
        dynamodb = boto3.resource('dynamodb')
        table_name = os.environ['DynamoDBTableName']

        # If you want to use a static post_id, replace 'default_post_id' with your chosen ID
        post_id = 'default_post_id'

        logger.info(f"Updating view count for PostID: {post_id} in table: {table_name}")

        table = dynamodb.Table(table_name)

        response = table.update_item(
            Key={'PostID': post_id},
            UpdateExpression='ADD ViewCount :inc',
            ExpressionAttributeValues={':inc': 1},
            ReturnValues='UPDATED_NEW'
        )

        logger.info(f"Update response: {response}")

        return {
            'statusCode': 200,
            # Use the decimal_default function to convert Decimal to int before JSON serialization
            'body': json.dumps({'ViewCount': response['Attributes']['ViewCount']}, default=decimal_default)
        }

    except Exception as e:
        logger.error("Exception encountered", exc_info=True)
        return {
            'statusCode': 500,
            'body': json.dumps({'Error': 'Error updating view count'}, default=decimal_default)
        }
