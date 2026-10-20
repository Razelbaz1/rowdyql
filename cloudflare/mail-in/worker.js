// rowdyql-mail-in: Cloudflare Email Routing hands every message to hello@rowdyql.com to this Worker (2026-10-20).
// It keeps a copy in Raz's Gmail (COPY_TO, until RowdyQL has a mailbox of its own) and passes the message to the mail-in
// Edge Function, which parses it and files it as a request (public.mail_add). It parses nothing itself: the free plan
// gives a Worker 10 ms of CPU per message, and a message with attachments could need more.
// Bindings: COPY_TO (a verified destination address), MAIL_IN_URL (the Edge Function), MAIL_KEY (secret; its sha256 is in mail_ok()).
const MAX = 1500000; // bytes; a bigger message (attachments) goes in as its headers only, and the full one stays in the copy

export default {
  async email(message, env) {
    const h = k => message.headers.get(k) || '';
    let body, type;
    if (message.rawSize <= MAX) { body = await new Response(message.raw).arrayBuffer(); type = 'message/rfc822'; }
    else {
      body = JSON.stringify({ big: true, size: message.rawSize, from: h('from'), subject: h('subject'), message_id: h('message-id'), in_reply_to: h('in-reply-to'), references: h('references') });
      type = 'application/json';
    }
    try { await message.forward(env.COPY_TO); } catch (e) { console.log('copy failed', String(e)); }
    try {
      const r = await fetch(env.MAIL_IN_URL, { method: 'POST', headers: { 'content-type': type, 'x-mail': env.MAIL_KEY }, body });
      if (!r.ok) console.log('mail-in', r.status, (await r.text()).slice(0, 300));
    } catch (e) { console.log('mail-in unreachable', String(e)); } // the copy in Gmail still has it
  }
};
