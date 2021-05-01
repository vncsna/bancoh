bancoh
===

[![CI](https://github.com/vncsna/bancoh/actions/workflows/build.yml/badge.svg)](https://github.com/vncsna/bancoh/actions/workflows/build.yml)
[![Coverage Status](https://coveralls.io/repos/github/vncsna/bancoh/badge.svg?branch=test)](https://coveralls.io/github/vncsna/bancoh?branch=test)

(Toy) Bank API with accounts and transactions.  
It's possible to create accounts and transfer money between accounts.

# usage

<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->

<details>
  
<summary><code>POST</code> <code><b>/api/users</b></code> <code>(creates an account)</code></summary>

##### Parameters

> | name | parameter type | data type | description |
> |---|---|---|---|
> | user   | required body    | JSON        | user parameters   |

##### Responses

> | http code | content-type | response |
> |---|---|---|
> | `201` | `application/json` | user params |
> | `422` | `application/json` | process errors |

##### Example cURL

```curlrc
curl --location --request POST 'https://bancoh.herokuapp.com/api/users' \
--header 'Content-Type: application/json' \
--data-raw '{
    "user": {
        "balance": 100,
        "name": "John",
        "ssn": "00000000000",
        "surname": "Doe",
        "password": "password"
    }
}'
```

</details>

<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->

<details>
  
<summary><code>GET</code> <code><b>/api/users</b></code> <code>(gets an account)</code></summary>

##### Parameters

> | name | parameter type | data type | description |
> |---|---|---|---|
> | authorization | required header | Bearer Token | `/api/users/auth` token |

##### Responses

> | http code | content-type | response |
> |---|---|---|
> | `201` | `application/json` | user params |
> | `401` | `application/json` | `Unauthorized` |
> | `422` | `application/json` | process errors |

##### Example cURL

```curlrc
curl --location --request GET 'https://bancoh.herokuapp.com/api/users' \
--header 'Authorization: Bearer SFMyNTY.g2gDdAAAAAFkAAxjdXJyZW50X3VzZXJhAW4GAIJgOSR5AWIAAVGA.j2KSa1klN9EFwI-aUoXg7TV9qP5VJHVoefbaQCXtXBk'
```

</details>

<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->

<details>
  
<summary><code>POST</code> <code><b>/api/users/auth</b></code> <code>(authenticates an account)</code></summary>

##### Parameters

> | name | parameter type | data type | description |
> |---|---|---|---|
> | user   | required body    | JSON        | login parameters   |

##### Responses

> | http code | content-type | response |
> |---|---|---|
> | `201` | `application/json` | user params |
> | `422` | `application/json` | process errors |

##### Example cURL

```curlrc
curl --location --request POST 'https://bancoh.herokuapp.com/api/users/auth' \
--header 'Content-Type: application/json' \
--data-raw '{
    "user": {
        "ssn": "00000000001",
        "password": "password"
    }
}'
```

</details>

<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->

<details>
  
<summary><code>POST</code> <code><b>/api/transfers</b></code> <code>(creates a transfer)</code></summary>

##### Parameters

> | name | parameter type | data type | description |
> |---|---|---|---|
> | authorization | required header | Bearer Token | `/api/users/auth` token |
> | transfer | required body | JSON | transfer parameters |

##### Responses

> | http code | content-type | response |
> |---|---|---|
> | `201` | `application/json` | user params |
> | `401` | `application/json` | `Unauthorized` |
> | `422` | `application/json` | process errors |

##### Example cURL

```curlrc
curl --location --request POST 'https://bancoh.herokuapp.com/api/transfers' \
--header 'Authorization: Bearer SFMyNTY.g2gDdAAAAAFkAAxjdXJyZW50X3VzZXJhAW4GAIJgOSR5AWIAAVGA.j2KSa1klN9EFwI-aUoXg7TV9qP5VJHVoefbaQCXtXBk' \
--header 'Content-Type: application/json' \
--data-raw '{
    "transfer": {
        "balance": 20,
        "receiver_id": "2"
    }
}'
```

</details>

<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->

<details>
  
<summary><code>GET</code> <code><b>/api/transfers?date_fr={date_fr}&date_to={date_to}</b></code> <code>(list transfers by date)</code></summary>

##### Parameters

> | name | parameter type | data type | description |
> |---|---|---|---|
> | authorization | required header | Bearer Token | `/api/users/auth` token |
> | date_fr   | required query | YYYY-MM-DD date         | start date for request                                                |
> | date_to   | required query | YYYY-MM-DD date         | end date for request                                                  |

##### Responses

> | http code | content-type | response |
> |---|---|---|
> | `201` | `application/json` | user params |
> | `401` | `application/json` | `Unauthorized` |
> | `422` | `application/json` | process errors |

##### Example cURL

```curlrc
curl --location --request GET 'https://bancoh.herokuapp.com/api/transfers?date_fr=2021-04-22&date_to=2021-04-24' \
--header 'Authorization: Bearer SFMyNTY.g2gDdAAAAAFkAAxjdXJyZW50X3VzZXJhAW4GAIJgOSR5AWIAAVGA.j2KSa1klN9EFwI-aUoXg7TV9qP5VJHVoefbaQCXtXBk'
```

</details>

<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------->

<details>
  
<summary><code>PUT</code> <code><b>/api/transfers/:id</b></code> <code>(refund a transfer)</code></summary>

##### Parameters

> | name | parameter type | data type | description |
> |---|---|---|---|
> | authorization | required header | Bearer Token | `/api/users/auth` token |
> | id        |  required path | int                     | transfer id to be refunded      |


##### Responses

> | http code | content-type | response |
> |---|---|---|
> | `201` | `application/json` | user params |
> | `401` | `application/json` | `Unauthorized` |
> | `422` | `application/json` | process errors |

##### Example cURL

```curlrc
curl --location --request PUT 'https://bancoh.herokuapp.com/api/transfers/1' \
--header 'Authorization: Bearer SFMyNTY.g2gDdAAAAAFkAAxjdXJyZW50X3VzZXJhAW4GAIJgOSR5AWIAAVGA.j2KSa1klN9EFwI-aUoXg7TV9qP5VJHVoefbaQCXtXBk'
```

</details>