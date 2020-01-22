# "Push" notifications removal technique

This project demonstrates how you can implement the removal of notifications from the iOS notification center. This can be used, for example, in instant messengers to delete notifications after the user has read them on another device. Basicly the idea is following:
Backend is sending only "silent" notifications of 2 types. One type of notification is regular message from sender with `sender_id`. For example, payload
```json
{
  "aps":{
    "content-available" : 1
  },
  "data": {
    "type": "message",
    "sender_id": "1",
    "sender_name": "John",
    "message": "Hello!"
  }
}
```
And the second type is "removing" notification, that signals that all notifications with given `sender_id` should be deleted from notifications center.
```json
{
  "aps":{
    "content-available" : 1
  },
  "data": {
    "type": "remove",
    "sender_id": "1",
  }
}
```
