# Chat System

## Introduction

This chat system was built as part of the Instabug Backend Engineer Job Application Process, It was built using Ruby on Rails, Elasticsearch and Docker.

## Description

A containerized RESTful api that allows for the creation of different chat applications each application has multiple chats and each chat has multiple messages. 


## Installation 

Clone the github repo using git clone, then run:

```sh
docker-compose up
```


## Api Endpoints

### Applications

Create a new application, returns Unique Token to identify the application
```sh
POST /applications?name={application_name}
```

Retrives the application name and the count of chats related to the application
```sh
GET /applications/{application_token}
```

Updates the application name
```sh
PATCH/PUT /applications/{application_token}?name={new_application_name}
```

Deletes the application and all the chats and messages related to it
```sh
DELETE /applications/{application_token}
```

Retrives a list of all applications names maintained by the system
```sh
GET /applications
```

### Chats

Create a new chat and returns a unique id identifying the chat within the application
```sh
POST /applications/{application_token}/chats
```

Retrives the chat 
```sh
GET /applications/{application_token}/chats/{chat_id}
```

Retrives a list of all chats
```sh
GET /applications/{application_token}/chats
```

Deletes the chat
```sh
DELETE /applications/{application_token}/chats/{chat_id}
```

### Messages

Create a new message, returns a unique id identifying the message within the chat
```sh
POST /applications/{application_token}/chats/{chat_id}/messages
```

Create a specific message by id
```sh
GET /applications/{application_token}/chats/{chat_id}/messages/{message_id}
```

Create a list of messages
```sh
GET /applications/{application_token}/chats/{chat_id}/messages
```

Search for messages within chat that partly match the search_term
```sh
GET /applications/{application_token}/chats/{chat_id}/messages?search={search_term}
```

Deletes a message
```sh
DELETE /applications/{application_token}/chats/{chat_id}/messages/{message_id}
```

Updates a message body to be new_meesage
```sh
DELETE /applications/{application_token}/chats/{chat_id}/messages/{message_id}?body={new_message}
```
