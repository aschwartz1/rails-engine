# Rails Engine
_A model RESTful, JSON:API compliant API for a fictional e-commerce application._

Track Merchants and their items, invoices, and transactions.

## Contributors
  - [Alex Schwartz](https://www.linkedin.com/in/alex-s-77659758/)

## Endpoints Index
  - [Merchants](#merchants)
  - [Items](#items)
  - [Revenue](#revenue)

## Endpoints
### Merchants
**Get all merchants**
> `GET /api/v1/merchants` will return data in the form:
>```json
>{
>  "data": [
>   {
>    "id": "1",
>    "type": "merchant",
>    "attributes": {
>      "name": "WPI Records"
>   },
>   {
>    "id": "2",
>    "type": "merchant",
>    "attributes": {
>      "name": "Brahan's Books"
>    },
>    ...
>  ]
>}
>```

  - Notes
    - Paginated, defaulted to 20 per page & page 1
  - Optional parameters
    - `page`, an integer greater than 0 to specify the page of records requested
      - Will return `"data": []` if page would contain no data
    - `per_page`, an integer greater than 0 to specifiy the number of records to return per page
    - Paginataion params may be used independently
    - Ex. `GET /api/v1/merchants?per_page=10&page=2`


**Get one merchant**
> `GET /api/v1/merchant/:id` for an `:id` of 1 will return data in the form
>```json
>{
>  "data":
>   {
>    "id": "1",
>    "type": "merchant",
>    "attributes": {
>      "name": "WPI Records"
>    }
>  }
>}
>```

  - Notes
    - Returns a `404` if no merchant exists with `:id`


**Search for merchant by name**
> `GET /api/v1/merchants/find_one?name=<search_sring>`
  - Returns data for a single merchant

> `GET /api/v1/merchants/find_all?name=<search_string>`
  - Returns data for any merchants matching criteria

**Get merchant's items**
> 'GET /api/v1/merchants/:id/items'
  - Notes
    - Success returns a list of items, see _Get all items_ definition below
    - Failure returns `404`

### Items
**Get all items**
> `GET /api/v1/items`
>```json
>{
>  "data": [
>   {
>    "id": "1",
>    "type": "item",
>    "attributes": {
>      "name": "When The Blood Comes Home Demo",
>      "description": "The sound of WPI",
>      "unit_price": 29.99
>   },
>   {
>    "id": "2",
>    "type": "item",
>    "attributes": {
>      "name": "Run of the mill widget",
>      "description": "meh",
>      "unit_price": 0.99
>    },
>    ...
>  ]
>}
>```

  - Notes
    - See [get all merchants](#get_all_merchants) for pagination information

**Get one item**
> `GET /api/v1/item/:id` for an `:id` of 1 will return data in the form
>```json
>{
>  "data":
>   {
>    "id": "1",
>    "type": "item",
>    "attributes": {
>      "name": "When The Blood Comes Home Demo",
>      "description": "The sound of WPI",
>      "unit_price": 29.99
>   }
>}
>```

  - Notes
    - Returns a `404` if no merchant exists with supplied `:id`

**Create an item**
> `POST /api/v1/items`, accepts a body which MUST look like:
>```json
>{
>   "name": "When The Blood Comes Home Demo",
>   "description": "The sound of WPI",
>   "unit_price": 29.99,
>   "merchant_id": 2
>}
>```

  - Notes
    - Returns `400` if any parameters are missing
    - A `merchant` with `"merchant_id"` must exist in the system

**Update an item**
> `PATCH /api/v1/items/:id`, accepts a body which can contain at most:
>```json
>{
>   "name": "A little better widget",
>   "description": "Shinier!",
>   "unit_price": 2.99,
>   "merchant_id": 2
>}
>```


**Destroy an item**
> `DELETE /api/v1/items/:id`

  - Notes
    - Success returns a `204`

### Revenue
**Get a merchant's total revenue**
> 'GET /api/v1/revenue/merchants/:id'
>```json
>{
>  "data":
>   {
>    "id": "1",
>    "type": "merchant_revenue",
>    "attributes": {
>      "revenue": 999.01
>    }
>  }
>}
>```

**Get <x> top merchants by revenue**
> `GET /api/v1/revenue/merchants?quantity=<number_of_merchants>` for a `:quantity` of 1 will return data in the form
>```json
>{
>  "data": [
>   {
>    "id": "1",
>    "type": "merchant_name_revenue",
>    "attributes": {
>      "name": "WPI Records",
       "revenue": 999.01
     }
>   },
>   {
>    "id": "2",
>    "type": "merchant_name_revenue",
>    "attributes": {
>      "name": "Brahan's Books"
       "revenue": 10.0
>     }
>    },
>    ...
>  ]
>}
>```
  - Notes
    - `quantity` must exist and be an integer > 0
