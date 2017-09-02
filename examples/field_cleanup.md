# Field Cleanup Example
In this example, we show a filter-block that casts various fields to specific
data-types. This is done to ensure type-conversions are handled correctly, and
to ensure that the generated index can be loaded after a future ElasticSearch
2.x upgrade.

```ruby
filter {

  mutate {
    convert => {
      "priority" => "string",
      "value" => "float"
      "response_code" => "long"
    }
  }

  if "metric" in [tags] {
    mutate {
      convert => { "metric_value" => "float" }
    }
  }

  if [type] == "cheese_api" {
    mutate {
      convert => {
        "status_code" => "long",
        "runtime" => "float"
      }
      remove_field => [ "subtype" ]
    }
  }

}
```

Put this type of block at the end of your filter-chains, the last step before
the pipeline enters the `output {}` stage. This is a cleanup step. For larger
environments, you'll still need this even after getting to ES 2.x, simply to
catch problems earlier.
