# A Filter Example with Single Filter Block.
In this example, we have one `filter { }` block, which manipulate similar fields.

```perl
# Parse an authentication header and get details
filter {
  if [message] =~ "Authentication_request: " {
    grok {
      match => {
        message => "Authentication_request: %{GREEDYDATA:auth_message}"
      }
    }
    add_field => {
      "sub_type" => "authentication"
    }
  }

  # Parse messages like "auth_type=saml auth_user=hildegard@example.com application=testapp"
  if [sub_type] == "authentication" {
    kv {
      source => "auth_message"
    }
  }
}

```
How does the order of declaration change the order of logic?
