#!/bin/sh
# inbox.sh <function> [json | @file] : one call to one of the inbox routine's narrow Supabase functions.
# The key below is the site's publishable key: public by design, the same one every browser on rowdyql.com uses.
# What opens the inbox_* functions is the x-inbox header, which the cloud environment's proxy adds on its own;
# this script never sees it, and nothing here can reach a table directly.
BASE=https://afzlmlbigruxijudqukp.supabase.co/rest/v1/rpc
KEY=sb_publishable_VqElbkoG6ZWGI4VtWEZ7Tw_Quqxv1fR
case "$1" in
  inbox_seen|inbox_who|inbox_add|inbox_followup|inbox_pending|inbox_draft|inbox_summary) ;;
  *) echo "usage: inbox.sh inbox_pending|inbox_draft|inbox_who|inbox_summary|inbox_seen|inbox_add|inbox_followup [json | @file]" >&2; exit 2 ;;
esac
DATA=${2:-'{}'}
curl -s -X POST "$BASE/$1" -H "apikey: $KEY" -H "Content-Type: application/json" --data-binary "$DATA"
echo
