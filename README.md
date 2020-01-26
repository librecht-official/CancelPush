# "Push" notifications removal technique

This project demonstrates how you can implement the removal of notifications from the iOS notification center. This can be used, for example, in instant messengers to delete notifications after the user has read them on another device. Basicly the idea is following:
Backend is sending only "silent" notifications of 2 types. First type of notification is regular message from sender with `sender_id`. For example, payload
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
When the app receives such notification, it schedules almost immediate local notification and stores a link between notification id and `sender_id`.
The second type is "removing" notification, that signals that all notifications with given `sender_id` should be deleted from notifications center.
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
