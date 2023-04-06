import json
import os
from pytumblr import TumblrRestClient

creds_path = os.path.expanduser('~') + '/.tumblr'
creds = json.load(open(creds_path))

client = TumblrRestClient(
        creds['consumer_key'],
        creds['consumer_secret'],
        creds['access_token'],
        creds['access_token_secret'],
        )

blogName = 'cheeky-landos'
queue_tag = 'queue'

response = client.queue(blogName, limit=50)
posts = response['posts']

for post in reversed(posts):
    post_id = post['id']
    post_type = post['type']
    post_tags = post['tags']
    tags = set(post_tags)

    if not(queue_tag in tags):
        post_tags.append(queue_tag)
        client.edit_post(blogName, id=post_id, type=post_type, tags=post_tags)
    else:
        break
