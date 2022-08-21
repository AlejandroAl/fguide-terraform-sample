terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
    }
  }
}

provider "snowflake" {
  role  = "SYSADMIN"
}


resource "snowflake_database" "raw" {
  name                        = "RAW"
  comment                     = "Raw comment"
  data_retention_time_in_days = 3
}

resource "snowflake_database" "analytics" {
  name                        = "ANALYTICS"
  comment                     = "Analytics comment"
  data_retention_time_in_days = 3
}

resource "snowflake_schema" "jaffle_shop" {
  database = snowflake_database.raw.name
  name     = "JAFFLE_SHOP"
  comment  = "A schema."

}

resource "snowflake_schema" "stripe" {
  database = snowflake_database.raw.name
  name     = "STRIPE"
  comment  = "A schema."

}

resource "snowflake_table" "table_customers" {
  database            = snowflake_schema.jaffle_shop.database
  schema              = snowflake_schema.jaffle_shop.name
  name                = "CUSTOMERS"
  comment             = "A table."

  column {
    name     = "ID"
    type     = "integer"
    nullable = true
  }

  column {
    name     = "FIRST_NAME"
    type     = "varchar"
    nullable = true
  }

  column {
    name = "LAST_NAME"
    type = "varchar"
  }

}

resource "snowflake_table" "table_orders" {
  database            = snowflake_schema.jaffle_shop.database
  schema              = snowflake_schema.jaffle_shop.name
  name                = "ORDERS"
  comment             = "A table."

  column {
    name     = "ID"
    type     = "integer"
    nullable = true
  }

  column {
    name     = "USER_ID"
    type     = "integer"
    nullable = true
  }

  column {
    name     = "ORDER_DATE"
    type     = "date"
    nullable = true
  }

  column {
    name = "STATUS"
    type = "varchar"
  }

  column {
    name = "_ETL_LOADED_AT"
    type = "timestamp"
    default {
      expression = "current_timestamp()"
    }
  }

}

resource "snowflake_table" "payment" {
  database            = snowflake_schema.stripe.database
  schema              = snowflake_schema.stripe.name
  name                = "PAYMENT"
  comment             = "A table."

  column {
    name     = "ID"
    type     = "integer"
    nullable = true
  }

  column {
    name     = "ORDERID"
    type     = "integer"
    nullable = true
  }

  column {
    name = "PAYMENTMETHOD"
    type = "varchar"
  }

  column {
    name = "STATUS"
    type = "varchar"
  }


  column {
    name = "AMOUNT"
    type = "integer"
  }

  column {
    name = "CREATED"
    type = "date"
  }

  column {
    name = "_BATCHED_AT"
    type = "timestamp"
    default {
      expression = "current_timestamp()"
    }
  }


}
