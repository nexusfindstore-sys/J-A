# Make the guestbook and RSVP public

This site deliberately does not store wishes or RSVP data in the browser. It needs a Supabase project before these two forms can save public data.

1. Create a Supabase project and open its **SQL Editor**.
2. Run [`supabase/schema.sql`](supabase/schema.sql).
3. In `config.js`, enter only the project URL and **anon public key** under `backend`. Never put a service-role key in this website.
4. Open the Supabase Table Editor to approve or hide wishes. RSVPs and phone numbers are visible only to authenticated project admins there.
5. Export RSVPs from the Table Editor as CSV. The `attendance_summary` view provides the current public totals.

The forms remain disabled with an explicit setup message until those two settings are added. Deploy the folder to a host such as Netlify, Vercel, or Cloudflare Pages to receive a public URL; then set `og:image` in `index.html` to an absolute public image URL for WhatsApp previews.
