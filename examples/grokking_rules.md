# Grok Performance Rules

1. Parse failures are very expensive. Structure your filters to avoid them.
1. Do your broad captures early in your filter sections.
1. Refine broadly captured fields in later grok filters.
1. Anchor your regexes. [This reduces substring searching.](https://www.elastic.co/blog/do-you-grok-grok)
1. Only use `%{GREEDYDATA}` at the end of a capture. Reduces back-tracking.
1. Use an internal-log format standard. Greatly eases grok construction.
1. Convert your plain language `Created account #{x} in zone #{y} with email #{z}` log-statements to something machine parseable.

## Avoid the dictionary anti-pattern:

Don't do this:

```perl
filter {
  if [type] == "applog"
    grok {
      match => {
        "message" => [
          "%{SYSLOGTIMESTAMP} \[%{WORD:component}\] %{WORD:acct_action} account %{BASE16NUM:acct_num} in zone %{BASE16NUM:zone_id} with email %{EMAILADDRESS:email_address}",
          "%{SYSLOGTIMESTAMP} \[%{WORD:component}\] Account %{BASE16NUM:acct_num} %{WORD:acct_action} from zone %{BASE16NUM:zone_id}",
          "%{SYSLOGTIMESTAMP} \[%{WORD:component}\] %{WORD:acct_action} zone %{BASE16NUM:zone_id} account %{BASE16NUM:acct_num} for %{GREEDYDATA:suspension_reason}",
          "%{SYSLOGTIMESTAMP} \[%{WORD:component}\] %{WORD:zone_action} new zone: %{BASE16NUM:zone_id}",
          "%{SYSLOGTIMESTAMP} \[%{WORD:component}\] Zone %{BASE16NUM:zone_id} %{WORD:zone_action}",
          "%{SYSLOGTIMESTAMP} \[%{WORD:component}\] %{GREEDYDATA:app_logline}"
        ]
    }
  }
}
```
The temptation with grok matches is to treat it like a dictionary. Since matches
are run in order, start with the most specific filters and get broader, finishing
with a catch-all statement to sweep up the remainers. *This will destroy your performance*.
Remember, each grok-miss is expensive. Constructing it like this ensures that most
log-lines will get missed several times before getting matched.

This is terse, and shows your intent. However, it's *really bad*.

The above can be made to perform much better without modifying the log-format:

```perl
filter {
  if [type] == "applog"
    grok {
      match => {
        "message" => [
          "^%{SYSLOGTIMESTAMP} \[%WORD:component}\] %{GREEDYDATA:app_logline}$"
        ]
      }
    }
    if [component] == "account" {
      grok {
        match => {
          "app_logline" => [
            "^%{WORD:acct_action} account %{BASE16NUM:acct_num} in zone %{BASE16NUM:zone_id} with email %{EMAILADDRESS:email_address}$",
            "^%{SYSLOGTIMESTAMP} \[%{WORD:component}\] Account %{BASE16NUM:acct_num} %{WORD:acct_action} from zone %{BASE16NUM:zone_id}$",
            "^%{WORD:acct_action} zone %{BASE16NUM:zone_id} account %{BASE16NUM:acct_num} for %{GREEDYDATA:suspension_reason}$"
          ]
        }
      }
    }
    if [component] == "zone" {
      grok {
        match => {
          "app_logline" => [
            "^%{WORD:zone_action} new zone: %{BASE16NUM:zone_id}$",
            "^Zone %{BASE16NUM:zone_id} %{WORD:zone_action}$"
          ]
        }
      }
    }
  }
}
```

This is much longer, but it will perform *much* better. While it still uses
dictionaries, the grok expressions are now anchored (see the `^` and `$` 
characters) which will improve performance. Also, we use conditional statements
to avoid grok-parsing lines against patterns we already know won't match.

After the work to convert to grok-ready log-statements, we can do away
with dictionaries entirely:

```perl
filter {
  if [type] == "applog"
    grok {
      match => {
        "message" => [
          "^%{SYSLOGTIMESTAMP} \[%WORD:component}\] %{GREEDYDATA:app_logline}$"
        ]
      }
    }
    if [component] == "account" {
      grok {
        match => {
          "app_logline" => [
            "^{WORD:acct_action} %{BASE16NUM:acct_num} in zone %{BASE16NUM:zone_id}( %{GREEDYDATA:acct_extra})$"
          ]
        }
      }
    } else if [component] == "zone" {
      grok {
        match => {
          "app_logline" => [
            "^%{WORD:zone_action} %{BASE16NUM:zone_id}$"
          ]
        }
      }
    }
    if [acct_action] == "Created" {
      grok {
        match => {
          "acct_extra" => [
            "with email address %{EMAILADDRESS:email_address}$"
          ]
        }
      }
      mutate {
        remove_field => [ "acct_extra" ]
      }
    } else if [acct_action] == "Suspended" {
      grok {
        match => {
          "acct_extra" => [
            "for %{GREEDYDATA:suspension_reason}$"
          ]
        }
      }
      mutate {
        remove_field => [ "acct_extra" ]
      }
    }
  }
}
```
This version avoids dictionaries all together, and uses conditionals to ensure
that each grok-expression is only matched against a string that is highly
likely to match.
