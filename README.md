# What's up with `includes`?

There's a strange interaction with ActiveRecord's `includes` and `select` and
`where`. The `SELECT` portion of the query is being over-written when you put
`WHERE` constraints on your query.

I made [an example gist](https://gist.github.com/benhamill/6162089) in
accordance with Rails's guidelines for making Issues. Continue below if you want
an interactive pry example so that you can play with it.

## Set Up

Run `bundle install` then `rake db:setup` to get the DB right. After that, `rake
console` will put you into a Pry session with useful classes loaded and will
show you an example query.

## What's Going On

The crux is that

```ruby
User.select('random() AS ranking').order('ranking').includes(:comments).to_a
```

runs

```sql
SELECT random() AS ranking
FROM "users"
ORDER BY ranking
```

whereas

```ruby
User.select('random() AS ranking').order('ranking').includes(:comments) \
  .where(comments: { id: 1 }).to_a
```

runs

```sql
SELECT "users"."id" AS t0_r0,
       "users"."name" AS t0_r1,
       "comments"."id" AS t1_r0,
       "comments"."body" AS t1_r1,
       "comments"."user_id" AS t1_r2
FROM "users"
LEFT OUTER JOIN "comments" ON "comments"."user_id" = "users"."id"
WHERE "comments"."id" = 1
ORDER BY ranking
```

Notice how `ranking` has been removed from the `SELECT` clause in the second
query.
