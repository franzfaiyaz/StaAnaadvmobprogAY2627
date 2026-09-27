
## Student Information

Name: Justine Francis Sta. Ana

Course: CTADMOBL – Advance Mobile Programming

Lab Activity: Lab Activity 6
# Lab Activity 6: Discussion

## Firestore user profiles

When a Firebase account is created or signs in the application stores its profile in the `Users` collection. The Firebase UID is used as the document ID. Is also saved in the `uid` field. The document has profile information like the email address, first name, last name, username, age, phone number and profile image. Authentication tokens and passwords are not saved in this collection.

Each conversation is saved in `chat_rooms/{chatRoomId}/messages`. The room ID is created by sorting the two Firebase UIDs and then joining them with an underscore. Because the same two IDs create the sorted value, for either person both users end up in the same room.

Each message document has the sender UID and email the UID, the message text and a Firestore timestamp. The application watches the rooms `messages` subcollection using Firestore snapshots that are ordered by timestamp. When a message is sent or received the stream updates the chat screen without needing a refresh.

The chat list leaves out the signed-in Firebase user so they can't usually choose themselves. The chat service also checks the sender and receiver UIDs before starting a conversation or sending a message. If they are the same the action is blocked with an error message.
