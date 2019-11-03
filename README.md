# API DOCS

## Tables

- Common route: /tables

### Get all tables: ""
Example: 
- GET /tables
- Response:  
```javascript
[
    {  
    "id": Int,  
    "title": String  
    }, ...
]
```

### Get tables by id: /{id}
Example:
- GET /tables/1
- Response:
```javascript
{ // Table Entity
    "id": Int,
    "title": String
}
```

### Create table: /create
Example:
- POST /tables/create
- Body: 
```javascript
{
    "title": String
}
```
- Response:
Same as /tables/{id}

### Change table title: /{id}/update/title
Example:
- PUT /tables/1/update/title
- Body:
```javascript
{
    "id": Int,
    "title": String
}
```
- Response: 200 OK

## Lists

- Common route: /lists

### Get all lists: ""
Example:
- GET /lists
- Response:
```javascript
{
    [
        {
            "id": Int,
            "tableId": Int,
            "title": String
        }, ...
    ]
}
```

### Get lists by id: /{id}
Example:
- GET /lists/1
- Response:
```javascript
{
    "id": Int,
    "tableId": Int,
    "title": String
}
```

### Create list: /create
Example:
- POST /lists/create
- Body:
```javascript
{
    "tableId": Int,
    "title": String
}
```
- Response:
```javascript
{
    "id": Int,
    "tableId": Int,
    "title": String
}
```