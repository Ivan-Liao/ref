import boto3
from secrets import AWS_S3_ID, AWS_S3_PASSWORD
import time

"""
Configuration
"""
sqs = boto3.resource(
    "sqs",
    aws_access_key_id=AWS_S3_ID,
    aws_secret_access_key=AWS_S3_PASSWORD,
    region_name="us-east-1",
)

"""
Functions
"""


def create_queue():
    queue = sqs.create_queue(QueueName="test", Attributes={"DelaySeconds": "5"})

    print(queue.url)
    print(queue.attributes.get("DelaySeconds"))


def show_queues():
    # get a queue by name
    queue = sqs.get_queue_by_name(QueueName="test")
    print(queue.url)
    print(queue.attributes.get("DelaySeconds"))

    # print all queues
    print("displaying all queues")
    for queue in sqs.queues.all():
        print(queue.url)


def send_messages(queue_name):
    # get queue
    queue = sqs.get_queue_by_name(QueueName=queue_name)
    # # send message
    # response = queue.send_message(MessageBody="world")
    # # print response attributes
    # print(response.get("MessageId"))
    # print(response.get("MD5OfMessageBody"))
    # print(response["ResponseMetadata"].get("HTTPStatusCode"))
    # response_2 = queue.send_message(
    #     MessageBody="custom attributes test",
    #     MessageAttributes={"Author": {"StringValue": "Ivan", "DataType": "String"}},
    # )
    # print(response_2)
    # print(response["ResponseMetadata"].get("HTTPStatusCode"))
    # print(response_2.get("Author"))
    # possible to batch send messages via queue.send_messages(), see docs
    response = queue.send_messages(
        Entries=[
            {"Id": "1", "MessageBody": "world"},
            {
                "Id": "2",
                "MessageBody": "boto3",
                "MessageAttributes": {
                    "Author": {"StringValue": "Daniel", "DataType": "String"}
                },
            },
        ]
    )
    # Print out any failures
    print(response.get("Failed"))


def process_messages(queue_name):
    queue = sqs.get_queue_by_name(QueueName=queue_name)
    # Process messages by printing out body and optional author name
    empty_queue_flag = False
    while not empty_queue_flag:
        messages = queue.receive_messages(MessageAttributeNames=["Author"])
        if len(messages) == 0:
            empty_queue_flag = 1
        for message in messages:
            # Get the custom author message attribute if it was set
            author_text = ""
            if message.message_attributes is not None:
                author_name = message.message_attributes.get("Author").get("StringValue")
                if author_name:
                    
                    author_text = " ({0})".format(author_name)

            # Print out the body and author (if set)
            print("Hello, {0}!{1}".format(message.body, author_text))

            # Let the queue know that the message is processed
            message.delete()


if __name__ == "__main__":
    # create_queue()
    # show_queues()
    send_messages("test")
    time.sleep(5)
    process_messages("test")
